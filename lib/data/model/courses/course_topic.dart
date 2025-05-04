import 'package:cloud_firestore/cloud_firestore.dart';

class CourseTopic {
  String? id;
  String? courseId;
  int? orderCourse;
  String? name;
  String? nameFile;
  String? description;
  String? videoUrl;
  String? createdAt;
  String? updatedAt;

  CourseTopic({
    this.id,
    this.courseId,
    this.orderCourse,
    this.name,
    this.nameFile,
    this.description,
    this.videoUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory CourseTopic.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    Timestamp? createdTimestamp = data['createdAt'] as Timestamp?;
    Timestamp? updatedTimestamp = data['updatedAt'] as Timestamp?;

    return CourseTopic(
      id: doc.id, // Firebase Document ID
      courseId: data['courseId'],
      orderCourse: data['orderCourse'],
      name: data['name'],
      nameFile: data['nameFile'],
      description: data['description'],
      videoUrl: data['videoUrl'],
      createdAt: createdTimestamp?.toDate().toIso8601String(),
      updatedAt: updatedTimestamp?.toDate().toIso8601String(),
    );
  }

  factory CourseTopic.fromMap(Map<String, dynamic> data) {
    return CourseTopic(
      id: data['id'],
      courseId: data['courseId'],
      orderCourse: data['orderCourse'],
      name: data['name'],
      nameFile: data['nameFile'],
      description: data['description'],
      videoUrl: data['videoUrl'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'courseId': courseId,
      'orderCourse': orderCourse,
      'name': name,
      'nameFile': nameFile,
      'description': description,
      'videoUrl': videoUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}