import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../data/models/task_model.dart';
import 'dart:async';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    await _auth.signOut();
  }

  Future<void> updateUserSettings({
    required String userId,
    required int focusTime,
    required int shortBreak,
    required int longBreak,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'settings': {
          'focusTime': focusTime,
          'shortBreak': shortBreak,
          'longBreak': longBreak,
        }
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Erro ao salvar configurações: $e");
    }
  }

  Stream<DocumentSnapshot> getUserSettings(String userId) {
    return _firestore.collection('users').doc(userId).snapshots();
  }

  Future<void> addTask(String title) async {
    debugPrint("DEBUG: Tentando salvar tarefa: $title");
    try {
      final user = _auth.currentUser;
      if (user == null) {
        debugPrint("DEBUG ERRO: Usuário nulo!");
        return;
      }

      // Adicionado timeout para evitar que o app fique esperando em caso de erro de rede
      await _firestore.collection('tasks').add({
        'title': title,
        'isCompleted': false,
        'userId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      }).timeout(const Duration(seconds: 10), onTimeout: () {
        debugPrint("DEBUG ERRO: O Firestore demorou demais para responder (Timeout)");
        throw TimeoutException("Conexão com o banco de dados expirou.");
      }).then((value) {
        debugPrint("DEBUG SUCESSO: Tarefa salva com ID: ${value.id}");
      });
    } catch (e) {
      debugPrint("DEBUG ERRO CRÍTICO: $e");
      rethrow;
    }
  }

  Stream<List<TaskModel>> getTasks() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => TaskModel.fromFirestore(doc.id, doc.data()))
        .toList());
  }
}