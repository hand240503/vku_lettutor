import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lettutor/data/model/user/user.dart';
import 'package:lettutor/data/repository/user/user_repository.dart';

import 'auth_provider.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _repository = UserRepository();

  Future<bool> updateUserProfile(
    User input,
    Function(User) onSuccess,
    Function(String) onFail,
  ) async {
    try {
      User updatedUser = await _repository.updateUserProfile(input);

      onSuccess(updatedUser);
      return true;
    } catch (error) {
      debugPrint(error.toString());
      onFail(error.toString());
      return false;
    }
  }

  Future<void> updateUserAvatar(
    AuthProvider authProvider,
    File imageFile,
    Function(String) onSuccess,
    Function(String) onFail,
  ) async {
    try {
      String downloadUrl = await _repository.uploadAvatar(
        imageFile,
        authProvider.currentUser?.id ?? '',
      );
      onSuccess(downloadUrl);
    } catch (error) {
      debugPrint(error.toString());
      onFail(error.toString());
    }
  }
}
