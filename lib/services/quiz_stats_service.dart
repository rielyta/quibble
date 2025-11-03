import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/quiz_stat.dart';

class QuizStatsService {
  static const String _statsKey = 'quiz_stats';

  // Save stats
  static Future<void> saveStats(QuizStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_statsKey, jsonEncode(stats.toJson()));
  }

  // Load stats
  static Future<QuizStats> loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    final String? statsJson = prefs.getString(_statsKey);

    if (statsJson == null) {
      return QuizStats();
    }

    return QuizStats.fromJson(jsonDecode(statsJson));
  }

  // Update stats after quiz completion
  static Future<void> updateStatsAfterQuiz({
    required int correctAnswers,
    required int totalQuestions,
  }) async {
    final stats = await loadStats();

    final score = ((correctAnswers / totalQuestions) * 100).round();

    stats.totalScore += score;
    stats.totalQuestions += totalQuestions;
    stats.totalCorrect += correctAnswers;
    stats.totalWrong += (totalQuestions - correctAnswers);
    stats.completedQuizzes += 1;

    await saveStats(stats);
  }

  // Reset stats
  static Future<void> resetStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_statsKey);
  }

  // Get average score
  static Future<int> getAverageScore() async {
    final stats = await loadStats();
    if (stats.completedQuizzes == 0) return 0;
    return (stats.totalScore / stats.completedQuizzes).round();
  }
}