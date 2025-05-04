import '../data/model/user/learn_topic.dart';
import '../data/model/user/test_preparation.dart';

class ImagesPath {
  static const logo = "lib/assets/icons/1024.png";
  static const intro = "assets/images/intro.png";
  static const facebook = "assets/images/facebook.png";
  static const google = "assets/images/google.png";
  static const resetPassword = "assets/images/reset_pass.png";
  static const youtube = "assets/images/youtube.jpeg";
  static const error = "assets/images/error_mascot.png";
  static const thanks = "lib/assets/images/thanks.png";
  static const video = "lib/assets/images/video.png";
  static const calendar = "assets/images/calendar.png";
  static const vietnam = "assets/images/vietnam.png";
  static const english = "assets/images/britain.png";
}

class ConstValue {
  static const descriptionTextScale = 1.5;
  static const courseNameTextScale = 1.75;
  static const levelList = [
    "BEGINNER",
    "HIGHER_BEGINNER",
    "PRE_INTERMEDIATE",
    "INTERMEDIATE",
    "UPPER_INTERMEDIATE",
    "ADVANCED",
    "PROFICIENCY",
  ];
  static const specialityList = [
    "For kids",
    "For Business",
    "Conversational",
    "Starters",
    "Movers",
    "Flyers",
    "PET",
    "TOEIC",
    "IELTS",
    "TOEFL",
  ];
}

class Specialities {
  static List<TestPreparation> specialities = [
    TestPreparation(id: 1, key: "starters", name: "STARTERS"),
    TestPreparation(id: 2, key: "movers", name: "MOVERS"),
    TestPreparation(id: 3, key: "flyers", name: "FLYERS"),
    TestPreparation(id: 4, key: "ket", name: "KET"),
    TestPreparation(id: 5, key: "pet", name: "PET"),
    TestPreparation(id: 6, key: "ielts", name: "IELTS"),
    TestPreparation(id: 7, key: "toefl", name: "TOEFL"),
    TestPreparation(id: 8, key: "toeic", name: "TOEIC"),
  ];
  static List<LearnTopic> topics = [
    LearnTopic(id: 3, key: "english-for-kids", name: "English for Kids"),
    LearnTopic(id: 4, key: "business-english", name: "Business English"),
    LearnTopic(
      id: 5,
      key: "conversational-english",
      name: "Conversational English",
    ),
  ];
}
