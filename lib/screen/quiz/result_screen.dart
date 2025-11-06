import 'package:flutter/material.dart';
import '../../services/quiz_stats_service.dart';

class ResultScreen extends StatefulWidget {
  final int correctAnswers;
  final int totalQuestions;
  final String category;

  const ResultScreen({
    super.key,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.category,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
    _saveStats();
  }

  Future<void> _saveStats() async {
    await QuizStatsService.updateStatsAfterQuiz(
      correctAnswers: widget.correctAnswers,
      totalQuestions: widget.totalQuestions,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: const Color(0xFFFFEAB9),
      body: SafeArea(
        child: isLandscape
            ? _buildLandscapeLayout()
            : _buildPortraitLayout(),
      ),
    );
  }

  Widget _buildPortraitLayout() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final wrongAnswers = widget.totalQuestions - widget.correctAnswers;
    final score = ((widget.correctAnswers / widget.totalQuestions) * 100).round();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.11),
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          _buildTitle(),
          SizedBox(height: screenHeight * 0.03),
          _buildStatsRow(wrongAnswers),
          SizedBox(height: screenHeight * 0.04),
          _buildScoreCard(score),
          SizedBox(height: screenHeight * 0.05),
          _buildNextButton(),
          SizedBox(height: screenHeight * 0.04),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final wrongAnswers = widget.totalQuestions - widget.correctAnswers;
    final score = ((widget.correctAnswers / widget.totalQuestions) * 100).round();

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.08,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          children: [
            _buildTitle(),
            SizedBox(height: screenHeight * 0.02),
            _buildStatsRow(wrongAnswers),
            SizedBox(height: screenHeight * 0.03),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: _buildScoreCard(score),
                ),
                SizedBox(width: screenWidth * 0.04),
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNextButton(),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    final screenWidth = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;

    return Text(
      'Result',
      style: TextStyle(
        color: Colors.black,
        fontSize: isLandscape ? screenWidth * 0.04 : screenWidth * 0.058,
        fontFamily: 'SF Pro',
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildStatsRow(int wrongAnswers) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatBox(
          'Correct',
          widget.correctAnswers,
          const Color(0xFF59A855),
        ),
        _buildStatBox(
          'Wrong',
          wrongAnswers,
          const Color(0xFFF5405B),
        ),
      ],
    );
  }

  Widget _buildStatBox(String label, int value, Color color) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;

    return Container(
      width: isLandscape ? screenWidth * 0.3 : screenWidth * 0.33,
      height: screenHeight * 0.08,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: isLandscape ? screenWidth * 0.035 : screenWidth * 0.047,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: screenWidth * 0.02),
          Text(
            '$value',
            style: TextStyle(
              color: Colors.black,
              fontSize: isLandscape ? screenWidth * 0.04 : screenWidth * 0.058,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(int score) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.03,
        horizontal: screenWidth * 0.05,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34),
      ),
      child: Column(
        children: [
          Text(
            'Your Final\nScore',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFFDB688A),
              fontSize: isLandscape ? screenWidth * 0.06 : screenWidth * 0.084,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
          SizedBox(height: screenHeight * 0.03),
          Container(
            width: isLandscape ? screenWidth * 0.3 : screenWidth * 0.44,
            height: isLandscape ? screenWidth * 0.3 : screenWidth * 0.44,
            constraints: const BoxConstraints(
              maxWidth: 200,
              maxHeight: 200,
            ),
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.5,
                colors: [Color(0xFFACB6D4), Color(0xFF8F9ABA)],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$score',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isLandscape ? screenWidth * 0.1 : screenWidth * 0.15,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.03),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;

    final buttonHeight = screenHeight * 0.07 < 45 ? 45.0 : screenHeight * 0.07;

    return Center(
      child: SizedBox(
        width: isLandscape ? screenWidth * 0.25 : screenWidth * 0.3,
        height: buttonHeight,
        child: ElevatedButton(
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFEE7C9E),
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: Colors.black45,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(
                color: Color(0xFFD6698A),
                width: 2,
              ),
            ),
          ),
          child: const Text(
            'Next',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}