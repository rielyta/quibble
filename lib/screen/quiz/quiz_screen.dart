import 'package:flutter/material.dart';
import 'package:quibble/screen/quiz/result_screen.dart';
import '../../model/question_model.dart';
import '../../widgets/result_dialog.dart';

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
  String? selectedAnswer;
  int correctAnswers = 0;

  void _checkAnswer() {
    if (selectedAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an answer'),
          backgroundColor: Color(0xFFEE7C9E),
        ),
      );
      return;
    }

    final isCorrect =
        selectedAnswer == widget.questions[currentQuestionIndex].correctAnswer;

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
        selectedAnswer = null;
      });
    } else {
      // Quiz selesai - navigasi ke Result Screen
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final currentQuestion = widget.questions[currentQuestionIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFFFEAB9),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.04),

              // Header
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, size: 30),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.category,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.047,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    '${currentQuestionIndex + 1}/${widget.questions.length}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth * 0.035,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.02),

              // Progress Bar
              Container(
                width: double.infinity,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor:
                  (currentQuestionIndex + 1) / widget.questions.length,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF8F9ABA),
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // Question Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 3,
                    color: const Color(0xFF8F9ABA),
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  currentQuestion.question,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenWidth * 0.035,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // Answer Options
              ...currentQuestion.options.map((option) {
                final isSelected = selectedAnswer == option;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAnswer = option;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFEE7C9E)
                            : const Color(0xFFFFFFFF),
                        border: Border.all(
                          width: 3,
                          color: const Color(0xFFEE7C9E
                          )
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.035,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),

              SizedBox(height: screenHeight * 0.02),


              // Submit Button
              Center(
                child: SizedBox(
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.045,
                  child: ElevatedButton(
                    onPressed: _checkAnswer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEE7C9E),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w700,
                      ),
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