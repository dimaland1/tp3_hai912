import '../models/question.dart';

class QuizState {
  final int currentQuestionIndex;
  final int score;
  final List<Question> questions;
  final bool isCompleted;

  QuizState({
    required this.currentQuestionIndex,
    required this.score,
    required this.questions,
    required this.isCompleted,
  });

  factory QuizState.initial() {
    return QuizState(
      currentQuestionIndex: 0,
      score: 0,
      isCompleted: false,
      questions: [
        Question(
            questionText: "La France a dû céder l'Alsace et la Moselle (une région de la Lorraine) à l'Allemagne après la guerre de 1870-1871.",
            isCorrect: true,
            link: "https://plus.unsplash.com/premium_photo-1726721290693-12f2db0efa4d?q=80&w=1925&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
        ),
        Question(
            questionText: "Paris est la capitale de la France.",
            isCorrect: true,
            link: "https://plus.unsplash.com/premium_photo-1661919210043-fd847a58522d?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
        ),
        Question(
            questionText: "La Tour Eiffel a été construite au 20ème siècle.",
            isCorrect: false,
            link: "https://images.unsplash.com/photo-1549271456-0c1e6f59ab66?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
        ),
      ],
    );
  }

  QuizState copyWith({
    int? currentQuestionIndex,
    int? score,
    List<Question>? questions,
    bool? isCompleted,
  }) {
    return QuizState(
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      score: score ?? this.score,
      questions: questions ?? this.questions,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}