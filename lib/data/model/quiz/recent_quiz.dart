import 'package:lettutor/data/model/quiz/question.dart';
import '../../repository/quiz/quiz_repository.dart';

class RecentQuizModel {
  final String name;
  final dynamic icon;
  final int totalQuestions;
  int answeredQuestions;
  final List<QuestionModel> questions;

  RecentQuizModel({
    required this.name,
    required this.icon,
    required this.totalQuestions,
    required this.answeredQuestions,
    required this.questions,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'answeredQuestions': answeredQuestions,
    };
  }

  Future<void> updateAnsweredQuestions(int count) async {
    answeredQuestions = count;
    await QuizTempStorage.saveQuizProgress(this);
  }
}