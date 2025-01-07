// lib/services/analytics_service.dart
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final analytics = FirebaseAnalytics.instance;

  static Future<void> logQuizCompleted({
    required String themeId,
    required int score,
    required int totalQuestions,
  }) async {
    await analytics.logEvent(
      name: 'quiz_completed',
      parameters: {
        'theme_id': themeId,
        'score': score,
        'total_questions': totalQuestions,
        'success_rate': (score / totalQuestions) * 100,
      },
    );
  }

  static Future<void> setUserPreferredTheme(String themeId) async {
    await analytics.setUserProperty(
      name: 'preferred_theme',
      value: themeId,
    );
  }

  static Future<void> logShootMode() async {
    await analytics.logEvent(name: 'shoot_mode_started');
  }
}