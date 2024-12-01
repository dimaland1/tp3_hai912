import 'package:flutter/material.dart';
import '../models/question.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  final List<Question> _questions = [
    Question(
      questionText: "La France a dû céder l'Alsace et la Moselle (une région de la Lorraine) à l'Allemagne après la guerre de 1870-1871.",
      isCorrect: true,
    ),
    Question(
      questionText: "Paris est la capitale de la France.",
      isCorrect: true,
    ),
    Question(
      questionText: "La Tour Eiffel a été construite au 20ème siècle.",
      isCorrect: false,
    ),
  ];

  void _checkAnswer(bool userChoice) {
    final isCorrect = _questions[_currentQuestionIndex].isCorrect == userChoice;
    setState(() {
      if (isCorrect) _score++;
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        // Quiz terminé
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Quiz terminé!'),
            content: Text('Score final: $_score/${_questions.length}'),
            actions: [
              TextButton(
                child: const Text('Recommencer'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _currentQuestionIndex = 0;
                    _score = 0;
                  });
                },
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.blueGrey,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Image(
              image: NetworkImage('https://via.placeholder.com/300x150'),
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
                _questions[_currentQuestionIndex].questionText,
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
                  onPressed: () => _checkAnswer(true),
                  child: const Text('VRAI'),
                ),
                ElevatedButton(
                  onPressed: () => _checkAnswer(false),
                  child: const Text('FAUX'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}