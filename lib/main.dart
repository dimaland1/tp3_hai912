import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tp1_hai912i/screens/pages/ThemesPage.dart';
import 'package:tp1_hai912i/screens/pages/auth/auth_page.dart';
import 'package:tp1_hai912i/screens/pages/auth/login_page.dart';
import 'package:tp1_hai912i/screens/pages/auth/register_page.dart';
import 'package:tp1_hai912i/screens/pages/creation/create_question_page.dart';
import 'screens/pages/quiz_page.dart';
import 'screens/pages/profile_page.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase init error: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
          future: Future.delayed(const Duration(seconds: 2)), // Attente de 2 secondes
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            return StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return const ThemesPage();
                }
                return AuthPage();
              },
            );
          }
      ),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/themes': (context) => const ThemesPage(),
        '/profile': (context) => const ProfileHomePage(),
        '/create-question': (context) => const CreateQuestionPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/quiz') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => QuizPageBloc(
              title: args['title'] ?? 'Questions/Réponses',
              themeId: args['themeId'] ?? '',
            ),
          );
        }
        return null;
      },
    );
  }
}