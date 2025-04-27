import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import '../data/model/user/user.dart';
import '../data/model/user/user_data.dart';
import '../data/repository/user/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  late AuthRepository authRepository;

  User? currentUser;
  Tokens? token;
  bool refreshHome = false;
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;

  AuthProvider() {
    authRepository = AuthRepository();
    _initFirebaseAuth();
  }

  Future<void> _initFirebaseAuth() async {
    // Listen to auth state changes
    _firebaseAuth.authStateChanges().listen((firebase_auth.User? firebaseUser) {
      if (firebaseUser == null) {
        clearUserInfo();
      } else {
        // You might want to fetch additional user data from your backend here
        // and update currentUser accordingly
      }
    });
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
      );

      if (userCredential.user != null) {
        // Fetch user data from your backend using Firebase UID
        final userData = await authRepository.getUserDataByFirebaseId(userCredential.user!.uid);
        if (userData.user != null) {
          saveLoginInfo(userData.user!, userData.tokens);
          return true;
        }
        return false;
        return true;
      }
      return false;
    } catch (e) {
      print('Firebase signin error: $e');
      return false;
    }
  }

  Future<bool> createUserWithEmailAndPassword(String email, String password, Map<String, dynamic> additionalData) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );

      if (userCredential.user != null) {
        // Register the user in your backend with Firebase UID
        final userData = await authRepository.registerUser(
          userCredential.user!.uid,
          email,
          additionalData
        );
        if (userData.user != null) {
          saveLoginInfo(userData.user!, userData.tokens);
          return true;
        }
        return false;
        return true;
      }
      return false;
    } catch (e) {
      print('Firebase signup error: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    clearUserInfo();
  }

  void saveLoginInfo(User currentUser, Tokens? token) {
    this.token = token;
    this.currentUser = currentUser;
    notifyListeners();
  }

  void clearUserInfo() {
    token = null;
    currentUser = null;
    notifyListeners();
  }
}