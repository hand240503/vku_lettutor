class QuestionModel {
  final String question;
  final String answer;
  final List<String> options;
  bool hasAnswered;
  String? userAnswer;
  QuestionModel({
    required this.question,
    required this.answer,
    required this.options,
    this.hasAnswered = false,
    this.userAnswer,
  });

  bool isCorrect(String answer) => this.answer == answer;
}