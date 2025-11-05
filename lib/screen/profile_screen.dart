import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/navigation_bar.dart';
import '../services/quiz_stats_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = 'Name';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? 'Name';
    });
  }

  Future<void> _showExitDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Exit',
            style: TextStyle(
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout and reset all data?',
            style: TextStyle(
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF8F9ABA),
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                await QuizStatsService.resetStats();

                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const EnterScreen()),
                        (route) => false,
                  );
                }
              },
              child: const Text(
                'Exit',
                style: TextStyle(
                  color: Color(0xFFF5405B),
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final navBarHeight = isLandscape ? screenHeight * 0.15 : screenHeight * 0.10;
    final avatarSize = isLandscape ? screenHeight * 0.25 : screenWidth * 0.35;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: navBarHeight + 10),
                child: Column(
                  children: [
                    SizedBox(height: isLandscape ? screenHeight * 0.08 : screenHeight * 0.05),

                    Container(
                      width: avatarSize,
                      height: avatarSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFDB7D8B),
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.person,
                        size: isLandscape ? screenHeight * 0.15 : screenWidth * 0.22,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: isLandscape ? screenHeight * 0.05 : screenHeight * 0.03),

                    // Yellow Container with content
                    Container(
                      width: screenWidth,
                      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.001),
                      padding: EdgeInsets.symmetric(
                        horizontal: isLandscape ? screenWidth * 0.15 : screenWidth * 0.1,
                        vertical: isLandscape ? screenHeight * 0.08 : screenHeight * 0.05,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFE19E),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(54),
                          topRight: Radius.circular(54),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Name Container
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: isLandscape ? screenHeight * 0.025 : screenHeight * 0.015,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Text(
                              name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: isLandscape ? screenHeight * 0.055 : screenWidth * 0.056,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          SizedBox(height: isLandscape ? screenHeight * 0.15 : screenHeight * 0.35),

                          // Exit Button
                          SizedBox(
                            width: isLandscape ? screenWidth * 0.35 : screenWidth * 0.77,
                            height: isLandscape ? screenHeight * 0.1 : screenHeight * 0.05,
                            child: ElevatedButton(
                              onPressed: _showExitDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF5405B),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 2,
                              ),
                              child: Text(
                                'Exit',
                                style: TextStyle(
                                  fontSize: isLandscape ? screenHeight * 0.055 : screenWidth * 0.056,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Navigation Bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: const CustomNavigationBar(
                currentIndex: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}