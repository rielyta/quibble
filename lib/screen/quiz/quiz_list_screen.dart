import 'package:flutter/material.dart';
import 'package:quibble/data/data_bible_character.dart';
import 'package:quibble/data/data_bible_verse.dart';
import 'package:quibble/screen/quiz/quiz_screen.dart';
import '../../widgets/navigation_bar.dart';
import '../../widgets/list_quiz.dart';

class QuizListScreen extends StatelessWidget {
  const QuizListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final navBarHeight = isLandscape ? screenHeight * 0.15 : screenHeight * 0.10;

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
                child: Padding(
                  padding: EdgeInsets.only(bottom: navBarHeight + 10),
                  child: Column(
                    children: [
                      SizedBox(height: isLandscape ? screenHeight * 0.05 : screenHeight * 0.03),

                      // Title
                      Center(
                        child: Text(
                          'Quiz',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: isLandscape ? screenHeight * 0.08 : screenWidth * 0.070,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      SizedBox(height: isLandscape ? screenHeight * 0.04 : screenHeight * 0.02),

                      // Quiz Categories
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isLandscape ? screenWidth * 0.15 : screenWidth * 0.1,
                        ),
                        child: Column(
                          children: [
                            QuizCard(
                              title: 'Bible Characters',
                              imagePath: 'assets/images/biblechara.png',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuizQuestionScreen(
                                      category: 'Bible Characters',
                                      questions: BibleCharactersQuestions.questions,
                                    ),
                                  ),
                                );
                              },
                            ),

                            SizedBox(height: isLandscape ? screenHeight * 0.03 : screenHeight * 0.02),

                            QuizCard(
                              title: 'Bible Verses',
                              imagePath: 'assets/images/bibleverse.png',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuizQuestionScreen(
                                      category: 'Bible Verses',
                                      questions: BibleVersesQuestions.questions,
                                    ),
                                  ),
                                );
                              },
                            ),

                            SizedBox(height: isLandscape ? screenHeight * 0.03 : screenHeight * 0.02),

                            QuizCard(
                              title: 'Bible Events',
                              imagePath: 'assets/images/biblevent.png',
                              onTap: () {
                                debugPrint('Bible Events tapped');
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Navigation Bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: const CustomNavigationBar(
                  currentIndex: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}