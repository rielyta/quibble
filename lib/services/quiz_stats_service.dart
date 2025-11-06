import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/quiz_stat.dart';

class QuizStatsService {
  static const String _statsKey = 'quiz_stats';


  static Future<void> saveStats(QuizStats stats) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_statsKey, jsonEncode(stats.toJson()));
    } catch (e) {
      debugPrint('Error saving stats: $e');
    }
  }


  static Future<QuizStats> loadStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final statsJson = prefs.getString(_statsKey);

      if (statsJson == null || statsJson.isEmpty) {
        return QuizStats();
      }

      return QuizStats.fromJson(jsonDecode(statsJson));
    } catch (e) {
      debugPrint('Error loading stats: $e');
      return QuizStats();
    }
  }


  static Future<void> updateStatsAfterQuiz({
    required int correctAnswers,
    required int totalQuestions,
  }) async {
    try {
      final stats = await loadStats();

      final score = ((correctAnswers / totalQuestions) * 100).round();

      stats.totalScore += score;
      stats.totalQuestions += totalQuestions;
      stats.totalCorrect += correctAnswers;
      stats.totalWrong += (totalQuestions - correctAnswers);
      stats.completedQuizzes += 1;

      await saveStats(stats);
    } catch (e) {
      debugPrint('Error updating stats: $e');
    }
  }


  static Future<void> resetStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_statsKey);
    } catch (e) {
      debugPrint('Error resetting stats: $e');
    }
  }


  static Future<int> getAverageScore() async {
    try {
      final stats = await loadStats();
      if (stats.completedQuizzes == 0) return 0;
      return (stats.totalScore / stats.completedQuizzes).round();
    } catch (e) {
      debugPrint('Error getting average score: $e');
      return 0;
    }
  }
}

// Helper for debug prints
void debugPrint(String message) {
  // ignore: avoid_print
  print('[QuizStatsService] $message');
}