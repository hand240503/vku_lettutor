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

  factory Tutor.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Tutor(
      id: doc.id, // Firebase Document ID
      email: data['email'],
      name: data['name'],
      avatar: data['avatar'],
      country: data['country'],
      phone: data['phone'],
      language: data['language'],
      isActivated: data['isActivated'],
      isOnline: data['isOnline'],
      rating: data['rating']?.toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
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

