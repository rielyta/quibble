import 'package:flutter/material.dart';

class DialogHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final Color? iconBackgroundColor;
  final double iconSize;
  final double titleSize;
  final bool isDarkMode;

  const DialogHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.iconColor,
    this.iconBackgroundColor,
    this.iconSize = 24,
    this.titleSize = 18,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(screenWidth * 0.02),
          decoration: BoxDecoration(
            color: iconBackgroundColor ?? iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: iconSize,
          ),
        ),
        SizedBox(width: screenWidth * 0.03),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w700,
              fontSize: titleSize,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}