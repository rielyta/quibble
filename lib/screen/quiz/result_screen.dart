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

class _ResultScreenState extends State<ResultScreen> with SingleTickerProviderStateMixin {
  bool _leveledUp = false;
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
        _leveledUp = true;
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
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
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
                ? _buildLandscapeLayout(isDarkMode)
                : _buildPortraitLayout(isDarkMode),
          ),
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(bool isDarkMode) {
    final size = MediaQuery.of(context).size;
    final wrongAnswers = widget.totalQuestions - widget.correctAnswers;
    final score = ((widget.correctAnswers / widget.totalQuestions) * 100).round();
    final earnedXP = widget.correctAnswers * 10;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: size.height * 0.02,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: size.height * 0.01),

                // Animated Header
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: _buildHeader(isDarkMode, false),
                ),

                SizedBox(height: size.height * 0.025),

                // Main Score Display
                _buildMainScoreCard(score, isDarkMode, false),

                SizedBox(height: size.height * 0.02),

                // XP Badge
                _buildXPBadge(earnedXP, isDarkMode, false),

                SizedBox(height: size.height * 0.02),

                // Stats Row
                _buildStatsRow(wrongAnswers, isDarkMode, false),

                SizedBox(height: size.height * 0.025),

                // Action Buttons
                _buildActionButtons(isDarkMode, false),

                SizedBox(height: size.height * 0.02),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLandscapeLayout(bool isDarkMode) {
    final size = MediaQuery.of(context).size;
    final wrongAnswers = widget.totalQuestions - widget.correctAnswers;
    final score = ((widget.correctAnswers / widget.totalQuestions) * 100).round();
    final earnedXP = widget.correctAnswers * 10;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.04,
            vertical: size.height * 0.03,
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
                  child: _buildHeader(isDarkMode, true),
                ),

                SizedBox(height: size.height * 0.02),

                // Main Content Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column - Score
                    Expanded(
                      flex: 4,
                      child: _buildMainScoreCard(score, isDarkMode, true),
                    ),

                    SizedBox(width: size.width * 0.02),

                    // Right Column - Stats & Actions
                    Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildXPBadge(earnedXP, isDarkMode, true),
                          SizedBox(height: size.height * 0.015),
                          _buildStatsRow(wrongAnswers, isDarkMode, true),
                          SizedBox(height: size.height * 0.02),
                          _buildActionButtons(isDarkMode, true),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: size.height * 0.02),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isDarkMode, bool isLandscape) {
    final size = MediaQuery.of(context).size;
    final iconSize = isLandscape ? size.height * 0.07 : size.width * 0.1;
    final titleSize = isLandscape ? size.height * 0.06 : size.width * 0.065;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: isLandscape ? size.height * 0.015 : size.height * 0.012,
      ),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.white.withOpacity(0.5),
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
                  color: const Color(0xFFEE7C9E).withOpacity(0.3),
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
          SizedBox(width: size.width * 0.025),
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

  Widget _buildMainScoreCard(int score, bool isDarkMode, bool isLandscape) {
    final size = MediaQuery.of(context).size;
    final circleSize = isLandscape ? size.height * 0.25 : size.width * 0.38;
    final scoreSize = isLandscape ? size.height * 0.15 : size.width * 0.18;

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
      padding: EdgeInsets.all(isLandscape ? size.height * 0.03 : size.width * 0.05),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: scoreGradient,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: scoreGradient[0].withOpacity(0.4),
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
                    color: Colors.white.withOpacity(0.95),
                    fontSize: isLandscape ? size.height * 0.045 : size.width * 0.042,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                scoreIcon,
                color: Colors.white,
                size: isLandscape ? size.height * 0.055 : size.width * 0.07,
              ),
            ],
          ),

          SizedBox(height: isLandscape ? size.height * 0.015 : size.height * 0.012),

          // Score Circle
          Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
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

          SizedBox(height: isLandscape ? size.height * 0.015 : size.height * 0.012),

          // Score Message
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.03,
              vertical: size.height * 0.008,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              scoreLabel,
              style: TextStyle(
                color: Colors.white,
                fontSize: isLandscape ? size.height * 0.04 : size.width * 0.04,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildXPBadge(int earnedXP, bool isDarkMode, bool isLandscape) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isLandscape ? size.height * 0.025 : size.width * 0.04),
      decoration: BoxDecoration(
        color: Color(0xFFEFBB4B),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFE29E).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(size.width * 0.015),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.bolt_rounded,
              color: Colors.white,
              size: isLandscape ? size.height * 0.055 : size.width * 0.07,
            ),
          ),
          SizedBox(width: size.width * 0.025),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '+$earnedXP XP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isLandscape ? size.height * 0.06 : size.width * 0.065,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                  ),
                ),
                Text(
                  'Experience Earned!',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: isLandscape ? size.height * 0.035 : size.width * 0.033,
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

  Widget _buildStatsRow(int wrongAnswers, bool isDarkMode, bool isLandscape) {
    final size = MediaQuery.of(context).size;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.check_circle_rounded,
            label: 'Correct',
            value: widget.correctAnswers,
            gradientColors: const [Color(0xFFEE7C9E), Color(0xFFF295B0)],
            isDarkMode: isDarkMode,
            isLandscape: isLandscape,
          ),
        ),
        SizedBox(width: isLandscape ? size.width * 0.015 : size.width * 0.025),
        Expanded(
          child: _buildStatCard(
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
    required IconData icon,
    required String label,
    required int value,
    required List<Color> gradientColors,
    required bool isDarkMode,
    required bool isLandscape,
  }) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(isLandscape ? size.height * 0.02 : size.width * 0.035),
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF1E1E1E)
            : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(isLandscape ? size.height * 0.015 : size.width * 0.025),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradientColors),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: gradientColors[0].withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: isLandscape ? size.height * 0.05 : size.width * 0.065,
            ),
          ),
          SizedBox(height: isLandscape ? size.height * 0.01 : size.height * 0.008),
          Text(
            '$value',
            style: TextStyle(
              foreground: Paint()
                ..shader = LinearGradient(
                  colors: gradientColors,
                ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
              fontSize: isLandscape ? size.height * 0.08 : size.width * 0.095,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w900,
              height: 1.0,
            ),
          ),
          SizedBox(height: size.height * 0.003),
          Text(
            label,
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : const Color(0xFF636E72),
              fontSize: isLandscape ? size.height * 0.035 : size.width * 0.035,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isDarkMode, bool isLandscape) {
    final size = MediaQuery.of(context).size;
    final buttonHeight = isLandscape ? size.height * 0.11 : 52.0;

    if (isLandscape) {
      return Row(
        children: [
          Expanded(child: _buildHomeButton(isDarkMode, isLandscape, buttonHeight)),
          SizedBox(width: size.width * 0.015),
          Expanded(child: _buildRetryButton(isDarkMode, isLandscape, buttonHeight)),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHomeButton(isDarkMode, isLandscape, buttonHeight),
        SizedBox(height: size.height * 0.012),
        _buildRetryButton(isDarkMode, isLandscape, buttonHeight),
      ],
    );
  }

  Widget _buildHomeButton(bool isDarkMode, bool isLandscape, double height) {
    final size = MediaQuery.of(context).size;
    final fontSize = isLandscape ? size.height * 0.04 : 16.5;

    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8F9ABA),
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: const Color(0xFF8F9ABA).withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.home_rounded, size: fontSize * 1.25),
            SizedBox(width: size.width * 0.015),
            Flexible(
              child: Text(
                'Back to Home',
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

  Widget _buildRetryButton(bool isDarkMode, bool isLandscape, double height) {
    final size = MediaQuery.of(context).size;
    final fontSize = isLandscape ? size.height * 0.04 : 16.5;

    return SizedBox(
      height: height,
      child: OutlinedButton(
        onPressed: () => Navigator.pop(context),
        style: OutlinedButton.styleFrom(
          foregroundColor: isDarkMode
              ? const Color(0xFF6C5CE7)
              : const Color(0xFF0984E3),
          side: BorderSide(
            color: isDarkMode
                ? const Color(0xFF6C5CE7)
                : const Color(0xFF0984E3),
            width: 2.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.refresh_rounded, size: fontSize * 1.25),
            SizedBox(width: size.width * 0.015),
            Flexible(
              child: Text(
                'Try Again',
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