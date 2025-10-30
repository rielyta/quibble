import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth,
      height: screenHeight * 0.11,
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
          ),
          _buildNavItem(
            context: context,
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: 'Home',
            index: 1,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
          ),
          _buildNavItem(
            context: context,
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: 'Profile',
            index: 2,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
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
  }) {
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
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
              alignment: Alignment.topRight,
              children: [
                Icon(
                  isActive ? activeIcon : icon,
                  color: isActive
                      ? const Color(0xFFB65E6A)
                      : Colors.black,
                  size: screenWidth * 0.08,
                ),
                // Dot indicator for active item
                if (isActive)
                  Positioned(
                    top: -5,
                    right: 12,
                    child: Container(
                      width: 8,
                      height: 9,
                      decoration: const BoxDecoration(
                        color: Color(0xFFB65E6A),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: screenHeight * 0.005),
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? const Color(0xFFB65E6A)
                    : Colors.black,
                fontSize: screenWidth * 0.037,
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