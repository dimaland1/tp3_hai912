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
      link: "https://plus.unsplash.com/premium_photo-1726721290693-12f2db0efa4d?q=80&w=1925&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    ),
    Question(
      questionText: "Paris est la capitale de la France.",
      isCorrect: true, link: "https://plus.unsplash.com/premium_photo-1661919210043-fd847a58522d?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    ),
    Question(
      questionText: "La Tour Eiffel a été construite au 20ème siècle.",
      isCorrect: false,
      link: "https://images.unsplash.com/photo-1549271456-0c1e6f59ab66?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
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

        if (_score == 3) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Quiz terminé!'),
              content: Text('Score final: $_score/${_questions.length}'),
              actions: [
                TextButton(
                  child: const Text('Terminer'),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/');
                    setState(() {
                      _currentQuestionIndex = 0;
                      _score = 0;
                    });
                    return; // Arrête la suite de l'exécution pour éviter des comportements inattendus
                  },
                ),
              ],
            ),
          );
        }else {
          showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
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
            Image(
              image: NetworkImage(_questions[_currentQuestionIndex].link),
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