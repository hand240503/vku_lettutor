// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyD9MT0NwDh-ZVT2cxfDsUlYNzUA1nGMN7E',
    appId: '1:731785687567:web:d192983f411262703c297a',
    messagingSenderId: '731785687567',
    projectId: 'project-vku-3',
    authDomain: 'project-vku-3.firebaseapp.com',
    storageBucket: 'project-vku-3.appspot.com',
    measurementId: 'G-WKV0YB4XRS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA25J6o1OHUB43LcQuRvz-FgsndKoXd4d0',
    appId: '1:731785687567:android:9fe28bd682f4558b3c297a',
    messagingSenderId: '731785687567',
    projectId: 'project-vku-3',
    storageBucket: 'project-vku-3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBTtfDbnAzDuIEoAlh6LrAQbyn0f_We2fo',
    appId: '1:731785687567:ios:cb264f97852b9b363c297a',
    messagingSenderId: '731785687567',
    projectId: 'project-vku-3',
    storageBucket: 'project-vku-3.appspot.com',
    iosBundleId: 'com.example.lettutor',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBTtfDbnAzDuIEoAlh6LrAQbyn0f_We2fo',
    appId: '1:731785687567:ios:cb264f97852b9b363c297a',
    messagingSenderId: '731785687567',
    projectId: 'project-vku-3',
    storageBucket: 'project-vku-3.appspot.com',
    iosBundleId: 'com.example.lettutor',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD9MT0NwDh-ZVT2cxfDsUlYNzUA1nGMN7E',
    appId: '1:731785687567:web:54d0cb35a17c0b3a3c297a',
    messagingSenderId: '731785687567',
    projectId: 'project-vku-3',
    authDomain: 'project-vku-3.firebaseapp.com',
    storageBucket: 'project-vku-3.appspot.com',
    measurementId: 'G-QW4BVFXQLZ',
  );
}
