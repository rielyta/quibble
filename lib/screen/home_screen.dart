import 'package:flutter/material.dart';
import 'package:quibble/screen/profile_screen.dart';
import 'package:quibble/screen/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/navigation_bar.dart';
import '../services/quiz_stats_service.dart';
import '../model/quiz_stat.dart';
import 'quiz/quiz_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;
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

  void _onNavTap(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QuizListScreen()),
        ).then((_) => _loadStats());
        break;
      case 1:
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        ).then((_) => _loadData()); // Refresh data setelah kembali
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final averageScore = stats.completedQuizzes > 0
        ? (stats.totalScore / stats.completedQuizzes).round()
        : 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            SingleChildScrollView(
              child: Column(
                children: [
                  // Decorative circles background
                  SizedBox(
                    width: screenWidth,
                    height: screenHeight * 0.35,
                    child: Stack(
                      children: [
                        // Top left circle
                        Positioned(
                          left: -screenWidth * 0.08,
                          top: screenHeight * 0.02,
                          child: Container(
                            width: screenWidth * 0.22,
                            height: screenWidth * 0.22,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD3D7E0),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        // Left middle circle
                        Positioned(
                          left: screenWidth * 0.01,
                          top: screenHeight * 0.15,
                          child: Container(
                            width: screenWidth * 0.12,
                            height: screenWidth * 0.12,
                            decoration: const BoxDecoration(
                              color: Color(0xFF8F9ABA),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        // Top right circle
                        Positioned(
                          right: screenWidth * 0.04,
                          top: screenHeight * 0.025,
                          child: Container(
                            width: screenWidth * 0.11,
                            height: screenWidth * 0.11,
                            decoration: const BoxDecoration(
                              color: Color(0xFF8F9ABA),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        // Right middle circle
                        Positioned(
                          right: -screenWidth * 0.05,
                          top: screenHeight * 0.12,
                          child: Container(
                            width: screenWidth * 0.22,
                            height: screenWidth * 0.22,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD3D7E0),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),

                        // Gradient background circle
                        Positioned(
                          left: screenWidth * 0.235,
                          top: screenHeight * 0.06,
                          child: Container(
                            width: screenWidth * 0.535,
                            height: screenWidth * 0.535,
                            decoration: BoxDecoration(
                              gradient: const RadialGradient(
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
                          left: screenWidth * 0.28,
                          top: screenHeight * 0.08,
                          child: Container(
                            width: screenWidth * 0.44,
                            height: screenWidth * 0.44,
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
                                    fontSize: screenWidth * 0.049,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '$averageScore',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.2,
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
                  ),

                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Yellow stats container
                      Positioned(
                        top: screenHeight * 0.07,
                        left: 0,
                        right: 0,
                        child: Container(
                          width: screenWidth,
                          padding: EdgeInsets.only(
                            left: screenWidth * 0.08,
                            right: screenWidth * 0.08,
                            top: screenHeight * 0.08,
                            bottom: screenHeight * 0.03,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFE19E),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(54),
                            ),
                          ),
                          child: Column(
                            children: [
                              // First Row - Completion & Total Questions
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildStatCard(
                                    label: 'Completion',
                                    value: '${stats.completionPercentage}%',
                                    valueColor: const Color(0xFFB65E6A),
                                    screenWidth: screenWidth,
                                    screenHeight: screenHeight,
                                  ),
                                  _buildStatCard(
                                    label: 'Total Question',
                                    value: '${stats.totalQuestions}',
                                    valueColor: const Color(0xFFB65E6A),
                                    screenWidth: screenWidth,
                                    screenHeight: screenHeight,
                                  ),
                                ],
                              ),

                              SizedBox(height: screenHeight * 0.02),

                              // Second Row - Correct & Wrong
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildStatCard(
                                    label: 'Correct',
                                    value: '${stats.totalCorrect}',
                                    valueColor: const Color(0xFF59A855),
                                    screenWidth: screenWidth,
                                    screenHeight: screenHeight,
                                  ),
                                  _buildStatCard(
                                    label: 'Wrong',
                                    value: '${stats.totalWrong}',
                                    valueColor: const Color(0xFFF5405B),
                                    screenWidth: screenWidth,
                                    screenHeight: screenHeight,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Profile Card
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.06,
                          vertical: screenHeight * 0.001,
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(screenWidth * 0.06),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xFFDB7D8B),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 4,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Avatar placeholder
                              Container(
                                width: screenWidth * 0.13,
                                height: screenWidth * 0.13,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFDB7D8B),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: screenWidth * 0.08,
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.03),
                              // Name and progress
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: screenWidth * 0.038,
                                        fontFamily: 'SF Pro',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.008),
                                    // Progress bar - based on completed quizzes
                                    Container(
                                      height: screenHeight * 0.018,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.black, width: 1),
                                        borderRadius: BorderRadius.circular(11),
                                      ),
                                      child: FractionallySizedBox(
                                        alignment: Alignment.centerLeft,
                                        widthFactor: stats.progressWidth,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFB65E6A),
                                            borderRadius: BorderRadius.circular(11),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // XP Text - based on total correct answers
                              Text(
                                '${stats.totalCorrect * 10} xp',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenWidth * 0.028,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Bottom padding untuk navigation bar
                  SizedBox(height: screenHeight * 0.5),
                ],
              ),
            ),
            // Bottom Navigation Bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 1,
              child: CustomNavigationBar(
                currentIndex: _currentIndex,
                onTap: _onNavTap,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required Color valueColor,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Container(
      width: screenWidth * 0.37,
      height: screenHeight * 0.12,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: screenWidth * 0.036,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: screenHeight * 0.005),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: screenWidth * 0.115,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
