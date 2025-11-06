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
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFF8E7),
                Color(0xFFFFE19E),
              ],
              stops: [0.3, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Main Content
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(bottom: navBarHeight + 15),
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
      ),
    );
  }

  Widget _buildPortraitLayout(double screenWidth, double screenHeight, int averageScore) {
    return Column(
      children: [
        SizedBox(height: screenHeight * 0.03),

        // Header with greeting
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
                      color: const Color(0xFF5D4037),
                      fontSize: screenWidth * 0.05,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    name,
                    style: TextStyle(
                      color: const Color(0xFF5D4037),
                      fontSize: screenWidth * 0.07,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              // Avatar
              Container(
                width: screenWidth * 0.14,
                height: screenWidth * 0.14,
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
                  size: screenWidth * 0.08,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: screenHeight * 0.03),

        // Score Card with modern design
        _buildScoreCard(screenWidth, screenHeight, averageScore, false),

        SizedBox(height: screenHeight * 0.025),

        // XP Progress Card
        _buildXPCard(screenWidth, screenHeight, false),

        SizedBox(height: screenHeight * 0.025),

        // Stats Grid
        _buildStatsGrid(screenWidth, screenHeight, false),

        SizedBox(height: screenHeight * 0.02),
      ],
    );
  }

  Widget _buildLandscapeLayout(double screenWidth, double screenHeight, int averageScore) {
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
                            color: const Color(0xFF5D4037),
                            fontSize: screenHeight * 0.055,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          name,
                          style: TextStyle(
                            color: const Color(0xFF5D4037),
                            fontSize: screenHeight * 0.08,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    // Avatar
                    Container(
                      width: screenHeight * 0.15,
                      height: screenHeight * 0.15,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEE7C9E), Color(0xFFF295B0)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFEE7C9E).withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: screenHeight * 0.09,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.04),

                // XP Card
                _buildXPCard(screenWidth, screenHeight, true),
              ],
            ),
          ),

          SizedBox(width: screenWidth * 0.03),

          // Right Column
          Expanded(
            flex: 5,
            child: Column(
              children: [
                _buildScoreCard(screenWidth, screenHeight, averageScore, true),
                SizedBox(height: screenHeight * 0.03),
                _buildStatsGrid(screenWidth, screenHeight, true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(double screenWidth, double screenHeight, int averageScore, bool isLandscape) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isLandscape ? 0 : screenWidth * 0.06,
      ),
      padding: EdgeInsets.all(isLandscape ? screenHeight * 0.04 : screenWidth * 0.05),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF8F9ABA),
            Color(0xFFA3ADCA),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8F9ABA).withValues(alpha: 0.4),
            blurRadius: 15,
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
                'Average Score',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.95),
                  fontSize: isLandscape ? screenHeight * 0.045 : screenWidth * 0.042,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isLandscape ? screenWidth * 0.015 : screenWidth * 0.025,
                  vertical: isLandscape ? screenHeight * 0.01 : screenHeight * 0.008,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.star,
                  color: Colors.white,
                  size: isLandscape ? screenHeight * 0.045 : screenWidth * 0.05,
                ),
              ),
            ],
          ),
          SizedBox(height: isLandscape ? screenHeight * 0.025 : screenHeight * 0.015),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$averageScore',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isLandscape ? screenHeight * 0.2 : screenWidth * 0.22,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: isLandscape ? screenHeight * 0.02 : screenWidth * 0.02),
                child: Text(
                  ' pts',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: isLandscape ? screenHeight * 0.055 : screenWidth * 0.065,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isLandscape ? screenHeight * 0.015 : screenHeight * 0.01),
          Text(
            '${stats.completedQuizzes} Quiz${stats.completedQuizzes != 1 ? 'zes' : ''} Completed',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: isLandscape ? screenHeight * 0.038 : screenWidth * 0.035,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildXPCard(double screenWidth, double screenHeight, bool isLandscape) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isLandscape ? 0 : screenWidth * 0.06,
      ),
      padding: EdgeInsets.all(isLandscape ? screenHeight * 0.03 : screenWidth * 0.045),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Experience Points',
                style: TextStyle(
                  color: const Color(0xFF5D4037),
                  fontSize: isLandscape ? screenHeight * 0.042 : screenWidth * 0.04,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isLandscape ? screenWidth * 0.015 : screenWidth * 0.025,
                  vertical: isLandscape ? screenHeight * 0.008 : screenHeight * 0.006,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEE7C9E), Color(0xFFF295B0)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${stats.totalCorrect * 10} XP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isLandscape ? screenHeight * 0.035 : screenWidth * 0.035,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isLandscape ? screenHeight * 0.02 : screenHeight * 0.015),
          Container(
            height: isLandscape ? screenHeight * 0.03 : screenHeight * 0.022,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: stats.progressWidth,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFEE7C9E)),
              ),
            ),
          ),
          SizedBox(height: isLandscape ? screenHeight * 0.012 : screenHeight * 0.008),
          Text(
            '${(stats.progressWidth * 100).toInt()}% Complete',
            style: TextStyle(
              color: const Color(0xFF8D6E63),
              fontSize: isLandscape ? screenHeight * 0.032 : screenWidth * 0.032,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(double screenWidth, double screenHeight, bool isLandscape) {
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
          ),
          _buildStatItem(
            icon: Icons.cancel,
            label: 'Wrong',
            value: '${stats.totalWrong}',
            color: const Color(0xFFF5405B),
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            isLandscape: isLandscape,
          ),
          _buildStatItem(
            icon: Icons.quiz,
            label: 'Total Questions',
            value: '${stats.totalQuestions}',
            color: const Color(0xFF8F9ABA),
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            isLandscape: isLandscape,
          ),
          _buildStatItem(
            icon: Icons.percent,
            label: 'Completion',
            value: '${stats.completionPercentage}%',
            color: const Color(0xFFFFB74D),
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            isLandscape: isLandscape,
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
  }) {
    return Container(
      padding: EdgeInsets.all(isLandscape ? screenHeight * 0.02 : screenWidth * 0.035),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
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
                color: const Color(0xFF5D4037),
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