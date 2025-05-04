import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user/user.dart';

class AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Đăng nhập bằng email và mật khẩu
  Future<User> loginWithEmailPassword(String email, String password) async {
    try {
      // Đăng nhập với email và mật khẩu
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Lấy UID của người dùng
      final firebaseUid = credential.user?.uid;
      if (firebaseUid == null) throw Exception('User ID not found');

      // Lấy thông tin người dùng từ Firestore
      final user = await getUserDataByFirebaseId(firebaseUid);

      // Lưu thông tin người dùng vào SharedPreferences
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
      });
      await prefs.setString('user_data', userJson);

      // Trả về thông tin người dùng
      return user;
    } catch (e) {
      print('Login failed: $e');
      rethrow;
    }
  }

  /// Lấy dữ liệu người dùng từ Firestore bằng Firebase UID
  Future<User> getUserDataByFirebaseId(String firebaseUid) async {
    // Lấy tài liệu người dùng từ Firestore theo UID
    final userDoc = await _firestore.collection('users').doc(firebaseUid).get();

    if (userDoc.exists) {
      // Nếu tài liệu tồn tại, tạo đối tượng User từ dữ liệu
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
      );

      return user;
    } else {
      // Nếu tài liệu không tồn tại, ném lỗi
      throw Exception('User not found in Firestore');
    }
  }

  /// Đăng ký tài khoản mới
  Future<User> registerWithEmailPassword({
    required String email,
    required String password,
    required Map<String, dynamic> additionalData,
  }) async {
    try {
      // Tạo tài khoản mới với email và mật khẩu
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Lấy UID của người dùng
      final firebaseUid = credential.user?.uid;
      if (firebaseUid == null) throw Exception('User ID not found');

      // Lưu thông tin người dùng vào Firestore
      await _firestore.collection('users').doc(firebaseUid).set({
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        ...additionalData,
      });

      // Lấy thông tin người dùng từ Firestore và trả về
      return await getUserDataByFirebaseId(firebaseUid);
    } catch (e) {
      print('Registration failed: $e');
      rethrow;
    }
  }

  /// Gửi email đặt lại mật khẩu
  Future<bool> forgotPassword(String email) async {
    try {
      // Gửi yêu cầu đặt lại mật khẩu qua email
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print('Failed to send password reset email: $e');
      return false;
    }
  }

  /// Thay đổi mật khẩu (yêu cầu xác thực lại)
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      // Lấy người dùng hiện tại
      final user = _firebaseAuth.currentUser;
      if (user == null) return false;

      // Tạo credential để xác thực lại người dùng
      final credential = firebase_auth.EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      // Xác thực và thay đổi mật khẩu
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      return true;
    } catch (e) {
      print('Failed to change password: $e');
      return false;
    }
  }

  /// Đăng xuất người dùng
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  /// Lấy người dùng hiện tại
  firebase_auth.User? get currentUser => _firebaseAuth.currentUser;
}
