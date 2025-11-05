import 'package:flutter/material.dart';
import 'package:quibble/screen/home_screen.dart';
import 'package:quibble/screen/quiz/quiz_list_screen.dart';
import 'package:quibble/screen/profile_screen.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final VoidCallback? onNavigationComplete;

  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    this.onNavigationComplete,
  });

  void _handleNavigation(BuildContext context, int index) {
    if (index == currentIndex) return;

    // Callback sebelum navigasi (untuk refresh data jika diperlukan)
    onNavigationComplete?.call();

    Widget destination;
    switch (index) {
      case 0:
        destination = const QuizListScreen();
        break;
      case 1:
        destination = const HomeScreen();
        break;
      case 2:
        destination = const ProfileScreen();
        break;
      default:
        return;
    }

    // Gunakan pushReplacement untuk halaman utama agar tidak menumpuk
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    // FIXED: Tinggi konsisten untuk semua orientasi
    final navHeight = isLandscape ? screenHeight * 0.15 : screenHeight * 0.10;

    return Container(
      width: screenWidth,
      height: navHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(14),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            context: context,
            icon: Icons.quiz_outlined,
            activeIcon: Icons.quiz,
            label: 'Quiz',
            index: 0,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            isLandscape: isLandscape,
          ),
          _buildNavItem(
            context: context,
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: 'Home',
            index: 1,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            isLandscape: isLandscape,
          ),
          _buildNavItem(
            context: context,
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: 'Profile',
            index: 2,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            isLandscape: isLandscape,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required double screenWidth,
    required double screenHeight,
    required bool isLandscape,
  }) {
    final isActive = currentIndex == index;
    final iconSize = isLandscape ? screenHeight * 0.065 : screenWidth * 0.07;
    final fontSize = isLandscape ? screenHeight * 0.035 : screenWidth * 0.032;

    return GestureDetector(
      onTap: () => _handleNavigation(context, index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.01,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isActive ? activeIcon : icon,
                  color: isActive ? const Color(0xFFB65E6A) : Colors.black,
                  size: iconSize,
                ),
                // Dot indicator
                if (isActive)
                  Positioned(
                    top: -8,
                    right: 8,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFFB65E6A),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFB65E6A).withValues(alpha: 0.4),
                            blurRadius: 4,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: screenHeight * 0.004),
            Text(
              label,
              style: TextStyle(
                color: isActive ? const Color(0xFFB65E6A) : Colors.black,
                fontSize: fontSize,
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