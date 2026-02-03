import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../data/models/task_model.dart';
import '../data/models/history_model.dart';
import 'dart:async';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isProcessingSession = false;

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        await updateUserSettings(
          userId: result.user!.uid,
          focusTime: 25,
          shortBreak: 5,
          longBreak: 15,
          longBreakInterval: 4,
        );
      }
      return result.user;
    } catch (e) {
      debugPrint("Erro no Sign Up: ${e.toString()}");
      return null;
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      debugPrint("Erro no Sign In: ${e.toString()}");
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint("Erro no Sign Out: ${e.toString()}");
    }
  }

  Future<void> updateUserSettings({
    required String userId,
    required int focusTime,
    required int shortBreak,
    required int longBreak,
    required int longBreakInterval,
  }) async {
    try {
      final int safeInterval = longBreakInterval < 2 ? 2 : longBreakInterval;

      await _firestore.collection('users').doc(userId).set({
        'settings': {
          'focusTime': focusTime,
          'shortBreak': shortBreak,
          'longBreak': longBreak,
          'longBreakInterval': safeInterval,
        },
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Erro ao salvar configurações: $e");
    }
  }

  Stream<DocumentSnapshot> getUserSettings(String userId) {
    return _firestore.collection('users').doc(userId).snapshots();
  }

  Future<void> addTask(String title, int pomodoros) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore.collection('tasks').add({
        'title': title,
        'totalPomodoros': pomodoros,
        'completedPomodoros': 0,
        'isCompleted': false,
        'userId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Erro ao adicionar tarefa: $e");
      rethrow;
    }
  }

  Stream<List<TaskModel>> getTasks() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => TaskModel.fromFirestore(doc.id, doc.data()))
        .toList());
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
    } catch (e) {
      debugPrint("Erro ao excluir: $e");
      rethrow;
    }
  }

  Stream<List<HistoryModel>> getUserHistory() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('history')
        .where('userId', isEqualTo: user.uid)
        .orderBy('completedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => HistoryModel.fromFirestore(doc.id, doc.data()))
        .toList());
  }

  Future<void> completePomodoroSession({
    required String taskId,
    required String taskTitle,
    required int durationMinutes,
    required String type,
  }) async {
    if (_isProcessingSession) return;
    _isProcessingSession = true;

    try {
      final user = _auth.currentUser;
      if (user == null) return;

      WriteBatch batch = _firestore.batch();

      DocumentReference historyRef = _firestore.collection('history').doc();
      batch.set(historyRef, {
        'userId': user.uid,
        'taskId': taskId,
        'taskTitle': taskTitle,
        'durationMinutes': durationMinutes,
        'type': type,
        'completedAt': FieldValue.serverTimestamp(),
      });

      if (type == 'focus') {
        DocumentReference taskRef = _firestore.collection('tasks').doc(taskId);
        DocumentSnapshot taskDoc = await taskRef.get();

        if (taskDoc.exists) {
          final data = taskDoc.data() as Map<String, dynamic>;
          int current = data['completedPomodoros'] ?? 0;
          int total = data['totalPomodoros'] ?? 1;

          int nextValue = current + 1;
          bool isFinished = nextValue >= total;

          batch.update(taskRef, {
            'completedPomodoros': nextValue,
            'isCompleted': isFinished,
          });
        }
      }

      await batch.commit();
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      debugPrint("Erro ao completar sessão: $e");
    } finally {
      _isProcessingSession = false;
    }
  }
}