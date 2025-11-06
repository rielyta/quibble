import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/quiz_stats_service.dart';
import '../../model/level_system.dart';
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

class _ResultScreenState extends State<ResultScreen> {
  bool _leveledUp = false;
  LevelData? _newLevel;

  @override
  void initState() {
    super.initState();
    _saveStatsAndCheckLevelUp();
  }

  Future<void> _saveStatsAndCheckLevelUp() async {
    // Get old stats
    final oldStats = await QuizStatsService.loadStats();
    final oldXP = oldStats.totalXP;

    // Update stats
    await QuizStatsService.updateStatsAfterQuiz(
      correctAnswers: widget.correctAnswers,
      totalQuestions: widget.totalQuestions,
    );

    // Get new stats
    final newStats = await QuizStatsService.loadStats();
    final newXP = newStats.totalXP;

    // Check if leveled up
    if (LevelSystem.checkLevelUp(oldXP, newXP)) {
      setState(() {
        _leveledUp = true;
        _newLevel = LevelSystem.getCurrentLevel(newXP);
      });

      // Show level up dialog after a short delay
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

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
                  width: isLandscape ? 200.0 : 150.0,
                  height: isLandscape ? 200.0 : 150.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDarkMode
                        ? Colors.white.withValues(alpha: 0.03)
                        : Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: isLandscape ? 100 : 80,
                left: isLandscape ? -30 : -20,
                child: Container(
                  width: isLandscape ? 150.0 : 120.0,
                  height: isLandscape ? 150.0 : 120.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDarkMode
                        ? Colors.white.withValues(alpha: 0.03)
                        : Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),

              // Main content
              isLandscape
                  ? _buildLandscapeLayout(isDarkMode)
                  : _buildPortraitLayout(isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(bool isDarkMode) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final wrongAnswers = widget.totalQuestions - widget.correctAnswers;
    final score = ((widget.correctAnswers / widget.totalQuestions) * 100).round();
    final earnedXP = widget.correctAnswers * 10;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.08,
          vertical: screenHeight * 0.03,
        ),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.02),

            // Title with Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEE7C9E), Color(0xFFF295B0)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFEE7C9E).withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.assessment,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Quiz Result',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : const Color(0xFF5D4037),
                    fontSize: screenWidth * 0.07,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),

            SizedBox(height: screenHeight * 0.04),

            // XP Earned Badge
            _buildXPBadge(earnedXP, isDarkMode, false),

            SizedBox(height: screenHeight * 0.03),

            // Stats Row
            _buildStatsRow(wrongAnswers, isDarkMode, false),

            SizedBox(height: screenHeight * 0.03),

            // Score Card
            _buildScoreCard(score, isDarkMode, false),

            SizedBox(height: screenHeight * 0.03),

            // Action Buttons
            _buildActionButtons(false),

            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(bool isDarkMode) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final wrongAnswers = widget.totalQuestions - widget.correctAnswers;
    final score = ((widget.correctAnswers / widget.totalQuestions) * 100).round();
    final earnedXP = widget.correctAnswers * 10;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06,
          vertical: screenHeight * 0.04,
        ),
        child: Column(
          children: [
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEE7C9E), Color(0xFFF295B0)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFEE7C9E).withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.assessment,
                    color: Colors.white,
                    size: screenHeight * 0.08,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Quiz Result',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : const Color(0xFF5D4037),
                    fontSize: screenHeight * 0.08,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),

            SizedBox(height: screenHeight * 0.03),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      _buildXPBadge(earnedXP, isDarkMode, true),
                      SizedBox(height: screenHeight * 0.03),
                      _buildStatsRow(wrongAnswers, isDarkMode, true),
                    ],
                  ),
                ),

                SizedBox(width: screenWidth * 0.04),

                // Right Column
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      _buildScoreCard(score, isDarkMode, true),
                      SizedBox(height: screenHeight * 0.03),
                      _buildActionButtons(true),
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

  Widget _buildXPBadge(int earnedXP, bool isDarkMode, bool isLandscape) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLandscape ? screenWidth * 0.04 : screenWidth * 0.06,
        vertical: isLandscape ? screenHeight * 0.025 : screenHeight * 0.02,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFB74D), Color(0xFFFFA726)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFB74D).withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.bolt,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '+$earnedXP XP',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isLandscape ? screenHeight * 0.08 : screenWidth * 0.08,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                ),
              ),
              Text(
                'Experience Earned!',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.95),
                  fontSize: isLandscape ? screenHeight * 0.04 : screenWidth * 0.038,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(int wrongAnswers, bool isDarkMode, bool isLandscape) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: _buildStatBox(
            icon: Icons.check_circle,
            label: 'Correct',
            value: widget.correctAnswers,
            gradientColors: const [Color(0xFF59A855), Color(0xFF66BB6A)],
            isDarkMode: isDarkMode,
            isLandscape: isLandscape,
          ),
        ),
        SizedBox(width: isLandscape ? screenWidth * 0.02 : screenWidth * 0.04),
        Expanded(
          child: _buildStatBox(
            icon: Icons.cancel,
            label: 'Wrong',
            value: wrongAnswers,
            gradientColors: const [Color(0xFFF5405B), Color(0xFFEF5350)],
            isDarkMode: isDarkMode,
            isLandscape: isLandscape,
          ),
        ),
      ],
    );
  }

  Widget _buildStatBox({
    required IconData icon,
    required String label,
    required int value,
    required List<Color> gradientColors,
    required bool isDarkMode,
    required bool isLandscape,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.all(isLandscape ? screenHeight * 0.03 : screenWidth * 0.04),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.3 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(isLandscape ? screenHeight * 0.02 : screenWidth * 0.03),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: gradientColors[0].withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: isLandscape ? screenHeight * 0.06 : screenWidth * 0.08,
            ),
          ),
          SizedBox(height: isLandscape ? screenHeight * 0.015 : screenHeight * 0.01),
          Text(
            '$value',
            style: TextStyle(
              color: gradientColors[0],
              fontSize: isLandscape ? screenHeight * 0.1 : screenWidth * 0.12,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w900,
              height: 1.0,
            ),
          ),
          SizedBox(height: isLandscape ? screenHeight * 0.008 : screenHeight * 0.005),
          Text(
            label,
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : const Color(0xFF8D6E63),
              fontSize: isLandscape ? screenHeight * 0.04 : screenWidth * 0.04,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(int score, bool isDarkMode, bool isLandscape) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Determine color based on score
    List<Color> scoreGradient;
    if (score >= 80) {
      scoreGradient = const [Color(0xFF59A855), Color(0xFF66BB6A)]; // Green
    } else if (score >= 60) {
      scoreGradient = const [Color(0xFFFFB74D), Color(0xFFFFA726)]; // Orange
    } else {
      scoreGradient = const [Color(0xFFF5405B), Color(0xFFEF5350)]; // Red
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isLandscape ? screenHeight * 0.04 : screenWidth * 0.06),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFEE7C9E),
            const Color(0xFFF295B0),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEE7C9E).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Final Score',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.95),
                  fontSize: isLandscape ? screenHeight * 0.05 : screenWidth * 0.045,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(
                score >= 80 ? Icons.emoji_events : (score >= 60 ? Icons.star : Icons.trending_up),
                color: Colors.white,
                size: isLandscape ? screenHeight * 0.06 : screenWidth * 0.07,
              ),
            ],
          ),
          SizedBox(height: isLandscape ? screenHeight * 0.03 : screenHeight * 0.02),

          // Score Circle
          Container(
            width: isLandscape ? screenHeight * 0.35 : screenWidth * 0.45,
            height: isLandscape ? screenHeight * 0.35 : screenWidth * 0.45,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$score',
                    style: TextStyle(
                      color: scoreGradient[0],
                      fontSize: isLandscape ? screenHeight * 0.15 : screenWidth * 0.18,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    '%',
                    style: TextStyle(
                      color: scoreGradient[0],
                      fontSize: isLandscape ? screenHeight * 0.07 : screenWidth * 0.08,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: isLandscape ? screenHeight * 0.025 : screenHeight * 0.02),

          // Score Message
          Text(
            _getScoreMessage(score),
            style: TextStyle(
              color: Colors.white,
              fontSize: isLandscape ? screenHeight * 0.045 : screenWidth * 0.04,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getScoreMessage(int score) {
    if (score == 100) return '🎉 Perfect Score!';
    if (score >= 90) return '🌟 Excellent Work!';
    if (score >= 80) return '💪 Great Job!';
    if (score >= 70) return '👍 Good Effort!';
    if (score >= 60) return '📚 Keep Learning!';
    return '💡 Practice More!';
  }

  Widget _buildActionButtons(bool isLandscape) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (isLandscape) {
      return Row(
        children: [
          Expanded(
            child: _buildRetryButton(isLandscape),
          ),
          SizedBox(width: screenWidth * 0.02),
          Expanded(
            child: _buildHomeButton(isLandscape),
          ),
        ],
      );
    }

    return Column(
      children: [
        _buildHomeButton(isLandscape),
        SizedBox(height: screenHeight * 0.015),
        _buildRetryButton(isLandscape),
      ],
    );
  }

  Widget _buildHomeButton(bool isLandscape) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: double.infinity,
      height: isLandscape ? screenHeight * 0.12 : 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8F9ABA),
          foregroundColor: Colors.white,
          elevation: 5,
          shadowColor: const Color(0xFF8F9ABA).withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home, size: 24),
            const SizedBox(width: 12),
            Text(
              'Back to Home',
              style: TextStyle(
                fontSize: isLandscape ? screenHeight * 0.05 : 18,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRetryButton(bool isLandscape) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: double.infinity,
      height: isLandscape ? screenHeight * 0.12 : 50,
      child: OutlinedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFEE7C9E),
          side: const BorderSide(
            color: Color(0xFFEE7C9E),
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.refresh, size: 24),
            const SizedBox(width: 12),
            Text(
              'Try Again',
              style: TextStyle(
                fontSize: isLandscape ? screenHeight * 0.05 : 18,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}