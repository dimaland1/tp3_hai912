import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/questions_repository.dart';
import '../events/quiz_event.dart';
import 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final QuestionsRepository _questionsRepository;
  final String themeId;

  QuizBloc({required this.themeId, QuestionsRepository? questionsRepository})
      : _questionsRepository = questionsRepository ?? QuestionsRepository(),
        super(QuizState.initial()) {
    on<LoadQuestionsEvent>(_onLoadQuestions);
    on<CheckAnswerEvent>(_onCheckAnswer);
    on<ResetQuizEvent>(_onResetQuiz);
    add(LoadQuestionsEvent());
  }

  Future<void> _onLoadQuestions(LoadQuestionsEvent event, Emitter<QuizState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final questions = await _questionsRepository.getQuestionsByTheme(themeId);
      emit(state.copyWith(
        questions: questions,
        isLoading: false,
      ));
    } catch (e) {
      print('Error loading questions: $e');
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onCheckAnswer(CheckAnswerEvent event, Emitter<QuizState> emit) {
    if (state.questions.isEmpty) return;

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