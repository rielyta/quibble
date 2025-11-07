import 'package:flutter/material.dart' hide debugPrint;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../widgets/gradient_bakground.dart';
import '../widgets/navigation_bar.dart';
import '../services/quiz_stats_service.dart';
import '../model/quiz_stat.dart';
import '../util/level_system.dart';
import '../provider/theme_provider.dart';
import '../widgets/user_avatar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = 'name';
  QuizStats stats = QuizStats();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final _ = await Future.wait([
        _loadUsername(),
        _loadStats(),
      ]);

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _loadUsername() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loadedName = prefs.getString('name') ?? 'name';
      if (mounted) {
        setState(() {
          name = loadedName;
        });
      }
    } catch (e) {
      debugPrint('Error loading username: $e');
    }
  }

  Future<void> _loadStats() async {
    try {
      final loadedStats = await QuizStatsService.loadStats();
      if (mounted) {
        setState(() {
          stats = loadedStats;
        });
      }
    } catch (e) {
      debugPrint('Error loading stats: $e');
      if (mounted) {
        setState(() {
          stats = QuizStats();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    final averageScore = stats.completedQuizzes > 0
        ? (stats.totalScore / stats.completedQuizzes).round()
        : 0;

    final navBarHeight = isLandscape ? screenHeight * 0.15 : screenHeight * 0.10;

    return Scaffold(
      body: SafeArea(
            child: GradientBackground(
              stops: const [0.3, 0.5],
          child: Stack(
            children: [
              // Main Content
              isLoading
                  ? Center(
                child: CircularProgressIndicator(
                  color: isDarkMode ? Colors.white : const Color(0xFFEE7C9E),
                ),
              )
                  : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(bottom: navBarHeight + 15),
                  child: isLandscape
                      ? _buildLandscapeLayout(screenWidth, screenHeight, averageScore, isDarkMode)
                      : _buildPortraitLayout(screenWidth, screenHeight, averageScore, isDarkMode),
                ),
              ),
              // Bottom Navigation Bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: CustomNavigationBar(
                  currentIndex: 1,
                  onNavigationComplete: _loadData,
                ),
              ),
            ],
          ),
            ),
      ),
    );
  }

  Widget _buildPortraitLayout(double screenWidth, double screenHeight, int averageScore, bool isDarkMode) {
    return Column(
      children: [
        SizedBox(height: screenHeight * 0.03),

        // Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello,',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : const Color(0xFF5D4037),
                      fontSize: screenWidth * 0.05,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    name,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : const Color(0xFF5D4037),
                      fontSize: screenWidth * 0.07,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              // Avatar
              UserAvatar(size: screenWidth * 0.14)
            ],
          ),
        ),

        SizedBox(height: screenHeight * 0.03),

        // Level Card
        _buildLevelCard(screenWidth, screenHeight, false, isDarkMode),

        SizedBox(height: screenHeight * 0.025),

        // Score Card
        _buildScoreCard(screenWidth, screenHeight, averageScore, false, isDarkMode),

        SizedBox(height: screenHeight * 0.025),

        // Stats Grid
        _buildStatsGrid(screenWidth, screenHeight, false, isDarkMode),

        SizedBox(height: screenHeight * 0.02),
      ],
    );
  }

  Widget _buildLandscapeLayout(double screenWidth, double screenHeight, int averageScore, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.04,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello,',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : const Color(0xFF5D4037),
                            fontSize: screenHeight * 0.05,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          name,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : const Color(0xFF5D4037),
                            fontSize: screenHeight * 0.08,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: screenHeight * 0.14,
                      height: screenHeight * 0.14,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEE7C9E), Color(0xFFF295B0)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFEE7C9E).withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: screenHeight * 0.08,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                _buildLevelCard(screenWidth, screenHeight, true, isDarkMode),
              ],
            ),
          ),
          SizedBox(width: screenWidth * 0.02),
          // Right Column
          Expanded(
            flex: 5,
            child: Column(
              children: [
                _buildScoreCard(screenWidth, screenHeight, averageScore, true, isDarkMode),
                SizedBox(height: screenHeight * 0.02),
                _buildStatsGrid(screenWidth, screenHeight, true, isDarkMode),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCard(double screenWidth, double screenHeight, bool isLandscape, bool isDarkMode) {
    final totalXP = stats.totalXP;
    final currentLevel = LevelSystem.getCurrentLevel(totalXP);
    final nextLevel = LevelSystem.getNextLevel(totalXP);
    final progress = LevelSystem.getProgressToNextLevel(totalXP);
    final xpToNext = LevelSystem.getXPToNextLevel(totalXP);
    final isMaxLevel = nextLevel == null;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isLandscape ? 0 : screenWidth * 0.06,
      ),
      padding: EdgeInsets.all(isLandscape ? screenHeight * 0.04 : screenWidth * 0.05),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(currentLevel.color),
            Color(currentLevel.color).withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Color(currentLevel.color).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Level ${currentLevel.level}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isLandscape ? screenHeight * 0.08 : screenWidth * 0.09,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    currentLevel.title,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: isLandscape ? screenHeight * 0.045 : screenWidth * 0.045,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isLandscape ? screenWidth * 0.02 : screenWidth * 0.03,
                  vertical: isLandscape ? screenHeight * 0.02 : screenHeight * 0.01,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.stars,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$totalXP XP',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isLandscape ? screenHeight * 0.04 : screenWidth * 0.04,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: isLandscape ? screenHeight * 0.02 : screenHeight * 0.015),

          // Progress Bar
          Container(
            height: isLandscape ? screenHeight * 0.025 : 8,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ),

          SizedBox(height: isLandscape ? screenHeight * 0.015 : screenHeight * 0.012),

          // Progress Text
          Text(
            isMaxLevel
                ? '🎉 Max Level Reached!'
                : 'Next: ${nextLevel.title} • $xpToNext XP to go',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: isLandscape ? screenHeight * 0.035 : screenWidth * 0.032,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(double screenWidth, double screenHeight, int averageScore, bool isLandscape, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isLandscape ? 0 : screenWidth * 0.06,
      ),
      padding: EdgeInsets.all(isLandscape ? screenHeight * 0.04 : screenWidth * 0.05),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.3 : 0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildScoreStat(
            icon: Icons.trending_up,
            label: 'Avg Score',
            value: '$averageScore%',
            color: const Color(0xFFEE7C9E),
            isLandscape: isLandscape,
            isDarkMode: isDarkMode,
          ),
          Container(
            width: 1,
            height: isLandscape ? screenHeight * 0.08 : 50,
            color: isDarkMode
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.1),
          ),
          _buildScoreStat(
            icon: Icons.quiz,
            label: 'Completed',
            value: '${stats.completedQuizzes}',
            color: const Color(0xFF8F9ABA),
            isLandscape: isLandscape,
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildScoreStat({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isLandscape,
    required bool isDarkMode,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: isLandscape ? screenHeight * 0.06 : screenWidth * 0.08,
        ),
        SizedBox(height: isLandscape ? screenHeight * 0.01 : 8),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: isLandscape ? screenHeight * 0.065 : screenWidth * 0.08,
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : const Color(0xFF8D6E63),
            fontSize: isLandscape ? screenHeight * 0.035 : screenWidth * 0.032,
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(double screenWidth, double screenHeight, bool isLandscape, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isLandscape ? 0 : screenWidth * 0.06,
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: isLandscape ? screenHeight * 0.02 : screenWidth * 0.035,
        crossAxisSpacing: isLandscape ? screenHeight * 0.02 : screenWidth * 0.035,
        childAspectRatio: isLandscape ? 1.4 : 1.15,
        children: [
          _buildStatItem(
            icon: Icons.check_circle,
            label: 'Correct',
            value: '${stats.totalCorrect}',
            color: const Color(0xFF59A855),
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            isLandscape: isLandscape,
            isDarkMode: isDarkMode,
          ),
          _buildStatItem(
            icon: Icons.cancel,
            label: 'Wrong',
            value: '${stats.totalWrong}',
            color: const Color(0xFFF5405B),
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            isLandscape: isLandscape,
            isDarkMode: isDarkMode,
          ),
          _buildStatItem(
            icon: Icons.psychology,
            label: 'Total XP',
            value: '${stats.totalXP}',
            color: const Color(0xFFFFB74D),
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            isLandscape: isLandscape,
            isDarkMode: isDarkMode,
          ),
          _buildStatItem(
            icon: Icons.question_answer,
            label: 'Questions',
            value: '${stats.totalQuestions}',
            color: const Color(0xFF8F9ABA),
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            isLandscape: isLandscape,
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required double screenWidth,
    required double screenHeight,
    required bool isLandscape,
    required bool isDarkMode,
  }) {
    return Container(
      padding: EdgeInsets.all(isLandscape ? screenHeight * 0.02 : screenWidth * 0.035),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.3 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(isLandscape ? screenHeight * 0.015 : screenWidth * 0.02),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: isLandscape ? screenHeight * 0.055 : screenWidth * 0.07,
            ),
          ),
          SizedBox(height: isLandscape ? screenHeight * 0.01 : screenHeight * 0.008),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: isLandscape ? screenHeight * 0.07 : screenWidth * 0.10,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w800,
                height: 1.0,
              ),
            ),
          ),
          SizedBox(height: isLandscape ? screenHeight * 0.004 : screenHeight * 0.003),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : const Color(0xFF5D4037),
                fontSize: isLandscape ? screenHeight * 0.03 : screenWidth * 0.031,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}