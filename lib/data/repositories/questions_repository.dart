import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/question.dart';

class QuestionsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Question>> getQuestions() async {
    try {
      final snapshot = await _firestore.collection('questions').get();
      return snapshot.docs
          .map((doc) => Question.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching questions: $e');
      // En cas d'erreur, retourner les questions par défaut
      return [];
    }
  }

  Future<List<Question>> getQuestionsByTheme(String themeId) async {
    try {
      final snapshot = await _firestore
          .collection('questions')
          .where('themeId', isEqualTo: themeId)
          .get();

      return snapshot.docs
          .map((doc) => Question.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching questions: $e');
      return [];
    }
  }
}