import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lettutor/data/model/user/user.dart';

class UserRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadAvatar(File imageFile, String userId) async {
    try {
      final ref = _storage.ref().child('avatars/$userId/avatar.jpg');

      final uploadTask = ref.putFile(imageFile);

      final snapshot = await uploadTask.whenComplete(() {});
      if (snapshot.state == TaskState.success) {
        final downloadUrl = await snapshot.ref.getDownloadURL();
        print('Upload successful, download URL: $downloadUrl');
        return downloadUrl;
      } else {
        throw Exception('Upload avatar failed: Task state is not success.');
      }
    } catch (e) {
      print('Error uploading avatar: $e');
      throw Exception('Upload avatar failed: $e');
    }
  }

  Future<User> updateUserProfile(User user) async {
    try {
      final userRef = _firestore.collection('users').doc(user.id);
      await userRef.update(user.toFirestore());
      final updatedDoc = await userRef.get();
      return User.fromFirestore(updatedDoc);
    } catch (e) {
      throw Exception('Update user profile failed: $e');
    }
  }
}
