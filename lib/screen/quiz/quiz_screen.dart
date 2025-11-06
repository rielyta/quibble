import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quibble/screen/quiz/result_screen.dart';
import '../../model/question_model.dart';
import '../../widgets/result_dialog.dart';
import '../../provider/theme_provider.dart';

class QuizQuestionScreen extends StatefulWidget {
  final String category;
  final List<Question> questions;

  const QuizQuestionScreen({
    super.key,
    required this.category,
    required this.questions,
  });

  @override
  State<QuizQuestionScreen> createState() => _QuizQuestionScreenState();
}

class _QuizQuestionScreenState extends State<QuizQuestionScreen> {
  int currentQuestionIndex = 0;
  int? selectedAnswerIndex;
  int correctAnswers = 0;

  void _selectAnswer(int index) {
    if (selectedAnswerIndex == index) return;
    setState(() => selectedAnswerIndex = index);
  }

  void _checkAnswer() {
    if (selectedAnswerIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an answer'),
          backgroundColor: Color(0xFFEE7C9E),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    final currentQuestion = widget.questions[currentQuestionIndex];
    final selectedAnswer = currentQuestion.options[selectedAnswerIndex!];
    final isCorrect = selectedAnswer == currentQuestion.correctAnswer;

    if (isCorrect) {
      correctAnswers++;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ResultDialog(
        isCorrect: isCorrect,
        onNext: () {
          Navigator.pop(context);
          _nextQuestion();
        },
      ),
    );
  }

  void _nextQuestion() {
    if (currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswerIndex = null;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            correctAnswers: correctAnswers,
            totalQuestions: widget.questions.length,
            category: widget.category,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFFFEAB9),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final isLandscape = orientation == Orientation.landscape;
                final screenWidth = constraints.maxWidth;
                final screenHeight = constraints.maxHeight;

                return isLandscape
                    ? _buildLandscapeLayout(screenWidth, screenHeight, isDarkMode)
                    : _buildPortraitLayout(screenWidth, screenHeight, isDarkMode);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(double screenWidth, double screenHeight, bool isDarkMode) {
    final currentQuestion = widget.questions[currentQuestionIndex];

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.04),
            _buildHeader(screenWidth, isDarkMode),
            SizedBox(height: screenHeight * 0.02),
            _buildProgressBar(),
            SizedBox(height: screenHeight * 0.03),
            _buildQuestionBox(currentQuestion, screenWidth, isDarkMode),
            SizedBox(height: screenHeight * 0.03),
            _buildAnswerOptions(currentQuestion, screenWidth, isDarkMode),
            SizedBox(height: screenHeight * 0.02),
            _buildSubmitButton(screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.04),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(double screenWidth, double screenHeight, bool isDarkMode) {
    final currentQuestion = widget.questions[currentQuestionIndex];

    return Row(
      children: [
        // Left Side - Question
        Expanded(
          flex: 5,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(screenWidth * 0.5, isDarkMode),
                  SizedBox(height: screenHeight * 0.03),
                  _buildProgressBar(),
                  SizedBox(height: screenHeight * 0.04),
                  _buildQuestionBox(currentQuestion, screenWidth * 0.5, isDarkMode),
                ],
              ),
            ),
          ),
        ),

        // Right Side - Options & Submit
        Expanded(
          flex: 5,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  _buildAnswerOptions(currentQuestion, screenWidth * 0.4, isDarkMode),
                  SizedBox(height: screenHeight * 0.03),
                  _buildSubmitButton(screenWidth * 0.4, screenHeight),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(double screenWidth, bool isDarkMode) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            size: screenWidth * 0.06,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            widget.category,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: screenWidth * 0.047,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          '${currentQuestionIndex + 1}/${widget.questions.length}',
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black,
            fontSize: screenWidth * 0.035,
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Container(
      width: double.infinity,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(11),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: (currentQuestionIndex + 1) / widget.questions.length,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF8F9ABA),
            borderRadius: BorderRadius.circular(11),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionBox(Question currentQuestion, double screenWidth, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
        border: Border.all(
          width: 3,
          color: const Color(0xFF8F9ABA),
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        currentQuestion.question,
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
          fontSize: screenWidth * 0.035,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w700,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildAnswerOptions(Question question, double screenWidth, bool isDarkMode) {
    return Column(
      children: List.generate(
        question.options.length,
            (index) => _AnswerOption(
          key: ValueKey('${currentQuestionIndex}_$index'),
          option: question.options[index],
          isSelected: selectedAnswerIndex == index,
          onTap: () => _selectAnswer(index),
          screenWidth: screenWidth,
          isDarkMode: isDarkMode,
        ),
      ),
    );
  }

  Widget _buildSubmitButton(double screenWidth, double screenHeight) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 50,
          maxHeight: screenHeight * 0.15,
        ),
        child: SizedBox(
          width: screenWidth * 0.35,
          child: ElevatedButton(
            onPressed: _checkAnswer,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEE7C9E),
              foregroundColor: Colors.white,
              elevation: 5,
              shadowColor: Colors.black45,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(
                  color: Color(0xFFD6698A),
                  width: 2,
                ),
              ),
            ),
            child: const Text(
              'Submit',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ⭐ Extracted answer option widget for better performance
class _AnswerOption extends StatelessWidget {
  final String option;
  final bool isSelected;
  final VoidCallback onTap;
  final double screenWidth;
  final bool isDarkMode;

  const _AnswerOption({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
    required this.screenWidth,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 18,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFEE7C9E)
                : (isDarkMode ? const Color(0xFF2D2D2D) : const Color(0xFFFFFFFF)),
            border: Border.all(
              width: 3,
              color: const Color(0xFFEE7C9E),
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            option,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : (isDarkMode ? Colors.white : Colors.black),
              fontSize: screenWidth * 0.035,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
