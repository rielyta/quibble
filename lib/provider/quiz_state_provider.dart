import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/question_model.dart';


class QuizStateProvider extends ChangeNotifier {
  // Quiz data
  String _category = '';
  List<Question> _questions = [];

  // Progress tracking
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  int _correctAnswers = 0;
  bool _isQuizActive = false;

  // History for review
  List<QuizAnswer> _answerHistory = [];

  // Getters
  String get category => _category;
  List<Question> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int? get selectedAnswerIndex => _selectedAnswerIndex;
  int get correctAnswers => _correctAnswers;
  bool get isQuizActive => _isQuizActive;
  List<QuizAnswer> get answerHistory => _answerHistory;
  int get totalQuestions => _questions.length;
  Question? get currentQuestion =>
      _questions.isNotEmpty && _currentQuestionIndex < _questions.length
          ? _questions[_currentQuestionIndex]
          : null;


  void startQuiz({
    required String category,
    required List<Question> questions,
  }) {
    _category = category;
    _questions = questions;
    _currentQuestionIndex = 0;
    _selectedAnswerIndex = null;
    _correctAnswers = 0;
    _isQuizActive = true;
    _answerHistory = [];
    notifyListeners();
    _saveState();
  }

  void selectAnswer(int index) {
    if (_selectedAnswerIndex == index) return;
    _selectedAnswerIndex = index;
    notifyListeners();
    _saveState();
  }

  bool submitAnswer() {
    if (_selectedAnswerIndex == null || currentQuestion == null) {
      return false;
    }

    final selectedAnswer = currentQuestion!.options[_selectedAnswerIndex!];
    final isCorrect = selectedAnswer == currentQuestion!.correctAnswer;

    if (isCorrect) {
      _correctAnswers++;
    }

    _answerHistory.add(QuizAnswer(
      question: currentQuestion!.question,
      selectedAnswer: selectedAnswer,
      correctAnswer: currentQuestion!.correctAnswer,
      isCorrect: isCorrect,
    ));

    notifyListeners();
    _saveState();
    return isCorrect;
  }

  bool nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _selectedAnswerIndex = null;
      notifyListeners();
      _saveState();
      return true;
    }
    return false;
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _selectedAnswerIndex = null;
    _correctAnswers = 0;
    _answerHistory = [];
    notifyListeners();
    _saveState();
  }


  void endQuiz() {
    _isQuizActive = false;
    notifyListeners();
    _clearStorage();
  }


  void clearQuiz() {
    _category = '';
    _questions = [];
    _currentQuestionIndex = 0;
    _selectedAnswerIndex = null;
    _correctAnswers = 0;
    _isQuizActive = false;
    _answerHistory = [];
    notifyListeners();
    _clearStorage();
  }


  double getProgress() {
    if (_questions.isEmpty) return 0.0;
    return (_currentQuestionIndex + 1) / _questions.length;
  }

  Future<void> _saveState() async {
    if (!_isQuizActive) return;

    try {
      final prefs = await SharedPreferences.getInstance();

      final stateData = {
        'category': _category,
        'questions': _questions.map((q) => {
          'question': q.question,
          'options': q.options,
          'correctAnswer': q.correctAnswer,
        }).toList(),
        'currentIndex': _currentQuestionIndex,
        'correctAnswers': _correctAnswers,
        'selectedAnswer': _selectedAnswerIndex,
        'isActive': _isQuizActive,
        'answerHistory': _answerHistory.map((a) => {
          'question': a.question,
          'selectedAnswer': a.selectedAnswer,
          'correctAnswer': a.correctAnswer,
          'isCorrect': a.isCorrect,
        }).toList(),
      };

      await prefs.setString('quiz_state', jsonEncode(stateData));
    } catch (e) {
      debugPrint('Error saving quiz state: $e');
    }
  }

  Future<bool> loadSavedQuiz() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stateJson = prefs.getString('quiz_state');

      if (stateJson == null) return false;

      final stateData = jsonDecode(stateJson) as Map<String, dynamic>;

      if (stateData['isActive'] != true) return false;

      _category = stateData['category'] as String;
      _questions = (stateData['questions'] as List)
          .map((q) => Question(
        question: q['question'],
        options: List<String>.from(q['options']),
        correctAnswer: q['correctAnswer'],
      ))
          .toList();
      _currentQuestionIndex = stateData['currentIndex'] as int;
      _correctAnswers = stateData['correctAnswers'] as int;
      _selectedAnswerIndex = stateData['selectedAnswer'] as int?;
      _isQuizActive = true;
      _answerHistory = (stateData['answerHistory'] as List)
          .map((h) => QuizAnswer(
        question: h['question'],
        selectedAnswer: h['selectedAnswer'],
        correctAnswer: h['correctAnswer'],
        isCorrect: h['isCorrect'],
      ))
          .toList();

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error loading quiz state: $e');
      return false;
    }
  }

  Future<bool> hasSavedQuiz() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stateJson = prefs.getString('quiz_state');

      if (stateJson == null) return false;

      final stateData = jsonDecode(stateJson) as Map<String, dynamic>;
      return stateData['isActive'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _clearStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('quiz_state');
    } catch (e) {
      debugPrint('Error clearing quiz state: $e');
    }
  }
}

class QuizAnswer {
  final String question;
  final String selectedAnswer;
  final String correctAnswer;
  final bool isCorrect;

  QuizAnswer({
    required this.question,
    required this.selectedAnswer,
    required this.correctAnswer,
    required this.isCorrect,
  });
}