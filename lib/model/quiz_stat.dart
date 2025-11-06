class QuizStats {
  int totalScore;
  int totalQuestions;
  int totalCorrect;
  int totalWrong;
  int completedQuizzes;

  QuizStats({
    this.totalScore = 0,
    this.totalQuestions = 0,
    this.totalCorrect = 0,
    this.totalWrong = 0,
    this.completedQuizzes = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalScore': totalScore,
      'totalQuestions': totalQuestions,
      'totalCorrect': totalCorrect,
      'totalWrong': totalWrong,
      'completedQuizzes': completedQuizzes,
    };
  }

  factory QuizStats.fromJson(Map<String, dynamic> json) {
    return QuizStats(
      totalScore: json['totalScore'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      totalCorrect: json['totalCorrect'] ?? 0,
      totalWrong: json['totalWrong'] ?? 0,
      completedQuizzes: json['completedQuizzes'] ?? 0,
    );
  }

  // Calculate
  int get totalXP => totalCorrect * 10;

  int get completionPercentage {
    if (totalQuestions == 0) return 0;
    return ((totalCorrect / totalQuestions) * 100).round();
  }

  double get progressWidth {
    if (completedQuizzes == 0) return 0.0;
    const totalCategories = 3;
    return (completedQuizzes / totalCategories).clamp(0.0, 1.0);
  }
}