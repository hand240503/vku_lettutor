import 'package:cloud_firestore/cloud_firestore.dart';

class Tutor {
  String? id;
  String? email;
  String? name;
  String? avatar;
  String? country;
  String? phone;
  String? language;
  bool? isActivated;
  bool? isOnline;
  double? rating;

  Tutor({
    this.id,
    this.email,
    this.name,
    this.avatar,
    this.country,
    this.phone,
    this.language,
    this.isActivated,
    this.isOnline,
    this.rating,
  });

  // Factory method to create a Tutor instance from Firestore DocumentSnapshot
  factory Tutor.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Tutor(
      id: doc.id,  // Firebase Document ID
      email: data['email'],
      name: data['name'],
      avatar: data['avatar'],
      country: data['country'],
      phone: data['phone'],
      language: data['language'],
      isActivated: data['isActivated'],
      isOnline: data['isOnline'],
      rating: data['rating']?.toDouble(),  // Ensure it's double if necessary
    );
  }

  // Factory method to create a Tutor instance from a JSON map
  factory Tutor.fromJson(Map<String, dynamic> json) {
    return Tutor(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      avatar: json['avatar'],
      country: json['country'],
      phone: json['phone'],
      language: json['language'],
      isActivated: json['isActivated'],
      isOnline: json['isOnline'],
      rating: json['rating']?.toDouble(),
    );
  }

  // Method to convert a Tutor instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'country': country,
      'phone': phone,
      'language': language,
      'isActivated': isActivated,
      'isOnline': isOnline,
      'rating': rating,
    };
  }
}
