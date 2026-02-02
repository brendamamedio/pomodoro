import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
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

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD70Dh5uA0j4Z5-eaMkUk4W_-Y2WNAVBhs',
    appId: '1:936666561724:ios:c12cdaf08800f84d5e24b9',
    messagingSenderId: '936666561724',
    projectId: 'pomodoro-app-c7756',
    storageBucket: 'pomodoro-app-c7756.firebasestorage.app',
    iosClientId: '936666561724-b97h62du8tjs5tefmggsjsjfq5pm26u7.apps.googleusercontent.com',
    iosBundleId: 'com.example.pomodoro',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDtPCW2lVkgwiqPRGqIwLKtv2HkS2fSciU',
    appId: '1:936666561724:android:2176225321a58a4f5e24b9',
    messagingSenderId: '936666561724',
    projectId: 'pomodoro-app-c7756',
    storageBucket: 'pomodoro-app-c7756.firebasestorage.app',
  );

}