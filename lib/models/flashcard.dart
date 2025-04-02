// lib/models/flashcard.dart
class Flashcard {
  final String question;
  final String answer;
  final String correctAnswer;
  final String wrongAnswer1;

  Flashcard({
    required this.question,
    required this.answer,
    required this.correctAnswer,
    required this.wrongAnswer1,
  });

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      correctAnswer: json['correct_answer'] ?? '',
      wrongAnswer1: json['wrong_answer_1'] ?? '',
    );
  }
}
