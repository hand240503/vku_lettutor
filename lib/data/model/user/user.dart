import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? id;
  String? email;
  String? firstName;
  String? lastName;
  String? phone;
  List<String>? roles;
  String? languages;
  String? birthday;
  bool? isActive;

  User({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.roles,
    this.languages,
    this.birthday,
    this.isActive,
  });

    factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return User(
      id: doc.id,
      email: data['email'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      phone: data['phone'],
      roles: data['roles'] != null ? List<String>.from(data['roles']) : null,
      languages: data['languages'],
      birthday: data['birthday'],
      isActive: data['isActive'],
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      roles: json['roles'] != null ? List<String>.from(json['roles']) : null,
      languages: json['languages'],
      birthday: json['birthday'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'roles': roles,
      'languages': languages,
      'birthday': birthday,
      'isActive': isActive,
    };
  }
}
