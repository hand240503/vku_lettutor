import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/user/user.dart';
import '../data/repository/user/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  User? currentUser;
  bool refreshHome = false;

  AuthProvider() {
    _getUserFromPreferences();
  }

  // Đăng nhập bằng email và mật khẩu
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      final user = await _authRepository.loginWithEmailPassword(
        email,
        password,
      );
      saveLoginInfo(user);
      return true;
    } catch (e) {
      print('Sign-in error: $e');
    }
    return false;
  }

  // Đăng ký người dùng mới
  Future<bool> createUserWithEmailAndPassword(
    String email,
    String password,
    Map<String, dynamic> additionalData,
  ) async {
    try {
      final user = await _authRepository.registerWithEmailPassword(
        email: email,
        password: password,
        additionalData: additionalData,
      );
      saveLoginInfo(user);
      return true;
    } catch (e) {
      print('Registration error: $e');
    }
    return false;
  }

  // Đăng xuất người dùng
  Future<void> signOut() async {
    await _authRepository.logout();
    clearUserInfo();
  }

  // Gửi email yêu cầu đặt lại mật khẩu
  Future<bool> sendPasswordResetEmail(String email) async {
    return await _authRepository.forgotPassword(email);
  }

  // Lưu thông tin người dùng vào `currentUser`
  void saveLoginInfo(User currentUser) {
    this.currentUser = currentUser;
    _saveUserToPreferences(currentUser);
    notifyListeners();
  }

  // Xóa thông tin người dùng khi đăng xuất
  void clearUserInfo() async {
    await firebase_auth.FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    currentUser = null;
    notifyListeners();
  }

  // Lưu thông tin người dùng vào SharedPreferences
  Future<void> _saveUserToPreferences(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = jsonEncode({
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
    });
    await prefs.setString('user_data', userData);
  }

  // Lấy thông tin người dùng từ SharedPreferences
  Future<void> _getUserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user_data');
    if (userString != null) {
      final jsonMap = jsonDecode(userString);
      final user = User(
        id: jsonMap['id'],
        email: jsonMap['email'],
        firstName: jsonMap['firstName'],
        lastName: jsonMap['lastName'],
        phone: jsonMap['phone'],
        roles: List<String>.from(jsonMap['roles']),
        languages: jsonMap['languages'],
        birthday: jsonMap['birthday'],
        isActive: jsonMap['isActive'],
        avatar: jsonMap['avatar'],
      );

      saveLoginInfo(user);
    }
  }

  Future<void> loginWithGoogle({
    required Function(User user) onSuccess,
    required Function(String error) onFail,
  }) async {
    try {
      final user = await _authRepository.loginWithGoogle();
      onSuccess(user);
      notifyListeners();
    } catch (error) {
      debugPrint(error.toString());
      onFail(error.toString());
    }
  }
}
