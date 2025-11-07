import 'package:flutter/material.dart';
import '../util/level_system.dart';

class LevelUpDialog extends StatefulWidget {
  final LevelData newLevel;
  final VoidCallback onContinue;

  const LevelUpDialog({
    super.key,
    required this.newLevel,
    required this.onContinue,
  });

  @override
  State<LevelUpDialog> createState() => _LevelUpDialogState();
}

class _LevelUpDialogState extends State<LevelUpDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            );
          },
          child: _DialogContent(
            newLevel: widget.newLevel,
            rotateAnimation: _rotateAnimation,
            onContinue: widget.onContinue,
          ),
        ),
      ),
    );
  }
}

class _DialogContent extends StatelessWidget {
  final LevelData newLevel;
  final Animation<double> rotateAnimation;
  final VoidCallback onContinue;

  const _DialogContent({
    required this.newLevel,
    required this.rotateAnimation,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final baseSize = MediaQuery.of(context).size.shortestSide;

    final dialogWidth = baseSize * 0.85;
    final padding = baseSize * 0.06;
    final borderRadius = baseSize * 0.08;
    final iconSize = baseSize * 0.15;
    final titleFontSize = baseSize * 0.08;
    final levelFontSize = baseSize * 0.07;
    final subtitleFontSize = baseSize * 0.06;
    final messageFontSize = baseSize * 0.04;
    final levelPaddingH = baseSize * 0.06;
    final levelPaddingV = baseSize * 0.03;
    final levelBorderRadius = baseSize * 0.05;
    final dividerWidth = baseSize * 0.25;
    final buttonPaddingH = baseSize * 0.12;
    final buttonPaddingV = baseSize * 0.04;
    final buttonBorderRadius = baseSize * 0.04;
    final buttonFontSize = baseSize * 0.045;
    final spacingSmall = baseSize * 0.02;
    final spacingMedium = baseSize * 0.04;
    final spacingLarge = baseSize * 0.06;

    return Container(
      width: dialogWidth,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(newLevel.color),
            Color(newLevel.color).withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Color(newLevel.color).withValues(alpha: 0.5),
            blurRadius: baseSize * 0.075,
            spreadRadius: baseSize * 0.0125,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Sparkle icon with rotation
          AnimatedBuilder(
            animation: rotateAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: rotateAnimation.value * 6.28,
                child: child,
              );
            },
            child: Icon(
              Icons.auto_awesome,
              size: iconSize,
              color: Colors.white,
            ),
          ),

          SizedBox(height: spacingMedium),

          // Level Up Text
          Text(
            'LEVEL UP!',
            style: TextStyle(
              color: Colors.white,
              fontSize: titleFontSize,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),

          SizedBox(height: spacingSmall),

          // Level number
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: levelPaddingH,
              vertical: levelPaddingV,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(levelBorderRadius),
            ),
            child: Text(
              'Level ${newLevel.level}',
              style: TextStyle(
                color: Colors.white,
                fontSize: levelFontSize,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          SizedBox(height: spacingMedium),

          // Title
          Text(
            newLevel.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: subtitleFontSize,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),

          SizedBox(height: spacingLarge),

          // Divider
          Container(
            height: 2,
            width: dividerWidth,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(1),
            ),
          ),

          SizedBox(height: spacingMedium),

          // Motivational message
          Text(
            _getMotivationalMessage(newLevel.level),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: messageFontSize,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),

          SizedBox(height: spacingLarge),

          // Continue button
          ElevatedButton(
            onPressed: () {
              onContinue();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Color(newLevel.color),
              padding: EdgeInsets.symmetric(
                horizontal: buttonPaddingH,
                vertical: buttonPaddingV,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(buttonBorderRadius),
              ),
              elevation: 5,
            ),
            child: Text(
              'Continue',
              style: TextStyle(
                fontSize: buttonFontSize,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMotivationalMessage(int level) {
    switch (level) {
      case 1:
        return "Welcome to your Bible journey!";
      case 2:
        return "You're making great progress!";
      case 3:
        return "Your knowledge is growing!";
      case 4:
        return "Impressive dedication to learning!";
      case 5:
        return "You've become truly skilled!";
      case 6:
        return "Mastery is within your reach!";
      case 7:
        return "Your wisdom shines brightly!";
      case 8:
        return "Legendary achievement unlocked!";
      case 9:
        return "You are among the elite!";
      case 10:
        return "Ultimate mastery achieved!";
      default:
        return "Keep up the amazing work!";
    }
  }
}