import 'package:flutter/material.dart';

class QuizCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const QuizCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final cardHeight = isLandscape ? screenHeight * 0.15 : screenHeight * 0.09;
    final imageSize = isLandscape ? screenHeight * 0.12 : screenWidth * 0.16;
    final fontSize = isLandscape ? screenHeight * 0.048 : screenWidth * 0.042;
    final iconSize = isLandscape ? screenHeight * 0.055 : screenWidth * 0.05;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: cardHeight,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.01,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon/Image
            Container(
              width: imageSize,
              height: imageSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(width: screenWidth * 0.04),

            // Title
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: fontSize,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // Arrow Icon
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: iconSize,
            ),
          ],
        ),
      ),
    );
  }
}