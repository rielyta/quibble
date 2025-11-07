import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/gradient_bakground.dart';
import '../widgets/navigation_bar.dart';
import '../services/quiz_stats_service.dart';
import '../provider/theme_provider.dart';
import '../widgets/user_avatar.dart';
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
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Exit',
        message: 'Are you sure you want to logout and reset all data?',
        icon: Icons.logout,
        iconColor: const Color(0xFFF5405B),
        confirmText: 'Exit',
        cancelText: 'Cancel',
        confirmButtonColor: const Color(0xFFF5405B),
        isDarkMode: isDarkMode,
        onConfirm: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          await QuizStatsService.resetStats();

          if (context.mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
            );
          }
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final navBarHeight = isLandscape ? screenHeight * 0.15 : screenHeight * 0.10;

    return Scaffold(
        body: SafeArea(
          child: GradientBackground(
            stops: const [0.3, 0.5],
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
                              ? _buildLandscapeLayout(screenWidth, screenHeight, isDarkMode)
                              : _buildPortraitLayout(screenWidth, screenHeight, isDarkMode),
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
        )
    );
  }

  Widget _buildPortraitLayout(double screenWidth, double screenHeight, bool isDarkMode) {
    return Column(
      children: [
        SizedBox(height: screenHeight * 0.05),

        // Avatar with decorative elements
        _buildAvatarSection(screenWidth, screenHeight, false, isDarkMode),

        SizedBox(height: screenHeight * 0.04),

        // Profile Info Card
        _buildProfileCard(screenWidth, screenHeight, false, isDarkMode),

        SizedBox(height: screenHeight * 0.03),

        // Dark Mode Toggle
        _buildDarkModeToggle(screenWidth, screenHeight, false, isDarkMode),

        SizedBox(height: screenHeight * 0.03),

        // Logout Button
        _buildLogoutButton(screenWidth, screenHeight, false),

        SizedBox(height: screenHeight * 0.02),
      ],
    );
  }

  Widget _buildLandscapeLayout(double screenWidth, double screenHeight, bool isDarkMode) {
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
                _buildAvatarSection(screenWidth, screenHeight, true, isDarkMode),
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
                _buildProfileCard(screenWidth, screenHeight, true, isDarkMode),
                SizedBox(height: screenHeight * 0.03),
                _buildDarkModeToggle(screenWidth, screenHeight, true, isDarkMode),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection(double screenWidth, double screenHeight, bool isLandscape, bool isDarkMode) {
    final avatarSize = isLandscape ? screenHeight * 0.35 : screenWidth * 0.40;

    return UserAvatar(
      size: avatarSize,
      decorativeCircleSizes: [
        avatarSize * 1.3,
        avatarSize * 1.15,
      ],
      isDarkMode: isDarkMode,
    );
  }


  Widget _buildProfileCard(double screenWidth, double screenHeight, bool isLandscape, bool isDarkMode) {
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
                  color: isDarkMode ? Colors.white70 : const Color(0xFF8D6E63),
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
              color: isDarkMode ? const Color(0xFF3D3D3D) : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              name,
              style: TextStyle(
                color: isDarkMode ? Colors.white : const Color(0xFF5D4037),
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

  Widget _buildDarkModeToggle(double screenWidth, double screenHeight, bool isLandscape, bool isDarkMode) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

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
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: isDarkMode ? const Color(0xFFFFB74D) : const Color(0xFF8F9ABA),
                size: isLandscape ? screenHeight * 0.05 : screenWidth * 0.055,
              ),
              SizedBox(width: isLandscape ? screenWidth * 0.02 : screenWidth * 0.03),
              Text(
                'Dark Mode',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : const Color(0xFF5D4037),
                  fontSize: isLandscape ? screenHeight * 0.045 : screenWidth * 0.045,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Switch(
            value: isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
            activeThumbColor: const Color(0xFFEE7C9E),
            activeTrackColor: const Color(0xFFEE7C9E).withValues(alpha: 0.5),
            inactiveThumbColor: const Color(0xFF8F9ABA),
            inactiveTrackColor: const Color(0xFF8F9ABA).withValues(alpha: 0.3),
          ),
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