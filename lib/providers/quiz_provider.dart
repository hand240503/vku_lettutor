import 'package:flutter/foundation.dart';
import '../data/model/quiz/recent_quiz.dart';
import '../data/repository/quiz/quiz_repository.dart';

class QuizProvider with ChangeNotifier {
  final QuizRepository _repository = QuizRepository();
  List<RecentQuizModel> _quizzes = [];

  List<RecentQuizModel> get quizzes => _quizzes;

  Future<void> initializeQuizzes() async {
    _quizzes = await _repository.initializeQuizzes();
    notifyListeners();
  }

  Future<void> updateQuizProgress(String quizName, int newAnsweredCount) async {
    await _repository.updateQuizProgress(quizName, newAnsweredCount);
    final quiz = _quizzes.firstWhere((q) => q.name == quizName);
    quiz.answeredQuestions = newAnsweredCount;
    notifyListeners();
  }

  Future<void> resetAllProgress() async {
    await _repository.clearQuizProgress();

    _quizzes = await _repository.initializeQuizzes();

    for (var quiz in _quizzes) {
      for (var question in quiz.questions) {
        question.userAnswer = null;
      }
    }

    notifyListeners();
  }
}