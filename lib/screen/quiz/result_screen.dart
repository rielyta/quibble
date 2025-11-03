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
    final wrongAnswers = widget.totalQuestions - widget.correctAnswers;
    final score = ((widget.correctAnswers / widget.totalQuestions) * 100).round();

    return Scaffold(
      backgroundColor: const Color(0xFFFFEAB9),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.11),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.02),

              // Title
              Text(
                'Result',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: screenWidth * 0.058,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // Correct and Wrong Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Correct Box
                  Container(
                    width: screenWidth * 0.33,
                    height: screenHeight * 0.05,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Correct',
                          style: TextStyle(
                            color: const Color(0xFF59A855),
                            fontSize: screenWidth * 0.047,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Text(
                          '${widget.correctAnswers}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.058,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Wrong Box
                  Container(
                    width: screenWidth * 0.33,
                    height: screenHeight * 0.05,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Wrong',
                          style: TextStyle(
                            color: const Color(0xFFF5405B),
                            fontSize: screenWidth * 0.047,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Text(
                          '$wrongAnswers',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.058,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.04),

              // Main Score Card
              Container(
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
                    // Your Final Score Text
                    Text(
                      'Your Final\nScore',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFDB688A),
                        fontSize: screenWidth * 0.084,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Score Circle
                    Container(
                      width: screenWidth * 0.44,
                      height: screenWidth * 0.44,
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
                            fontSize: screenWidth * 0.15,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),
                  ],
                ),
              ),

              const Spacer(),

              // Next Button
              SizedBox(
                width: screenWidth * 0.4,
                height: 37,
                child: ElevatedButton(
                  onPressed: () {
                    // Kembali ke Home Screen dan refresh data
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEE7C9E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}