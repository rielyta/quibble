import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quibble/data/data_bible_character.dart';
import 'package:quibble/data/data_bible_verse.dart';
import 'package:quibble/data/data_bible_event.dart';
import 'package:quibble/screen/quiz/quiz_screen.dart';
import '../../widgets/navigation_bar.dart';
import '../../widgets/list_quiz.dart';
import '../../provider/theme_provider.dart';

class QuizListScreen extends StatelessWidget {
  const QuizListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    final navBarHeight = isLandscape ? screenHeight * 0.15 : screenHeight * 0.10;

    final topSpacing = isLandscape ? screenHeight * 0.06 : screenHeight * 0.04;
    final headerIconSize = isLandscape ? screenHeight * 0.14 : screenWidth * 0.18;
    final headerIconInnerSize = isLandscape ? screenHeight * 0.08 : screenWidth * 0.1;
    final titleFontSize = isLandscape ? screenHeight * 0.09 : screenWidth * 0.08;
    final subtitleFontSize = isLandscape ? screenHeight * 0.045 : screenWidth * 0.038;
    final contentSpacing = isLandscape ? screenHeight * 0.06 : screenHeight * 0.03;
    final cardSpacing = isLandscape ? screenHeight * 0.03 : screenHeight * 0.02;
    final horizontalPadding = isLandscape ? screenWidth * 0.12 : screenWidth * 0.08;

    // Decorative circles
    final largeCircleSize = isLandscape ? 250.0 : 200.0;
    final smallCircleSize = isLandscape ? 180.0 : 150.0;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDarkMode
                  ? [
                const Color(0xFF1A1A1A),
                const Color(0xFF2D2D2D),
                const Color(0xFF3D3D3D),
              ]
                  : [
                const Color(0xFFFFF8E7),
                const Color(0xFFFFE19E),
                const Color(0xFFFFD180),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Decorative circles in background
              Positioned(
                top: isLandscape ? -60 : -50,
                right: isLandscape ? -60 : -50,
                child: Container(
                  width: largeCircleSize,
                  height: largeCircleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDarkMode
                        ? Colors.white.withValues(alpha: 0.03)
                        : Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: isLandscape ? 120 : 100,
                left: isLandscape ? -40 : -30,
                child: Container(
                  width: smallCircleSize,
                  height: smallCircleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDarkMode
                        ? Colors.white.withValues(alpha: 0.03)
                        : Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),

              // Main Content
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: navBarHeight + (isLandscape ? 15 : 10),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: topSpacing),

                      // Header Section
                      Column(
                        children: [
                          // Quiz Icon
                          Container(
                            width: headerIconSize,
                            height: headerIconSize,
                            decoration: BoxDecoration(
                              color: isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: isDarkMode ? 0.4 : 0.15),
                                  blurRadius: isLandscape ? 18 : 15,
                                  offset: Offset(0, isLandscape ? 6 : 5),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.quiz_outlined,
                              size: headerIconInnerSize,
                              color: const Color(0xFFFFB74D),
                            ),
                          ),

                          SizedBox(height: isLandscape ? screenHeight * 0.025 : screenHeight * 0.02),

                          // Title
                          Text(
                            'Bible Quiz',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : const Color(0xFF5D4037),
                              fontSize: titleFontSize,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),

                          SizedBox(height: isLandscape ? screenHeight * 0.012 : screenHeight * 0.008),

                          // Subtitle
                          Text(
                            'Test your knowledge',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white70 : const Color(0xFF8D6E63),
                              fontSize: subtitleFontSize,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: contentSpacing),

                      // Quiz Categories
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: Column(
                          children: [
                            QuizCard(
                              title: 'Bible Characters',
                              subtitle: 'Test your knowledge of biblical figures',
                              imagePath: 'assets/images/biblechara.png',
                              gradientColors: const [
                                Color(0xFF8F9ABA),
                                Color(0xFFA3ADCA),
                              ],
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

                            SizedBox(height: cardSpacing),

                            QuizCard(
                              title: 'Bible Verses',
                              subtitle: 'Remember the sacred scriptures',
                              imagePath: 'assets/images/bibleverse.png',
                              gradientColors: const [
                                Color(0xFFEE7C9E),
                                Color(0xFFF295B0),
                              ],
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

                            SizedBox(height: cardSpacing),

                            QuizCard(
                              title: 'Bible Events',
                              subtitle: 'Recall important biblical moments',
                              imagePath: 'assets/images/biblevent.png',
                              gradientColors: const [
                                Color(0xFF8F9ABA),
                                Color(0xFFA3ADCA),
                              ],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuizQuestionScreen(
                                      category: 'Bible Events',
                                      questions: BibleEventsQuestions.questions,
                                    ),
                                  ),
                                );
                              },
                            ),

                            SizedBox(height: isLandscape ? screenHeight * 0.03 : screenHeight * 0.02),
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