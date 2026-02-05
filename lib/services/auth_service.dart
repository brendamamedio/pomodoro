import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../data/models/task_model.dart';
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
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> updateUserSettings({
    required String userId,
    required int focusTime,
    required int shortBreak,
    required int longBreak,
    required int longBreakInterval,
  }) async {
    await _firestore.collection('users').doc(userId).set({
      'settings': {
        'focusTime': focusTime,
        'shortBreak': shortBreak,
        'longBreak': longBreak,
        'longBreakInterval': longBreakInterval,
      }
    }, SetOptions(merge: true));
  }

  Stream<DocumentSnapshot> getUserSettings(String userId) {
    return _firestore.collection('users').doc(userId).snapshots();
  }

  Future<void> addTask(String title, int totalPomodoros) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('tasks').add({
      'title': title,
      'totalPomodoros': totalPomodoros,
      'completedPomodoros': 0,
      'isCompleted': false,
      'userId': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<TaskModel>> getTasks() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => TaskModel.fromFirestore(doc.id, doc.data()))
        .toList());
  }

  Stream<List<TaskModel>> getActiveTasks() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: user.uid)
        .where('isCompleted', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => TaskModel.fromFirestore(doc.id, doc.data()))
        .toList());
  }

  Future<void> updateTask(String taskId, String title, int pomodoros) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        'title': title,
        'totalPomodoros': pomodoros,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleTaskCompletion(String taskId, bool currentStatus) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        'isCompleted': !currentStatus,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getTodayFocusCount() async {
    final user = _auth.currentUser;
    if (user == null) return 0;

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    final snapshot = await _firestore
        .collection('history')
        .where('userId', isEqualTo: user.uid)
        .where('type', isEqualTo: 'focus')
        .where('completedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .get();

    return snapshot.docs.length;
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

        batch.update(taskRef, {
          'completedPomodoros': FieldValue.increment(1),
        });

        final taskSnapshot = await taskRef.get();
        if (taskSnapshot.exists) {
          final data = taskSnapshot.data() as Map<String, dynamic>;
          int current = (data['completedPomodoros'] ?? 0) + 1;
          int total = data['totalPomodoros'] ?? 0;
          if (current >= total) {
            batch.update(taskRef, {'isCompleted': true});
          }
        }
      }

      await batch.commit();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isProcessingSession = false;
    }
  }

  Future<Map<String, double>> getWeeklyFocusStats() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return {};

      final now = DateTime.now();
      final lastWeek = now.subtract(const Duration(days: 7));

      final snapshot = await _firestore
          .collection('history')
          .where('userId', isEqualTo: user.uid)
          .where('type', isEqualTo: 'focus')
          .where('completedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(lastWeek))
          .get();

      Map<String, double> stats = {
        'Seg': 0, 'Ter': 0, 'Qua': 0, 'Qui': 0, 'Sex': 0, 'Sáb': 0, 'Dom': 0
      };

      final daysMap = {1: 'Seg', 2: 'Ter', 3: 'Qua', 4: 'Qui', 5: 'Sex', 6: 'Sáb', 7: 'Dom'};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final date = (data['completedAt'] as Timestamp).toDate();
        final dayName = daysMap[date.weekday];
        final duration = (data['durationMinutes'] as num).toDouble();

        if (dayName != null) {
          stats[dayName] = (stats[dayName] ?? 0) + duration;
        }
      }
      return stats;
    } catch (e) {
      return {'Seg': 0, 'Ter': 0, 'Qua': 0, 'Qui': 0, 'Sex': 0, 'Sáb': 0, 'Dom': 0};
    }
  }

  Future<int> getCurrentStreak() async {
    final user = _auth.currentUser;
    if (user == null) return 0;

    final snapshot = await _firestore
        .collection('history')
        .where('userId', isEqualTo: user.uid)
        .where('type', isEqualTo: 'focus')
        .orderBy('completedAt', descending: true)
        .get();

    if (snapshot.docs.isEmpty) return 0;

    Set<String> activeDays = snapshot.docs.map((doc) {
      final date = (doc.data()['completedAt'] as Timestamp).toDate();
      return "${date.year}-${date.month}-${date.day}";
    }).toSet();

    int streak = 0;
    DateTime checkDate = DateTime.now();

    while (activeDays.contains("${checkDate.year}-${checkDate.month}-${checkDate.day}")) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    return streak;
  }

  Future<List<double>> getContributionData() async {
    final user = _auth.currentUser;
    if (user == null) return List.filled(21, 0.0);

    final now = DateTime.now();
    final List<double> contributions = [];

    for (int i = 20; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final start = DateTime(date.year, date.month, date.day);
      final end = start.add(const Duration(days: 1));

      final snapshot = await _firestore
          .collection('history')
          .where('userId', isEqualTo: user.uid)
          .where('type', isEqualTo: 'focus')
          .where('completedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('completedAt', isLessThan: Timestamp.fromDate(end))
          .get();

      double intensity = (snapshot.docs.length / 4).clamp(0.0, 1.0);
      contributions.add(intensity);
    }
    return contributions;
  }
}