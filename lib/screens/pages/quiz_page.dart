import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../busines_logic/blocs/quiz_bloc.dart';
import '../../busines_logic/events/quiz_event.dart';
import '../../busines_logic/blocs/quiz_state.dart';
import '../../services/sound_service.dart';
import '../../services/analytics_service.dart';

class QuizPageBloc extends StatelessWidget {
  final String themeId;
  final String title;

  const QuizPageBloc({
    Key? key,
    required this.themeId,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizBloc(themeId: themeId)..add(LoadQuestionsEvent()),
      child: _QuizPageContent(title: title, themeId: themeId),
    );
  }
}

class _QuizPageContent extends StatelessWidget {
  final String title;
  final String themeId;

  const _QuizPageContent({
    Key? key,
    required this.title,
    required this.themeId,
  }) : super(key: key);

  void _logQuizResults(QuizState state) {
    AnalyticsService.logQuizCompleted(
      themeId: themeId,
      score: state.score,
      totalQuestions: state.questions.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.blueGrey,
      body: BlocConsumer<QuizBloc, QuizState>(
        listener: (context, state) {
          if (state.isCompleted) {
            _showResultDialog(context, state);
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (state.questions.isEmpty) {
            return const Center(
              child: Text(
                'Aucune question disponible',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }

          final currentQuestion = state.questions[state.currentQuestionIndex];
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image(
                  image: NetworkImage(currentQuestion.link),
                  height: 150,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    currentQuestion.questionText,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => context.read<QuizBloc>().add(CheckAnswerEvent(true)),
                      child: const Text('VRAI'),
                    ),
                    ElevatedButton(
                      onPressed: () => context.read<QuizBloc>().add(CheckAnswerEvent(false)),
                      child: const Text('FAUX'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showResultDialog(BuildContext context, QuizState state) {
    final isVictory = state.score == state.questions.length;
    SoundService.playSound(isVictory);
    _logQuizResults(state);

    if (isVictory) {
      AnalyticsService.setUserPreferredTheme(themeId);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(isVictory ? 'Victoire !' : 'Quiz terminé'),
        content: Text('Score: ${state.score}/${state.questions.length}'),
        actions: [
          TextButton(
            child: Text('Recommencer'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<QuizBloc>().add(ResetQuizEvent());
            },
          ),
          TextButton(
            child: Text('Terminer'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
    );
  }
}