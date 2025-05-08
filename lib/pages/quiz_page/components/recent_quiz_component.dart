import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import '../../../data/model/quiz/recent_quiz.dart';
import '../../../providers/quiz_provider.dart';
import '../question_page.dart';

class RecentQuiz extends StatelessWidget {
  const RecentQuiz({
    super.key,
    required this.recentQuizModel,
  });
  final RecentQuizModel recentQuizModel;

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => QuestionPage(
                title: recentQuizModel.name,
                questions: recentQuizModel.questions,
                answeredQuestions: recentQuizModel.answeredQuestions,
                onQuizProgress: (int answeredCount) {
                  // Use the provider to update progress
                  quizProvider.updateQuizProgress(
                      recentQuizModel.name,
                      answeredCount
                  );
                },
              ),
            ),
          );
          //onQuizCompleted();
        },
        // make leading a custom widget with a background and icon inside
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: recentQuizModel.icon is String
            ? Padding(
              padding: const EdgeInsets.all(6.0),
              child: Image.network(
                recentQuizModel.icon.toString(),
                color: Colors.white,
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.broken_image,
                  color: Colors.red,
                ),
              ),
            )
            : Icon(
            recentQuizModel.icon,
            color: Colors.white,
          ),
        ),
        title: Text(recentQuizModel.name),
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Ionicons.document_text_outline,
              size: 18,
            ),
            const SizedBox(width: 5),
            Text(
              "${recentQuizModel.answeredQuestions}/${recentQuizModel.totalQuestions} Questions",
            ),
          ],
        ),
      ),
    );
  }
}
