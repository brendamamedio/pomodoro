import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError('Android não configurado no manual.');
      case TargetPlatform.iOS:
        throw UnsupportedError('iOS não configurado no manual.');
      default:
        throw UnsupportedError('Plataforma não suportada.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDHfp9vKV3jZOwalx9hwD0vIXKTnpMtiXM',
    appId: '1:936666561724:web:b98ac5a4a224091e5e24b9',
    messagingSenderId: '936666561724',
    projectId: 'pomodoro-app-c7756',
    authDomain: 'pomodoro-app-c7756.firebaseapp.com',
    storageBucket: 'pomodoro-app-c7756.firebasestorage.app',
    measurementId: 'G-CEHHF4BMYG',
  );
}