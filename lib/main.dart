import 'package:flutter/material.dart';
import 'package:tp1_hai912i/screens/quizz_page.dart';
import 'screens/profile_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TP1 Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const ProfileHomePage(),
        '/quiz': (context) => const QuizPage(title: 'Questions/Réponses'),
      },
    );
  }
}