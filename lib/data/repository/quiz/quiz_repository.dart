import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/quiz/question.dart';
import '../../model/quiz/recent_quiz.dart';

class QuizRepository {
  List<RecentQuizModel>? recentQuizzes;

  Future<List<RecentQuizModel>> initializeQuizzes() async {
    final firestore = FirebaseFirestore.instance;
    final progress = await QuizTempStorage.getQuizProgress();

    final quizSnapshot = await firestore.collection('quiz').get();
    List<RecentQuizModel> quizzes = [];

    for (var doc in quizSnapshot.docs) {
      final data = doc.data();
      final title = data['title'] as String;
      final questionsData = List<Map<String, dynamic>>.from(data['questions']);

      final questions = questionsData.map((q) => QuestionModel(
        question: q['question'],
        answer: q['answer'],
        options: List<String>.from(q['options']),
        hasAnswered: false,
        userAnswer: null
      )).toList();

      dynamic icon;

      if (title.contains('Kids')) {
        icon = 'https://cdn-icons-png.flaticon.com/512/16544/16544851.png';
      } else if (title.contains('Business')) {
        icon = CupertinoIcons.building_2_fill;
      } else if (title.contains('Conversational')) {
        icon = CupertinoIcons.chat_bubble_2;
      } else if (title.contains('Starters')) {
        icon = CupertinoIcons.rocket;
      } else if (title.contains('Movers')) {
        icon = CupertinoIcons.person_2;
      } else if (title.contains('Flyers')) {
        icon = CupertinoIcons.paperplane;
      } else if (title.contains('PET')) {
        icon = CupertinoIcons.book_circle;
      } else if (title.contains('TOEIC')) {
        icon = 'https://cdn-icons-png.flaticon.com/512/50/50790.png';
      } else if (title.contains('IELTS')) {
        icon = CupertinoIcons.checkmark_seal;
      } else if (title.contains('TOEFL')) {
        icon = 'https://m.media-amazon.com/images/I/515iclBBgEL.png';
      } else {
        icon = 'https://i.imgur.com/ReSHPny.png';
      }

      final answeredQuestions = progress[title] != null ?
          progress[title]['answeredQuestions'] : 0;

      quizzes.add(RecentQuizModel(
        name: title,
        icon: icon,
        totalQuestions: questions.length,
        answeredQuestions: answeredQuestions,
        questions: questions,
      ));
    }

    recentQuizzes = quizzes;
    return quizzes;
  }

  Future<void> updateQuizProgress(String quizName, int newAnsweredCount) async {
    final quiz = recentQuizzes?.firstWhere((q) => q.name == quizName);
    await quiz?.updateAnsweredQuestions(newAnsweredCount);
  }

  Future<void> clearQuizProgress() async {
    await QuizTempStorage.clearAllProgress();
    recentQuizzes = await initializeQuizzes();
  }

  Future<void> initQuizzes() async {
    recentQuizzes = await initializeQuizzes();
  }
}

class QuizTempStorage {
  static const String _tempQuizProgressKey = 'temp_quiz_progress';

  static Future<void> saveQuizProgress(RecentQuizModel quiz) async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedData = prefs.getString(_tempQuizProgressKey);
    final Map<String, dynamic> quizData = storedData != null ?
        json.decode(storedData) : {};

    quizData[quiz.name] = quiz.toJson();
    await prefs.setString(_tempQuizProgressKey, json.encode(quizData));
  }

  static Future<Map<String, dynamic>> getQuizProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedData = prefs.getString(_tempQuizProgressKey);
    return storedData != null ? json.decode(storedData) : {};
  }

  static Future<void> clearAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tempQuizProgressKey);
  }
}