// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyA2nrmnVKsvLGpB62tjcqQWcoJD7EecIkc',
    appId: '1:503669779347:web:0c899bc85e3961bcb71666',
    messagingSenderId: '503669779347',
    projectId: 'auth-esearchplayers',
    authDomain: 'auth-esearchplayers.firebaseapp.com',
    storageBucket: 'auth-esearchplayers.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA1vIyvH33xSs9cUX0nfoNq6rqFWsZpIR0',
    appId: '1:503669779347:android:63a659a77fa93c9fb71666',
    messagingSenderId: '503669779347',
    projectId: 'auth-esearchplayers',
    storageBucket: 'auth-esearchplayers.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBbwRcYkC505-oFCiE86gf-1ohkXkBmcfk',
    appId: '1:503669779347:ios:4f1bbcde567a9bb9b71666',
    messagingSenderId: '503669779347',
    projectId: 'auth-esearchplayers',
    storageBucket: 'auth-esearchplayers.appspot.com',
    iosClientId: '503669779347-i8kch3kik1dqacb2v6fmnriqok5k6pkp.apps.googleusercontent.com',
    iosBundleId: 'com.example.esearchplayers',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBbwRcYkC505-oFCiE86gf-1ohkXkBmcfk',
    appId: '1:503669779347:ios:f5fe0b01d71e9fd2b71666',
    messagingSenderId: '503669779347',
    projectId: 'auth-esearchplayers',
    storageBucket: 'auth-esearchplayers.appspot.com',
    iosClientId: '503669779347-t2bmrh4bgiae60tt33fr0ahkj137ofsg.apps.googleusercontent.com',
    iosBundleId: 'com.example.esearchplayers.RunnerTests',
  );
}
