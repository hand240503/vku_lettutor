import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/model/quiz/live_quiz.dart';
import '../../providers/quiz_provider.dart';
import 'components/live_quiz_component.dart';
import 'components/quiz_header_component.dart';
import 'components/recent_quiz_component.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    await quizProvider.initializeQuizzes();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _resetAndRefreshQuizzes() async {
    setState(() {
      _isLoading = true;
    });
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    await quizProvider.resetAllProgress();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final recentQuizzes = quizProvider.quizzes;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const QuizHeader(),
            Expanded(
              child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(
                    top: 25,
                    left: 15,
                    right: 15,
                    bottom: 15,
                  ),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent Quiz",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        IconButton(
                          onPressed: _resetAndRefreshQuizzes,
                          icon: const Icon(Icons.refresh),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    ...List.generate(recentQuizzes.length, (index) {
                      return RecentQuiz(
                        recentQuizModel: recentQuizzes[index],
                      );
                    }),
                    const SizedBox(height: 25),
                    Text(
                      "Live Quiz",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 15),
                    ...List.generate(liveQuizzes.length, (index) {
                      return LiveQuiz(liveQuizModel: liveQuizzes[index]);
                    }),
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }
}
