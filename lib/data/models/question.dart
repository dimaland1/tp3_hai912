class Question {
  final String questionText;
  final bool isCorrect;
  final String link;
  final String themeId;

  Question({
    required this.questionText,
    required this.isCorrect,
    required this.link,
    required this.themeId,
  });

  // Depuis Firestore
  factory Question.fromFirestore(Map<String, dynamic> data) {
    return Question(
      questionText: data['questionText'] ?? '',
      isCorrect: data['isCorrect'] ?? false,
      link: data['link'] ?? '',
      themeId: data['themeId'] ?? '',
    );
  }

  // Vers Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'questionText': questionText,
      'isCorrect': isCorrect,
      'link': link,
      'themeId': themeId,
    };
  }
}