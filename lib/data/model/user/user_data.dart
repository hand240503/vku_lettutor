import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lettutor/data/model/user/user.dart';

class UserData {
  User? user;

  UserData({this.user});

  factory UserData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return UserData(
      user: data['users'] != null ? User.fromFirestore(data['users']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'users': user?.toFirestore()};
  }
}
