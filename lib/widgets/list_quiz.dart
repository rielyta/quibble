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
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    final baseSize = size.shortestSide;

    final cardHeight = isLandscape ? baseSize * 0.22 : baseSize * 0.28;
    final imageSize = baseSize * 0.20;
    final titleFontSize = baseSize * 0.05;
    final subtitleFontSize = baseSize * 0.035;
    final arrowSize = baseSize * 0.13;
    final arrowIconSize = baseSize * 0.055;
    final horizontalPadding = baseSize * 0.04;
    final verticalPadding = baseSize * 0.03;
    final spacingSmall = baseSize * 0.01;
    final spacingMedium = baseSize * 0.03;
    final borderRadius = baseSize * 0.05;
    final decorCircleLarge = baseSize * 0.20;
    final decorCircleSmall = baseSize * 0.15;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withValues(alpha: 0.4),
              blurRadius: baseSize * 0.03,
              offset: Offset(0, baseSize * 0.015),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              right: -decorCircleLarge * 0.25,
              top: -decorCircleLarge * 0.25,
              child: Container(
                width: decorCircleLarge,
                height: decorCircleLarge,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),
            Positioned(
              left: -decorCircleSmall * 0.15,
              bottom: -decorCircleSmall * 0.15,
              child: Container(
                width: decorCircleSmall,
                height: decorCircleSmall,
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
                          blurRadius: baseSize * 0.02,
                          offset: Offset(0, baseSize * 0.008),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(baseSize * 0.008),
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

                  SizedBox(width: spacingMedium),

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
                        SizedBox(height: spacingSmall),
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

                  SizedBox(width: spacingMedium),

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