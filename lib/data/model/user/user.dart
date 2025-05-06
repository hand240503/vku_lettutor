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
  String? avatar;
  String? country;

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
    this.avatar,
    this.country,
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
      avatar: data['avatar'],
      country: data['country'],
    );
  }

  Map<String, dynamic> toFirestore() {
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
      'avatar': avatar,
      'country': country,
    };
  }

  User copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? country,
    String? birthday,
    String? avatar,
    String? id,
    bool? isActive,
    List<String>? roles,
  }) {
    return User(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      birthday: birthday ?? this.birthday,
      avatar: avatar ?? this.avatar,
      id: id ?? this.id,
      isActive: isActive ?? true,
      roles: roles ?? ['user'],
    );
  }
}
