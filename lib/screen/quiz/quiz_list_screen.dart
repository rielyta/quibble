import 'package:flutter/material.dart';
import 'package:quibble/data/data_bible_character.dart';
import 'package:quibble/data/data_bible_verse.dart';
import 'package:quibble/screen/home_screen.dart';
import 'package:quibble/screen/quiz/quiz_screen.dart';
import '../../widgets/navigation_bar.dart';
import '../profile_screen.dart';

class QuizListScreen extends StatefulWidget {
  const QuizListScreen({super.key});

  @override
  State<QuizListScreen> createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Color(0xFFFFE19E)],
              stops: [0, 0.3],
            ),
          ),
          child: Stack(
            children: [
              // Main Content
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.03),

                    // Title
                    Center(
                      child: Text(
                        'Quiz',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.070,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // Random Button
                    GestureDetector(
                      onTap: () {
                        debugPrint('Random quiz tapped');
                      },
                      child: Container(
                        width: screenWidth * 0.2,
                        height: screenHeight * 0.1,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/RandomButton.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // Quiz Categories
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                      child: Column(
                        children: [
                          _buildQuizCard(
                            context: context,
                            title: 'Bible Characters',
                            imagePath: 'assets/images/biblechara.png',
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          onTap:
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        QuizQuestionScreen(
                                          category: 'Bible Characters',
                                          questions: BibleCharactersQuestions
                                              .questions,
                                        ),
                                  ),
                                );
                              }
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          _buildQuizCard(
                            context: context,
                            title: 'Bible Verses',
                            imagePath: 'assets/images/bibleverse.png',
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                              onTap:
                                  () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        QuizQuestionScreen(
                                          category: 'Bible Verses',
                                          questions: BibleVersesQuestions
                                              .questions,
                                        ),
                                  ),
                                );
                            }
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          _buildQuizCard(
                            context: context,
                            title: 'Bible Events',
                            imagePath: 'assets/images/biblevent.png',
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                            onTap: () {
                              debugPrint('Bible Events tapped');
                            },
                          ),
                        ],
                      ),
                    ),

                    // Bottom padding untuk navigation bar
                    SizedBox(height: screenHeight * 0.15),
                  ],
                ),
              ),

              // Bottom Navigation Bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: CustomNavigationBar(
                  currentIndex: _currentIndex,
                  onTap: _onNavTap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizCard({
    required BuildContext context,
    required String title,
    required String imagePath,
    required VoidCallback onTap,
    required double screenWidth,
    required double screenHeight,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: screenHeight * 0.09,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.01,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon/Image
            Container(
              width: screenWidth * 0.16,
              height: screenWidth * 0.16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(width: screenWidth * 0.04),

            // Title
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: screenWidth * 0.042,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // Arrow Icon
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: screenWidth * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}


