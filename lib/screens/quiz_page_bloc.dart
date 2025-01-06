import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/quiz_bloc.dart';
import '../blocs/quiz_event.dart';
import '../blocs/quiz_state.dart';

class QuizPageBloc extends StatelessWidget {
  final String title;

  const QuizPageBloc({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizBloc(),
      child: _QuizPageContent(title: title),
    );
  }
}

class _QuizPageContent extends StatelessWidget {
  final String title;

  const _QuizPageContent({Key? key, required this.title}) : super(key: key);

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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Quiz terminé!'),
        content: Text('Score final: ${state.score}/${state.questions.length}'),
        actions: [
          TextButton(
            child: Text(state.score == 3 ? 'Terminer' : 'Recommencer'),
            onPressed: () {
              Navigator.of(dialogContext).pop();

              if (state.score == 3) {
                Navigator.of(context).pushReplacementNamed('/');
              }

              context.read<QuizBloc>().add(ResetQuizEvent());
            },
          ),
        ],
      ),
    );
  }
}