// lib/models/flashcard.dart
class Flashcard {
  final String question;
  final String answer;
  final String correctAnswer;
  final String wrongAnswer1;
  final String wrongAnswer2;
  final String wrongAnswer3;

  Flashcard({
    required this.question,
    required this.answer,
    required this.correctAnswer,
    required this.wrongAnswer1,
    required this.wrongAnswer2,
    required this.wrongAnswer3,
  });

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      correctAnswer: json['correct_answer'] ?? '',
      wrongAnswer1: json['wrong_answer_1'] ?? '',
      wrongAnswer2: json['wrong_answer_2'] ?? '',
      wrongAnswer3: json['wrong_answer_3'] ?? '',
        
      
    );
  }
}
