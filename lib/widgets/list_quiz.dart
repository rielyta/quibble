import 'package:flutter/material.dart';

class QuizCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const QuizCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final cardHeight = isLandscape
        ? screenHeight * 0.22
        : screenHeight * 0.14;

    final imageSize = isLandscape
        ? screenHeight * 0.15
        : screenWidth * 0.20;

    final titleFontSize = isLandscape
        ? screenHeight * 0.05
        : screenWidth * 0.05;

    final subtitleFontSize = isLandscape
        ? screenHeight * 0.035
        : screenWidth * 0.035;

    final arrowSize = isLandscape
        ? screenHeight * 0.09
        : screenWidth * 0.13;

    final arrowIconSize = isLandscape
        ? screenHeight * 0.045
        : screenWidth * 0.055;

    final horizontalPadding = isLandscape
        ? screenWidth * 0.03
        : screenWidth * 0.04;

    final verticalPadding = isLandscape
        ? screenHeight * 0.03
        : screenHeight * 0.015;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isLandscape ? 24 : 20),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withValues(alpha: 0.4),
              blurRadius: isLandscape ? 15 : 12,
              offset: Offset(0, isLandscape ? 8 : 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              right: isLandscape ? -25 : -20,
              top: isLandscape ? -25 : -20,
              child: Container(
                width: isLandscape ? 100 : 80,
                height: isLandscape ? 100 : 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),
            Positioned(
              left: isLandscape ? -15 : -10,
              bottom: isLandscape ? -15 : -10,
              child: Container(
                width: isLandscape ? 75 : 60,
                height: isLandscape ? 75 : 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Row(
                children: [
                  // Image with border
                  Container(
                    width: imageSize,
                    height: imageSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: isLandscape ? 10 : 8,
                          offset: Offset(0, isLandscape ? 4 : 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(isLandscape ? 4 : 3),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: isLandscape ? screenWidth * 0.03 : screenWidth * 0.04),

                  // Text Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: titleFontSize,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                            letterSpacing: 0.3,
                          ),
                          maxLines: isLandscape ? 1 : 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: isLandscape ? screenHeight * 0.008 : screenHeight * 0.005),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: subtitleFontSize,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w400,
                            height: 1.3,
                            letterSpacing: 0.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: isLandscape ? screenWidth * 0.02 : screenWidth * 0.03),

                  // Arrow Button
                  Container(
                    width: arrowSize,
                    height: arrowSize,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: arrowIconSize,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}