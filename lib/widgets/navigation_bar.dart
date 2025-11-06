import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screen/home_screen.dart';
import '../screen/quiz/quiz_list_screen.dart';
import '../screen/profile_screen.dart';
import '../provider/theme_provider.dart';

class CustomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final VoidCallback? onNavigationComplete;

  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    this.onNavigationComplete,
  });

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  bool _isNavigating = false;

  void _handleNavigation(BuildContext context, int index) async {
    // Prevent navigation if already on this screen
    if (index == widget.currentIndex) return;

    // Prevent multiple taps
    if (_isNavigating) return;
    setState(() => _isNavigating = true);

    // Call completion callback
    widget.onNavigationComplete?.call();

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
        setState(() => _isNavigating = false);
        return;
    }

    if (!context.mounted) return;

    await Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => destination,
        transitionsBuilder: (context, animation, _, child) {
          return FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        reverseTransitionDuration: const Duration(milliseconds: 150),
      ),
    );

    if (mounted) {
      setState(() => _isNavigating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    final navHeight = isLandscape ? screenHeight * 0.15 : screenHeight * 0.10;

    return Container(
      width: screenWidth,
      height: navHeight,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(14),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.4 : 0.1),
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
            isDarkMode: isDarkMode,
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
            isDarkMode: isDarkMode,
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
            isDarkMode: isDarkMode,
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
    required bool isDarkMode,
  }) {
    final isActive = widget.currentIndex == index;
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
                  color: isActive
                      ? const Color(0xFFB65E6A)
                      : (isDarkMode ? Colors.white70 : Colors.black),
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
                          color: isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
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
                color: isActive
                    ? const Color(0xFFB65E6A)
                    : (isDarkMode ? Colors.white70 : Colors.black),
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
