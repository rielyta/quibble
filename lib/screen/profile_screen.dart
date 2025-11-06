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
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5405B).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout,
                  color: Color(0xFFF5405B),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Exit',
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to logout and reset all data?',
            style: TextStyle(
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Color(0xFF5D4037),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF8F9ABA),
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
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
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5405B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Exit',
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
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
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: navBarHeight + 15),
                        child: isLandscape
                            ? _buildLandscapeLayout(screenWidth, screenHeight)
                            : _buildPortraitLayout(screenWidth, screenHeight),
                      ),
                    ),
                  ),
                ],
              ),
              // Bottom Navigation Bar
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
      ),
    );
  }

  Widget _buildPortraitLayout(double screenWidth, double screenHeight) {
    return Column(
      children: [
        SizedBox(height: screenHeight * 0.05),

        // Avatar with decorative elements
        _buildAvatarSection(screenWidth, screenHeight, false),

        SizedBox(height: screenHeight * 0.04),

        // Profile Info Card
        _buildProfileCard(screenWidth, screenHeight, false),

        SizedBox(height: screenHeight * 0.03),

        // Quick Info Cards
        _buildQuickInfoCards(screenWidth, screenHeight, false),

        SizedBox(height: screenHeight * 0.03),

        // Logout Button
        _buildLogoutButton(screenWidth, screenHeight, false),

        SizedBox(height: screenHeight * 0.02),
      ],
    );
  }

  Widget _buildLandscapeLayout(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.08,
        vertical: screenHeight * 0.05,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Avatar Section
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAvatarSection(screenWidth, screenHeight, true),
                SizedBox(height: screenHeight * 0.04),
                _buildLogoutButton(screenWidth, screenHeight, true),
              ],
            ),
          ),

          SizedBox(width: screenWidth * 0.04),

          // Right: Info Cards
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildProfileCard(screenWidth, screenHeight, true),
                SizedBox(height: screenHeight * 0.03),
                _buildQuickInfoCards(screenWidth, screenHeight, true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection(double screenWidth, double screenHeight, bool isLandscape) {
    final avatarSize = isLandscape ? screenHeight * 0.35 : screenWidth * 0.40;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Decorative circles
        Container(
          width: avatarSize * 1.3,
          height: avatarSize * 1.3,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFEE7C9E).withValues(alpha: 0.1),
          ),
        ),
        Container(
          width: avatarSize * 1.15,
          height: avatarSize * 1.15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFEE7C9E).withValues(alpha: 0.15),
          ),
        ),

        // Main Avatar
        Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFEE7C9E),
                Color(0xFFF295B0),
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFEE7C9E).withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.person,
            size: avatarSize * 0.6,
            color: Colors.white,
          ),
        ),

        // Edit icon badge
        Positioned(
          bottom: isLandscape ? 5 : 10,
          right: isLandscape ? 5 : 10,
          child: Container(
            padding: EdgeInsets.all(isLandscape ? 8 : 10),
            decoration: BoxDecoration(
              color: const Color(0xFF8F9ABA),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.edit,
              size: isLandscape ? screenHeight * 0.04 : screenWidth * 0.045,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(double screenWidth, double screenHeight, bool isLandscape) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isLandscape ? 0 : screenWidth * 0.06,
      ),
      padding: EdgeInsets.all(isLandscape ? screenHeight * 0.04 : screenWidth * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Username',
                style: TextStyle(
                  color: const Color(0xFF8D6E63),
                  fontSize: isLandscape ? screenHeight * 0.04 : screenWidth * 0.038,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                Icons.person_outline,
                color: const Color(0xFF8F9ABA),
                size: isLandscape ? screenHeight * 0.05 : screenWidth * 0.055,
              ),
            ],
          ),
          SizedBox(height: isLandscape ? screenHeight * 0.02 : screenHeight * 0.015),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: isLandscape ? screenWidth * 0.03 : screenWidth * 0.04,
              vertical: isLandscape ? screenHeight * 0.03 : screenHeight * 0.018,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              name,
              style: TextStyle(
                color: const Color(0xFF5D4037),
                fontSize: isLandscape ? screenHeight * 0.055 : screenWidth * 0.055,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfoCards(double screenWidth, double screenHeight, bool isLandscape) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isLandscape ? 0 : screenWidth * 0.06,
      ),
      child: Row(
        children: [
          SizedBox(width: isLandscape ? screenWidth * 0.02 : screenWidth * 0.035),
        ],
      ),
    );
  }


  Widget _buildLogoutButton(double screenWidth, double screenHeight, bool isLandscape) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isLandscape ? 0 : screenWidth * 0.06,
      ),
      width: isLandscape ? null : double.infinity,
      child: ElevatedButton(
        onPressed: _showExitDialog,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF5405B),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: isLandscape ? screenWidth * 0.05 : screenWidth * 0.08,
            vertical: isLandscape ? screenHeight * 0.035 : screenHeight * 0.02,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4,
          shadowColor: const Color(0xFFF5405B).withValues(alpha: 0.4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: isLandscape ? MainAxisSize.min : MainAxisSize.max,
          children: [
            Icon(
              Icons.logout,
              size: isLandscape ? screenHeight * 0.05 : screenWidth * 0.055,
            ),
            SizedBox(width: isLandscape ? screenWidth * 0.015 : screenWidth * 0.03),
            Text(
              'Logout',
              style: TextStyle(
                fontSize: isLandscape ? screenHeight * 0.05 : screenWidth * 0.05,
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