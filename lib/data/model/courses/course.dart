import 'package:cloud_firestore/cloud_firestore.dart';
  import 'course_category.dart';
  import 'course_topic.dart';

  class Course {
    String? id;
    String? name;
    String? description;
    String? imageUrl;
    String? fileUrl;
    String? level;
    String? reason;
    String? purpose;
    String? otherDetails;
    int? defaultPrice;
    int? coursePrice;
    bool? visible;
    String? createdAt;
    String? updatedAt;
    List<CourseTopic>? topics;
    List<CourseCategory>? categories;

    Course({
      this.id,
      this.name,
      this.description,
      this.imageUrl,
      this.fileUrl,
      this.level,
      this.reason,
      this.purpose,
      this.otherDetails,
      this.defaultPrice,
      this.coursePrice,
      this.visible,
      this.createdAt,
      this.updatedAt,
      this.topics,
      this.categories,
    });

    factory Course.fromFirestore(DocumentSnapshot doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      Timestamp? createdTimestamp = data['createdAt'] as Timestamp?;
      Timestamp? updatedTimestamp = data['updatedAt'] as Timestamp?;

      return Course(
        id: doc.id, // Firebase Document ID
        name: data['name'],
        description: data['description'],
        imageUrl: data['imageUrl'],
        fileUrl: data['fileUrl'],
        level: data['level'],
        reason: data['reason'],
        purpose: data['purpose'],
        otherDetails: data['otherDetails'],
        defaultPrice: data['defaultPrice'],
        coursePrice: data['coursePrice'],
        visible: data['visible'],
        createdAt: createdTimestamp?.toDate().toIso8601String(),
        updatedAt: updatedTimestamp?.toDate().toIso8601String(),
        topics: (data['topics'] as List<dynamic>?)
            ?.map((e) => CourseTopic.fromFirestore(e as DocumentSnapshot))
            .toList(),
        categories: (data['categories'] as List<dynamic>?)
            ?.map((e) => CourseCategory.fromFirestore(e as DocumentSnapshot))
            .toList(),
      );
    }

    Map<String, dynamic> toFirestore() {
      return {
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'fileUrl': fileUrl,
        'level': level,
        'reason': reason,
        'purpose': purpose,
        'otherDetails': otherDetails,
        'defaultPrice': defaultPrice,
        'coursePrice': coursePrice,
        'visible': visible,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'topics': topics?.map((topic) => topic.toFirestore()).toList(),
        'categories': categories?.map((category) => category.toFirestore()).toList(),
      };
    }
  }