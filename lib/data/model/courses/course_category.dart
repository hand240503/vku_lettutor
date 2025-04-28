import 'package:cloud_firestore/cloud_firestore.dart';

class CourseCategory {
  String? id;
  String? title;
  String? description;
  String? key;
  String? createdAt;
  String? updatedAt;

  CourseCategory({
    this.id,
    this.title,
    this.description,
    this.key,
    this.createdAt,
    this.updatedAt,
  });

  factory CourseCategory.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    Timestamp? createdTimestamp = data['createdAt'] as Timestamp?;
    Timestamp? updatedTimestamp = data['updatedAt'] as Timestamp?;

    return CourseCategory(
      id: doc.id, // Firebase Document ID
      title: data['title'],
      description: data['description'],
      key: data['key'],
      createdAt: createdTimestamp?.toDate().toIso8601String(),
      updatedAt: updatedTimestamp?.toDate().toIso8601String(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'key': key,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}