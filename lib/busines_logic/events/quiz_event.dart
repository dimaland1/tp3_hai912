abstract class QuizEvent {}

class LoadQuestionsEvent extends QuizEvent {}

class CheckAnswerEvent extends QuizEvent {
  final bool userAnswer;
  CheckAnswerEvent(this.userAnswer);
}

class ResetQuizEvent extends QuizEvent {}