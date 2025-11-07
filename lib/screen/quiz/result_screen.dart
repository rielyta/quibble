import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/quiz_stats_service.dart';
import '../../util/level_system.dart';
import '../../provider/theme_provider.dart';
import '../../widgets/level_up_dialog.dart';

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

class _ResultScreenState extends State<ResultScreen> with SingleTickerProviderStateMixin {
  LevelData? _newLevel;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
    _saveStatsAndCheckLevelUp();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _saveStatsAndCheckLevelUp() async {
    final oldStats = await QuizStatsService.loadStats();
    final oldXP = oldStats.totalXP;

    await QuizStatsService.updateStatsAfterQuiz(
      correctAnswers: widget.correctAnswers,
      totalQuestions: widget.totalQuestions,
    );

    final newStats = await QuizStatsService.loadStats();
    final newXP = newStats.totalXP;

    if (LevelSystem.checkLevelUp(oldXP, newXP)) {
      setState(() {
        _newLevel = LevelSystem.getCurrentLevel(newXP);
      });

      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted && _newLevel != null) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => LevelUpDialog(
              newLevel: _newLevel!,
              onContinue: () {},
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
              const Color(0xFF0F0F0F),
              const Color(0xFF1A1A2E),
              const Color(0xFF16213E),
            ]
                : [
              const Color(0xFFFFF4E6),
              const Color(0xFFFFE5CC),
              const Color(0xFFFFDAB3),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: isLandscape
                ? _buildLandscapeLayout(screenWidth, screenHeight, isDarkMode)
                : _buildPortraitLayout(screenWidth, screenHeight, isDarkMode),
          ),
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(double screenWidth, double screenHeight, bool isDarkMode) {
    final wrongAnswers = widget.totalQuestions - widget.correctAnswers;
    final score = ((widget.correctAnswers / widget.totalQuestions) * 100).round();
    final earnedXP = widget.correctAnswers * 10;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: screenHeight * 0.01),

                // Animated Header
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: _buildHeader(screenWidth, screenHeight, isDarkMode, false),
                ),

                SizedBox(height: screenHeight * 0.025),

                // Main Score Display
                _buildMainScoreCard(screenWidth, screenHeight, score, isDarkMode, false),

                SizedBox(height: screenHeight * 0.02),

                // XP Badge
                _buildXPBadge(screenWidth, screenHeight, earnedXP, isDarkMode, false),

                SizedBox(height: screenHeight * 0.02),

                // Stats Row
                _buildStatsRow(screenWidth, screenHeight, wrongAnswers, isDarkMode, false),

                SizedBox(height: screenHeight * 0.025),

                // Action Buttons
                _buildActionButtons(screenWidth, screenHeight, isDarkMode, false),

                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLandscapeLayout(double screenWidth, double screenHeight, bool isDarkMode) {
    final wrongAnswers = widget.totalQuestions - widget.correctAnswers;
    final score = ((widget.correctAnswers / widget.totalQuestions) * 100).round();
    final earnedXP = widget.correctAnswers * 10;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.03,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: _buildHeader(screenWidth, screenHeight, isDarkMode, true),
                ),

                SizedBox(height: screenHeight * 0.02),

                // Main Content Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column - Score
                    Expanded(
                      flex: 4,
                      child: _buildMainScoreCard(screenWidth, screenHeight, score, isDarkMode, true),
                    ),

                    SizedBox(width: screenWidth * 0.02),

                    // Right Column - Stats & Actions
                    Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildXPBadge(screenWidth, screenHeight, earnedXP, isDarkMode, true),
                          SizedBox(height: screenHeight * 0.015),
                          _buildStatsRow(screenWidth, screenHeight, wrongAnswers, isDarkMode, true),
                          SizedBox(height: screenHeight * 0.02),
                          _buildActionButtons(screenWidth, screenHeight, isDarkMode, true),
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
      },
    );
  }

  Widget _buildHeader(double screenWidth, double screenHeight, bool isDarkMode, bool isLandscape) {
    final iconSize = isLandscape ? screenHeight * 0.07 : screenWidth * 0.1;
    final titleSize = isLandscape ? screenHeight * 0.06 : screenWidth * 0.065;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: isLandscape ? screenHeight * 0.015 : screenHeight * 0.012,
      ),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(iconSize * 0.2),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEE7C9E), Color(0xFFF295B0)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFEE7C9E).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.emoji_events_rounded,
              color: Colors.white,
              size: iconSize * 0.7,
            ),
          ),
          SizedBox(width: screenWidth * 0.025),
          Flexible(
            child: Text(
              'Quiz Complete!',
              style: TextStyle(
                color: isDarkMode ? Colors.white : const Color(0xFF2D3436),
                fontSize: titleSize,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainScoreCard(double screenWidth, double screenHeight, int score, bool isDarkMode, bool isLandscape) {
    final circleSize = isLandscape ? screenHeight * 0.25 : screenWidth * 0.38;
    final scoreSize = isLandscape ? screenHeight * 0.15 : screenWidth * 0.18;

    List<Color> scoreGradient;
    IconData scoreIcon;
    String scoreLabel;

    if (score >= 80) {
      scoreGradient = const [Color(0xFFEE7C9E), Color(0xFFF295B0)];
      scoreIcon = Icons.celebration_rounded;
      scoreLabel = 'Excellent!';
    } else if (score >= 60) {
      scoreGradient = const [Color(0xFF8F9ABA), Color(0xFFA5B0CD)];
      scoreIcon = Icons.thumb_up_rounded;
      scoreLabel = 'Good Job!';
    } else {
      scoreGradient = const [Color(0xFFFFE29E), Color(0xFFFFEDB8)];
      scoreIcon = Icons.self_improvement_rounded;
      scoreLabel = 'Keep Going!';
    }

    return Container(
      padding: EdgeInsets.all(isLandscape ? screenHeight * 0.03 : screenWidth * 0.05),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: scoreGradient,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: scoreGradient[0].withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Score Label
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Your Score',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontSize: isLandscape ? screenHeight * 0.045 : screenWidth * 0.042,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                scoreIcon,
                color: Colors.white,
                size: isLandscape ? screenHeight * 0.055 : screenWidth * 0.07,
              ),
            ],
          ),

          SizedBox(height: isLandscape ? screenHeight * 0.015 : screenHeight * 0.012),

          // Score Circle
          Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$score',
                  style: TextStyle(
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: scoreGradient,
                      ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                    fontSize: scoreSize,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                  ),
                ),
                Text(
                  '%',
                  style: TextStyle(
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: scoreGradient,
                      ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                    fontSize: scoreSize * 0.4,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: isLandscape ? screenHeight * 0.015 : screenHeight * 0.012),

          // Score Message
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03,
              vertical: screenHeight * 0.008,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              scoreLabel,
              style: TextStyle(
                color: Colors.white,
                fontSize: isLandscape ? screenHeight * 0.04 : screenWidth * 0.04,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildXPBadge(double screenWidth, double screenHeight, int earnedXP, bool isDarkMode, bool isLandscape) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isLandscape ? screenHeight * 0.025 : screenWidth * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFEFBB4B),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFE29E).withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(isLandscape ? screenHeight * 0.02 : screenWidth * 0.015),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.bolt_rounded,
              color: Colors.white,
              size: isLandscape ? screenHeight * 0.055 : screenWidth * 0.07,
            ),
          ),
          SizedBox(width: screenWidth * 0.025),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '+$earnedXP XP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isLandscape ? screenHeight * 0.06 : screenWidth * 0.065,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                  ),
                ),
                Text(
                  'Experience Earned!',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: isLandscape ? screenHeight * 0.035 : screenWidth * 0.033,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(double screenWidth, double screenHeight, int wrongAnswers, bool isDarkMode, bool isLandscape) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            icon: Icons.check_circle_rounded,
            label: 'Correct',
            value: widget.correctAnswers,
            gradientColors: const [Color(0xFFEE7C9E), Color(0xFFF295B0)],
            isDarkMode: isDarkMode,
            isLandscape: isLandscape,
          ),
        ),
        SizedBox(width: isLandscape ? screenWidth * 0.015 : screenWidth * 0.025),
        Expanded(
          child: _buildStatCard(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            icon: Icons.cancel_rounded,
            label: 'Wrong',
            value: wrongAnswers,
            gradientColors: const [Color(0xFF8F9ABA), Color(0xFFA5B0CD)],
            isDarkMode: isDarkMode,
            isLandscape: isLandscape,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required double screenWidth,
    required double screenHeight,
    required IconData icon,
    required String label,
    required int value,
    required List<Color> gradientColors,
    required bool isDarkMode,
    required bool isLandscape,
  }) {
    return Container(
      padding: EdgeInsets.all(isLandscape ? screenHeight * 0.02 : screenWidth * 0.035),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.3 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(isLandscape ? screenHeight * 0.015 : screenWidth * 0.025),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradientColors),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: gradientColors[0].withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: isLandscape ? screenHeight * 0.05 : screenWidth * 0.065,
            ),
          ),
          SizedBox(height: isLandscape ? screenHeight * 0.01 : screenHeight * 0.008),
          Text(
            '$value',
            style: TextStyle(
              foreground: Paint()
                ..shader = LinearGradient(
                  colors: gradientColors,
                ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
              fontSize: isLandscape ? screenHeight * 0.08 : screenWidth * 0.095,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w900,
              height: 1.0,
            ),
          ),
          SizedBox(height: screenHeight * 0.003),
          Text(
            label,
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : const Color(0xFF636E72),
              fontSize: isLandscape ? screenHeight * 0.035 : screenWidth * 0.035,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(double screenWidth, double screenHeight, bool isDarkMode, bool isLandscape) {
    final buttonHeight = isLandscape ? screenHeight * 0.11 : screenHeight * 0.065;

    if (isLandscape) {
      return Row(
        children: [
          Expanded(
            child: _buildHomeButton(screenWidth, screenHeight, isDarkMode, isLandscape, buttonHeight),
          ),
          SizedBox(width: screenWidth * 0.015),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHomeButton(screenWidth, screenHeight, isDarkMode, isLandscape, buttonHeight),
      ],
    );
  }

  Widget _buildHomeButton(double screenWidth, double screenHeight, bool isDarkMode, bool isLandscape, double height) {
    final fontSize = isLandscape ? screenHeight * 0.04 : screenWidth * 0.042;

    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8F9ABA),
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: const Color(0xFF8F9ABA).withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: screenWidth * 0.015),
            Flexible(
              child: Text(
                'Back',
                style: TextStyle(
                  fontSize: fontSize,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}