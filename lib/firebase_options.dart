import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCfdNbpbkps72YLqdoJpLEfF17k_UlLxMY',
    appId: '1:899615270275:web:4918886136c2adce6642b6',
    messagingSenderId: '899615270275',
    projectId: 'afsal-fazr-the-todo-app',
    authDomain: 'afsal-fazr-the-todo-app.firebaseapp.com',
    storageBucket: 'afsal-fazr-the-todo-app.firebasestorage.app',
    measurementId: 'G-0R1WE3852Z',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDTm_mPY9gmZLRzoSaYh62pzWwgAvN3KW0',
    appId: '1:899615270275:android:6e9b699e7a89f9186642b6',
    messagingSenderId: '899615270275',
    projectId: 'afsal-fazr-the-todo-app',
    storageBucket: 'afsal-fazr-the-todo-app.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCfdNbpbkps72YLqdoJpLEfF17k_UlLxMY',
    appId: '1:899615270275:web:b8d86a4a2e77e7636642b6',
    messagingSenderId: '899615270275',
    projectId: 'afsal-fazr-the-todo-app',
    authDomain: 'afsal-fazr-the-todo-app.firebaseapp.com',
    storageBucket: 'afsal-fazr-the-todo-app.firebasestorage.app',
    measurementId: 'G-T5TDYTYQGM',
  );
}
