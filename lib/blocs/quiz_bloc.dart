import 'package:flutter_bloc/flutter_bloc.dart';
import 'quiz_event.dart';
import 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(QuizState.initial()) {
    on<CheckAnswerEvent>(_onCheckAnswer);
    on<ResetQuizEvent>(_onResetQuiz);
  }

  void _onCheckAnswer(CheckAnswerEvent event, Emitter<QuizState> emit) {
    final currentQuestion = state.questions[state.currentQuestionIndex];
    final newScore = currentQuestion.isCorrect == event.userAnswer
        ? state.score + 1
        : state.score;

    final isLastQuestion = state.currentQuestionIndex >= state.questions.length - 1;

    if (isLastQuestion) {
      emit(state.copyWith(
        score: newScore,
        isCompleted: true,
      ));
    } else {
      emit(state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex + 1,
        score: newScore,
      ));
    }
  }

  void _onResetQuiz(ResetQuizEvent event, Emitter<QuizState> emit) {
    emit(state.copyWith(
      currentQuestionIndex: 0,
      score: 0,
      isCompleted: false,
    ));
  }
}