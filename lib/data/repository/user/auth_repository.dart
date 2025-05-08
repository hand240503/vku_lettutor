import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user/user.dart';

class AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User> loginWithEmailPassword(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUid = credential.user?.uid;
      if (firebaseUid == null) throw Exception('User ID not found');

      final user = await getUserDataByFirebaseId(firebaseUid);

      final prefs = await SharedPreferences.getInstance();
      final userJson = jsonEncode({
        'id': user.id,
        'email': user.email,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'phone': user.phone,
        'roles': user.roles,
        'languages': user.languages,
        'birthday': user.birthday,
        'isActive': user.isActive,
        'avatar': user.avatar,
        'country': user.country,
      });
      await prefs.setString('user_data', userJson);

      return user;
    } catch (e) {
      print('Login failed: $e');
      rethrow;
    }
  }

  Future<User> getUserDataByFirebaseId(String firebaseUid) async {
    final userDoc = await _firestore.collection('users').doc(firebaseUid).get();

    if (userDoc.exists) {
      final userData = userDoc.data()!;
      final user = User(
        id: firebaseUid,
        email: userData['email'],
        firstName: userData['firstName'] ?? '',
        lastName: userData['lastName'] ?? '',
        phone: userData['phone'],
        roles:
            userData['roles'] != null
                ? List<String>.from(userData['roles'])
                : [],
        languages: userData['languages'],
        birthday: userData['birthday'],
        isActive: userData['isActive'] ?? true,
        avatar:
            userData['avatar'] ??
            'https://randomuser.me/api/portraits/men/75.jpg',
        country: userData['country'],
      );

      return user;
    } else {
      throw Exception('User not found in Firestore');
    }
  }

  Future<User> registerWithEmailPassword({
    required String email,
    required String password,
    required Map<String, dynamic> additionalData,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUid = credential.user?.uid;
      if (firebaseUid == null) throw Exception('User ID not found');

      await _firestore.collection('users').doc(firebaseUid).set({
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        ...additionalData,
      });

      return await getUserDataByFirebaseId(firebaseUid);
    } catch (e) {
      print('Registration failed: $e');
      rethrow;
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print('Failed to send password reset email: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await GoogleSignIn().signOut();
  }

  firebase_auth.User? get currentUser => _firebaseAuth.currentUser;

  Future<User> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) throw Exception('Google sign-in cancelled');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final authResult = await _firebaseAuth.signInWithCredential(credential);

      final firebaseUid = authResult.user?.uid;
      if (firebaseUid == null) throw Exception('Firebase user ID not found');

      // Check if user already exists in Firestore
      final userDoc =
          await _firestore.collection('users').doc(firebaseUid).get();

      if (!userDoc.exists) {
        // Create user document if not exists
        await _firestore.collection('users').doc(firebaseUid).set({
          'email': authResult.user?.email,
          'firstName': authResult.user?.displayName?.split(' ').first ?? '',
          'lastName': authResult.user?.displayName?.split(' ').last ?? '',
          'avatar': authResult.user?.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
          'isActive': true,
        });
      }

      final user = await getUserDataByFirebaseId(firebaseUid);

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userJson = jsonEncode({
        'id': user.id,
        'email': user.email,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'phone': user.phone,
        'roles': user.roles,
        'languages': user.languages,
        'birthday': user.birthday,
        'isActive': user.isActive,
        'avatar': user.avatar,
        'country': user.country,
      });
      await prefs.setString('user_data', userJson);

      return user;
    } catch (e) {
      print('Google login failed: $e');
      rethrow;
    }
  }
}
