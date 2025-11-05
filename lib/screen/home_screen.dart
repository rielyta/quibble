import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/navigation_bar.dart';
import '../services/quiz_stats_service.dart';
import '../model/quiz_stat.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = 'name';
  QuizStats stats = QuizStats();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadUsername();
    await _loadStats();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? 'name';
    });
  }

  Future<void> _loadStats() async {
    final loadedStats = await QuizStatsService.loadStats();
    setState(() {
      stats = loadedStats;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final averageScore = stats.completedQuizzes > 0
        ? (stats.totalScore / stats.completedQuizzes).round()
        : 0;

    final navBarHeight = isLandscape ? screenHeight * 0.15 : screenHeight * 0.10;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: navBarHeight + 10),
                child: isLandscape
                    ? _buildLandscapeLayout(screenWidth, screenHeight, averageScore)
                    : _buildPortraitLayout(screenWidth, screenHeight, averageScore),
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
    );
  }

  Widget _buildPortraitLayout(double screenWidth, double screenHeight, int averageScore) {
    return Column(
      children: [
        // Decorative circles background with score
        _buildScoreSection(screenWidth, screenHeight, averageScore, false),

        // Profile Card and Stats Container
        Column(
          children: [
            // Profile Card
            Transform.translate(
              offset: Offset(0, -screenHeight * 0.04),
              child: _buildProfileCard(screenWidth, screenHeight, false),
            ),

            // Yellow stats container
            Transform.translate(
              offset: Offset(0, -screenHeight * 0.01),
              child: _buildStatsContainer(screenWidth, screenHeight, false),
            ),
          ],
        ),

        SizedBox(height: screenHeight * 0.02),
      ],
    );
  }

  Widget _buildLandscapeLayout(double screenWidth, double screenHeight, int averageScore) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.02,
        vertical: screenHeight * 0.02,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Score Section
          SizedBox(
            width: screenWidth * 0.35,
            child: _buildScoreSection(screenWidth, screenHeight, averageScore, true),
          ),

          SizedBox(width: screenWidth * 0.02),

          // Right: Stats Section
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildProfileCard(screenWidth, screenHeight, true),
                SizedBox(height: screenHeight * 0.025),
                _buildStatsContainer(screenWidth, screenHeight, true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreSection(double screenWidth, double screenHeight, int averageScore, bool isLandscape) {
    final height = isLandscape ? screenHeight * 0.7 : screenHeight * 0.35;
    final circleSize = isLandscape ? screenHeight * 0.35 : screenWidth * 0.44;
    final gradientCircleSize = isLandscape ? screenHeight * 0.42 : screenWidth * 0.535;

    return SizedBox(
      width: isLandscape ? screenWidth * 0.35 : screenWidth,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Decorative circles
          _buildDecorativeCircles(screenWidth, screenHeight, isLandscape),

          // Gradient background circle
          Positioned(
            left: isLandscape
                ? (screenWidth * 0.35 - gradientCircleSize) / 2
                : screenWidth * 0.235,
            top: isLandscape
                ? (height - gradientCircleSize) / 2
                : screenHeight * 0.06,
            child: Container(
              width: gradientCircleSize,
              height: gradientCircleSize,
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Color(0xFFDB7D8B),
                    Color(0xFFFFFFFF),
                  ],
                  stops: [0.8, 1.0],
                  center: Alignment.center,
                  radius: 0.5,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Main score circle
          Positioned(
            left: isLandscape
                ? (screenWidth * 0.35 - circleSize) / 2
                : screenWidth * 0.28,
            top: isLandscape
                ? (height - circleSize) / 2
                : screenHeight * 0.08,
            child: Container(
              width: circleSize,
              height: circleSize,
              decoration: const BoxDecoration(
                color: Color(0xFFDB7D8B),
                shape: BoxShape.circle,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your Score',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isLandscape ? screenHeight * 0.05 : screenWidth * 0.049,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '$averageScore',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isLandscape ? screenHeight * 0.18 : screenWidth * 0.2,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecorativeCircles(double screenWidth, double screenHeight, bool isLandscape) {
    return Stack(
      children: [
        // Top left circle
        Positioned(
          left: isLandscape ? -screenWidth * 0.02 : -screenWidth * 0.08,
          top: isLandscape ? screenHeight * 0.05 : screenHeight * 0.02,
          child: Container(
            width: isLandscape ? screenHeight * 0.12 : screenWidth * 0.22,
            height: isLandscape ? screenHeight * 0.12 : screenWidth * 0.22,
            decoration: const BoxDecoration(
              color: Color(0xFFD3D7E0),
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Left middle circle
        Positioned(
          left: isLandscape ? -screenWidth * 0.01 : screenWidth * 0.01,
          top: isLandscape ? screenHeight * 0.35 : screenHeight * 0.15,
          child: Container(
            width: isLandscape ? screenHeight * 0.09 : screenWidth * 0.12,
            height: isLandscape ? screenHeight * 0.09 : screenWidth * 0.12,
            decoration: const BoxDecoration(
              color: Color(0xFF8F9ABA),
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Top right circle
        Positioned(
          right: isLandscape ? -screenWidth * 0.01 : screenWidth * 0.04,
          top: isLandscape ? screenHeight * 0.08 : screenHeight * 0.025,
          child: Container(
            width: isLandscape ? screenHeight * 0.08 : screenWidth * 0.11,
            height: isLandscape ? screenHeight * 0.08 : screenWidth * 0.11,
            decoration: const BoxDecoration(
              color: Color(0xFF8F9ABA),
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Right middle circle
        Positioned(
          right: isLandscape ? -screenWidth * 0.02 : -screenWidth * 0.05,
          top: isLandscape ? screenHeight * 0.32 : screenHeight * 0.12,
          child: Container(
            width: isLandscape ? screenHeight * 0.12 : screenWidth * 0.22,
            height: isLandscape ? screenHeight * 0.12 : screenWidth * 0.22,
            decoration: const BoxDecoration(
              color: Color(0xFFD3D7E0),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(double screenWidth, double screenHeight, bool isLandscape) {
    final horizontalPadding = isLandscape ? screenWidth * 0.03 : screenWidth * 0.06;
    final cardPadding = isLandscape ? screenHeight * 0.018 : screenWidth * 0.04;
    final avatarSize = isLandscape ? screenHeight * 0.1 : screenWidth * 0.12;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color(0xFFDB7D8B),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar placeholder
            Container(
              width: avatarSize,
              height: avatarSize,
              decoration: const BoxDecoration(
                color: Color(0xFFDB7D8B),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: isLandscape ? screenHeight * 0.06 : screenWidth * 0.07,
              ),
            ),
            SizedBox(width: isLandscape ? screenWidth * 0.012 : screenWidth * 0.03),
            // Name and progress
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: isLandscape ? screenHeight * 0.038 : screenWidth * 0.042,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: screenHeight * 0.006),
                  // Progress bar
                  Container(
                    height: isLandscape ? screenHeight * 0.02 : screenHeight * 0.018,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: stats.progressWidth,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFB65E6A),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: isLandscape ? screenWidth * 0.01 : screenWidth * 0.02),
            // XP Text
            Text(
              '${stats.totalCorrect * 10} xp',
              style: TextStyle(
                color: Colors.black,
                fontSize: isLandscape ? screenHeight * 0.032 : screenWidth * 0.032,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsContainer(double screenWidth, double screenHeight, bool isLandscape) {
    return Container(
      width: isLandscape ? null : screenWidth,
      margin: EdgeInsets.symmetric(
        horizontal: isLandscape ? screenWidth * 0.03 : 0,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isLandscape ? screenWidth * 0.02 : screenWidth * 0.06,
        vertical: isLandscape ? screenHeight * 0.03 : screenHeight * 0.04,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE19E),
        borderRadius: isLandscape
            ? BorderRadius.circular(24)
            : const BorderRadius.vertical(
          top: Radius.circular(54),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // First Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  label: 'Completion',
                  value: '${stats.completionPercentage}%',
                  valueColor: const Color(0xFFB65E6A),
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  isLandscape: isLandscape,
                ),
              ),
              SizedBox(width: isLandscape ? screenWidth * 0.015 : screenWidth * 0.04),
              Expanded(
                child: _buildStatCard(
                  label: 'Total Question',
                  value: '${stats.totalQuestions}',
                  valueColor: const Color(0xFFB65E6A),
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  isLandscape: isLandscape,
                ),
              ),
            ],
          ),

          SizedBox(height: isLandscape ? screenHeight * 0.015 : screenHeight * 0.02),

          // Second Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  label: 'Correct',
                  value: '${stats.totalCorrect}',
                  valueColor: const Color(0xFF59A855),
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  isLandscape: isLandscape,
                ),
              ),
              SizedBox(width: isLandscape ? screenWidth * 0.015 : screenWidth * 0.04),
              Expanded(
                child: _buildStatCard(
                  label: 'Wrong',
                  value: '${stats.totalWrong}',
                  valueColor: const Color(0xFFF5405B),
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  isLandscape: isLandscape,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required Color valueColor,
    required double screenWidth,
    required double screenHeight,
    required bool isLandscape,
  }) {
    return AspectRatio(
      aspectRatio: isLandscape ? 1.5 : 1.4,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: isLandscape ? screenHeight * 0.015 : screenHeight * 0.012,
          horizontal: screenWidth * 0.01,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: isLandscape ? screenHeight * 0.035 : screenWidth * 0.04,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
            SizedBox(height: screenHeight * 0.002),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  color: valueColor,
                  fontSize: isLandscape ? screenHeight * 0.09 : screenWidth * 0.13,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}