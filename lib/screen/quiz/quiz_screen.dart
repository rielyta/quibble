import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quibble/screen/quiz/result_screen.dart';
import '../../model/question_model.dart';
import '../../widgets/result_dialog.dart';
import '../../provider/theme_provider.dart';
import '../../provider/quiz_state_provider.dart';

class QuizQuestionScreen extends StatelessWidget {
  const QuizQuestionScreen({super.key});

  void _selectAnswer(BuildContext context, int index) {
    context.read<QuizStateProvider>().selectAnswer(index);
  }

  void _checkAnswer(BuildContext context) {
    final quizState = context.read<QuizStateProvider>();

    if (quizState.selectedAnswerIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select an answer',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.035,
            ),
          ),
          backgroundColor: const Color(0xFFEE7C9E),
          duration: const Duration(seconds: 1),
        ),
      );
      return;
    }

    final isCorrect = quizState.submitAnswer();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ResultDialog(
        isCorrect: isCorrect,
        onNext: () {
          Navigator.pop(context);
          _nextQuestion(context);
        },
      ),
    );
  }

  void _nextQuestion(BuildContext context) {
    final quizState = context.read<QuizStateProvider>();
    final hasNextQuestion = quizState.nextQuestion();

    if (!hasNextQuestion) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            correctAnswers: quizState.correctAnswers,
            totalQuestions: quizState.totalQuestions,
            category: quizState.category,
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
                    ? _buildLandscapeLayout(context, screenWidth, screenHeight, isDarkMode)
                    : _buildPortraitLayout(context, screenWidth, screenHeight, isDarkMode);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context, double screenWidth, double screenHeight, bool isDarkMode) {
    return Consumer<QuizStateProvider>(
      builder: (context, quizState, child) {
        final currentQuestion = quizState.currentQuestion;
        if (currentQuestion == null) return const SizedBox();

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.04),
                _buildHeader(context, screenWidth, screenHeight, isDarkMode, false, quizState),
                SizedBox(height: screenHeight * 0.02),
                _buildProgressBar(screenHeight, quizState),
                SizedBox(height: screenHeight * 0.03),
                _buildQuestionBox(currentQuestion, screenWidth, screenHeight, isDarkMode, false),
                SizedBox(height: screenHeight * 0.03),
                _buildAnswerOptions(context, currentQuestion, screenWidth, screenHeight, isDarkMode, false, quizState),
                SizedBox(height: screenHeight * 0.02),
                _buildSubmitButton(context, screenWidth, screenHeight, false),
                SizedBox(height: screenHeight * 0.04),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLandscapeLayout(BuildContext context, double screenWidth, double screenHeight, bool isDarkMode) {
    return Consumer<QuizStateProvider>(
      builder: (context, quizState, child) {
        final currentQuestion = quizState.currentQuestion;
        if (currentQuestion == null) return const SizedBox();

        return Row(
          children: [
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, screenWidth, screenHeight, isDarkMode, true, quizState),
                      SizedBox(height: screenHeight * 0.03),
                      _buildProgressBar(screenHeight, quizState),
                      SizedBox(height: screenHeight * 0.04),
                      _buildQuestionBox(currentQuestion, screenWidth, screenHeight, isDarkMode, true),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: screenHeight * 0.02),
                      _buildAnswerOptions(context, currentQuestion, screenWidth, screenHeight, isDarkMode, true, quizState),
                      SizedBox(height: screenHeight * 0.03),
                      _buildSubmitButton(context, screenWidth, screenHeight, true),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, double screenWidth, double screenHeight, bool isDarkMode, bool isLandscape, QuizStateProvider quizState) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            size: isLandscape ? screenHeight * 0.06 : screenWidth * 0.06,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        SizedBox(width: screenWidth * 0.02),
        Expanded(
          child: Text(
            quizState.category,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: isLandscape ? screenHeight * 0.05 : screenWidth * 0.047,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          '${quizState.currentQuestionIndex + 1}/${quizState.totalQuestions}',
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black,
            fontSize: isLandscape ? screenHeight * 0.038 : screenWidth * 0.035,
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(double screenHeight, QuizStateProvider quizState) {
    return Container(
      width: double.infinity,
      height: screenHeight * 0.02,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(11),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: quizState.getProgress(),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF8F9ABA),
            borderRadius: BorderRadius.circular(11),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionBox(Question currentQuestion, double screenWidth, double screenHeight, bool isDarkMode, bool isLandscape) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isLandscape ? screenHeight * 0.03 : screenWidth * 0.05),
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
          fontSize: isLandscape ? screenHeight * 0.038 : screenWidth * 0.038,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w700,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildAnswerOptions(BuildContext context, Question question, double screenWidth, double screenHeight, bool isDarkMode, bool isLandscape, QuizStateProvider quizState) {
    return Column(
      children: List.generate(
        question.options.length,
            (index) => _AnswerOption(
          key: ValueKey('${quizState.currentQuestionIndex}_$index'),
          option: question.options[index],
          isSelected: quizState.selectedAnswerIndex == index,
          onTap: () => _selectAnswer(context, index),
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          isDarkMode: isDarkMode,
          isLandscape: isLandscape,
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, double screenWidth, double screenHeight, bool isLandscape) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: isLandscape ? screenHeight * 0.08 : screenHeight * 0.06,
          maxHeight: screenHeight * 0.15,
        ),
        child: SizedBox(
          width: isLandscape ? screenWidth * 0.25 : screenWidth * 0.35,
          child: ElevatedButton(
            onPressed: () => _checkAnswer(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEE7C9E),
              foregroundColor: Colors.white,
              elevation: 5,
              shadowColor: Colors.black45,
              padding: EdgeInsets.symmetric(
                vertical: isLandscape ? screenHeight * 0.02 : screenHeight * 0.018,
                horizontal: screenWidth * 0.04,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(
                  color: Color(0xFFD6698A),
                  width: 2,
                ),
              ),
            ),
            child: Text(
              'Submit',
              style: TextStyle(
                fontSize: isLandscape ? screenHeight * 0.045 : screenWidth * 0.048,
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

class _AnswerOption extends StatelessWidget {
  final String option;
  final bool isSelected;
  final VoidCallback onTap;
  final double screenWidth;
  final double screenHeight;
  final bool isDarkMode;
  final bool isLandscape;

  const _AnswerOption({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
    required this.screenWidth,
    required this.screenHeight,
    required this.isDarkMode,
    required this.isLandscape,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLandscape ? screenHeight * 0.02 : screenHeight * 0.018),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isLandscape ? screenWidth * 0.04 : screenWidth * 0.06,
            vertical: isLandscape ? screenHeight * 0.025 : screenHeight * 0.022,
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
              fontSize: isLandscape ? screenHeight * 0.038 : screenWidth * 0.038,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}