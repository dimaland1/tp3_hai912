import '../../data/models/question.dart';

class QuizState {
  final int currentQuestionIndex;
  final int score;
  final List<Question> questions;
  final bool isCompleted;
  final bool isLoading;  // Nouvel état pour gérer le chargement

  QuizState({
    required this.currentQuestionIndex,
    required this.score,
    required this.questions,
    required this.isCompleted,
    this.isLoading = false,
  });

  factory QuizState.initial() {
    return QuizState(
      currentQuestionIndex: 0,
      score: 0,
      isCompleted: false,
      questions: [],  // Liste vide au départ
      isLoading: true,  // Commence avec le chargement
    );
  }

  QuizState copyWith({
    int? currentQuestionIndex,
    int? score,
    List<Question>? questions,
    bool? isCompleted,
    bool? isLoading,
  }) {
    return QuizState(
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      score: score ?? this.score,
      questions: questions ?? this.questions,
      isCompleted: isCompleted ?? this.isCompleted,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}