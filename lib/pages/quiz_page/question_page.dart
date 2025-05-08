import 'package:flutter/material.dart';
import '../../data/model/quiz/question.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({
    super.key,
    required this.title,
    required this.questions,
    required this.answeredQuestions,
    required this.onQuizProgress,
  });

  final String title;
  final List<QuestionModel> questions;
  final int answeredQuestions;
  final Function(int) onQuizProgress;

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  int currentQuestion = 0;
  final PageController _pageController = PageController();
  bool _isResetting = false;

  void _resetQuiz() {
    setState(() {
      _isResetting = true;
    });

    for (var question in widget.questions) {
      question.userAnswer = null;
      question.hasAnswered = false;
    }

    _pageController.jumpToPage(0);
    widget.onQuizProgress(0);

    setState(() {
      currentQuestion = 0;
      _isResetting = false;
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.emoji_events, color: Colors.amber, size: 28),
              SizedBox(width: 8),
              Text('Quiz Completed'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
              const SizedBox(height: 16),
              Text(
                '🎉 Congratulations!\n\nYou have completed the "${widget.title}" quiz.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.check),
              label: const Text('OK'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: _isResetting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
            onPressed: _isResetting ? null : _resetQuiz,
            tooltip: 'Reset quiz',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Question ${currentQuestion + 1}/${widget.questions.length}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.questions.length,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    currentQuestion = index;
                  });
                },
                itemBuilder: (context, index) {
                  final question = widget.questions[index];
                  return ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Text(
                        question.question,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 25),
                      ...List.generate(question.options.length, (optionIndex) {
                        final option = question.options[optionIndex];
                        final isCorrectAnswer = question.answer == option;
                        final isSelectedAnswer = question.userAnswer == option;
                        final isWrongSelection = isSelectedAnswer && !isCorrectAnswer;

                        Color getTileColor() {
                          if (!question.hasAnswered) return Theme.of(context).colorScheme.surface;
                          if (isCorrectAnswer) return Colors.green.withOpacity(0.2);
                          if (isWrongSelection) return Colors.red.withOpacity(0.2);
                          return Theme.of(context).colorScheme.surface;
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: RadioListTile(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 8.0,
                            ),
                            tileColor: getTileColor(),
                            title: Row(
                              children: [
                                Expanded(child: Text(option)),
                                if (question.hasAnswered && isCorrectAnswer)
                                  const Icon(Icons.check_circle, color: Colors.green)
                                else if (question.hasAnswered && isWrongSelection)
                                  const Icon(Icons.cancel, color: Colors.red),
                              ],
                            ),
                            selected: isSelectedAnswer,
                            value: option,
                            activeColor: question.hasAnswered
                                ? (isSelectedAnswer
                                    ? (isCorrectAnswer ? Colors.green : Colors.red)
                                    : Colors.grey)
                                : Theme.of(context).colorScheme.primary,
                            groupValue: question.userAnswer,
                            onChanged: question.hasAnswered
                                ? null
                                : (value) {
                                    if (value != null) {
                                      setState(() {
                                        question.userAnswer = value.toString();
                                        question.hasAnswered = true;
                                      });
                                    }
                                  },
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.maxFinite,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  final question = widget.questions[currentQuestion];
                  debugPrint("User Answer: ${question.userAnswer}");
                  debugPrint("Count Current Question: $currentQuestion");

                  if (currentQuestion < widget.questions.length - 1) {
                    setState(() {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                      currentQuestion++;
                    });
                  } else {
                    _showCompletionDialog();
                    await Future.delayed(const Duration(seconds: 1));
                    Navigator.of(context).pop();
                  }

                  final answeredCount = widget.questions
                      .where((q) => q.userAnswer != null && q.userAnswer!.isNotEmpty)
                      .length;

                  widget.onQuizProgress(answeredCount);
                  debugPrint("Answered Count: $answeredCount");
                },
                child: Text(
                  currentQuestion < widget.questions.length - 1 ? "Next" : "Submit",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}