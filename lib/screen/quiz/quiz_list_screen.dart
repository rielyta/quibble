import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quibble/data/data_bible_character.dart';
import 'package:quibble/data/data_bible_verse.dart';
import 'package:quibble/data/data_bible_event.dart';
import 'package:quibble/screen/quiz/quiz_screen.dart';
import '../../widgets/navigation_bar.dart';
import '../../widgets/list_quiz.dart';
import '../../provider/theme_provider.dart';

class QuizListScreen extends StatefulWidget {
  const QuizListScreen({super.key});

  @override
  State<QuizListScreen> createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  late final BoxDecoration _lightDecoration;
  late final BoxDecoration _darkDecoration;

  @override
  void initState() {
    super.initState();

    _lightDecoration = const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFF8E7),
          Color(0xFFFFE19E),
          Color(0xFFFFD180),
        ],
        stops: [0.0, 0.5, 1.0],
      ),
    );

    _darkDecoration = const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF1A1A1A),
          Color(0xFF2D2D2D),
          Color(0xFF3D3D3D),
        ],
        stops: [0.0, 0.5, 1.0],
      ),
    );


    _preloadImagesAsync();
  }

  Future<void> _preloadImagesAsync() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      try {
        await Future.wait([
          precacheImage(const AssetImage('assets/images/biblechara.png'), context),
          precacheImage(const AssetImage('assets/images/bibleverse.png'), context),
          precacheImage(const AssetImage('assets/images/biblevent.png'), context),
        ]);

        if (mounted) {
          setState(() {});
        }
      } catch (e) {
        debugPrint('Error preloading images: $e');
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  void _navigateToQuiz(String category, dynamic questions) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizQuestionScreen(
          category: category,
          questions: questions,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    final navBarHeight = isLandscape ? screenHeight * 0.15 : screenHeight * 0.10;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: isDarkMode ? _darkDecoration : _lightDecoration,
          child: Stack(
            children: [
              // Main Content
              _buildMainContent(
                screenWidth,
                screenHeight,
                isLandscape,
                isDarkMode,
                navBarHeight,
              ),

              // Bottom Navigation Bar
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: CustomNavigationBar(currentIndex: 0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(
      double screenWidth,
      double screenHeight,
      bool isLandscape,
      bool isDarkMode,
      double navBarHeight,
      ) {
    final topSpacing = isLandscape ? screenHeight * 0.06 : screenHeight * 0.04;
    final contentSpacing = isLandscape ? screenHeight * 0.06 : screenHeight * 0.03;
    final cardSpacing = isLandscape ? screenHeight * 0.03 : screenHeight * 0.02;
    final horizontalPadding = isLandscape ? screenWidth * 0.12 : screenWidth * 0.08;
    final bottomPadding = navBarHeight + (isLandscape ? screenHeight * 0.02 : screenHeight * 0.012);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Column(
          children: [
            SizedBox(height: topSpacing),

            // Header Section
            _buildHeader(screenWidth, screenHeight, isLandscape, isDarkMode),

            SizedBox(height: contentSpacing),

            // Quiz Categories
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
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
                    onTap: () => _navigateToQuiz(
                      'Bible Characters',
                      BibleCharactersQuestions.questions,
                    ),
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
                    onTap: () => _navigateToQuiz(
                      'Bible Verses',
                      BibleVersesQuestions.questions,
                    ),
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
                    onTap: () => _navigateToQuiz(
                      'Bible Events',
                      BibleEventsQuestions.questions,
                    ),
                  ),
                  SizedBox(height: isLandscape ? screenHeight * 0.03 : screenHeight * 0.02),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
      double screenWidth,
      double screenHeight,
      bool isLandscape,
      bool isDarkMode,
      ) {
    final headerIconSize = isLandscape ? screenHeight * 0.14 : screenWidth * 0.18;
    final headerIconInnerSize = isLandscape ? screenHeight * 0.08 : screenWidth * 0.1;
    final titleFontSize = isLandscape ? screenHeight * 0.09 : screenWidth * 0.08;
    final subtitleFontSize = isLandscape ? screenHeight * 0.045 : screenWidth * 0.038;
    final shadowBlurRadius = isLandscape ? screenHeight * 0.023 : screenWidth * 0.04;
    final shadowOffset = isLandscape ? screenHeight * 0.008 : screenHeight * 0.006;

    return Column(
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
                blurRadius: shadowBlurRadius,
                offset: Offset(0, shadowOffset),
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
    );
  }
}