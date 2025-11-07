import 'package:flutter/material.dart';

class ResultDialog extends StatelessWidget {
  final bool isCorrect;
  final VoidCallback onNext;

  const ResultDialog({
    super.key,
    required this.isCorrect,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(31),
      ),
      child: OrientationBuilder(
        builder: (context, orientation) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final isLandscape = orientation == Orientation.landscape;
              final screenWidth = MediaQuery.of(context).size.width;
              final screenHeight = MediaQuery.of(context).size.height;

              return Container(
                width: isLandscape ? screenWidth * 0.6 : screenWidth * 0.84,
                constraints: BoxConstraints(
                  maxHeight: isLandscape ? screenHeight * 0.85 : screenHeight * 0.7,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: isLandscape ? screenHeight * 0.025 : screenHeight * 0.05,
                  horizontal: screenWidth * 0.04,
                ),
                decoration: BoxDecoration(
                  color: isCorrect ? const Color(0xFFF6E1E5) : const Color(0xFFDDE5FA),
                  borderRadius: BorderRadius.circular(31),
                ),
                child: isLandscape
                    ? _buildLandscapeLayout(screenWidth, screenHeight)
                    : _buildPortraitLayout(screenWidth, screenHeight),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPortraitLayout(double screenWidth, double screenHeight) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isCorrect ? 'CORRECT!' : 'WRONG!',
            style: TextStyle(
              color: isCorrect ? const Color(0xFF58A754) : const Color(0xFFF5405B),
              fontSize: screenWidth * 0.12,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: screenHeight * 0.075),
          _buildImage(screenWidth * 0.5, screenHeight),
          SizedBox(height: screenHeight * 0.075),
          _buildNextButton(screenWidth, screenHeight, false),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout(double screenWidth, double screenHeight) {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isCorrect ? 'CORRECT!' : 'WRONG!',
                  style: TextStyle(
                    color: isCorrect ? const Color(0xFF58A754) : const Color(0xFFF5405B),
                    fontSize: screenHeight * 0.08,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.03),
                _buildNextButton(screenWidth, screenHeight, true),
              ],
            ),
          ),
          SizedBox(width: screenWidth * 0.03),
          Expanded(
            flex: 5,
            child: _buildImage(screenHeight * 0.5, screenHeight),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(double size, double screenHeight) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: size,
        maxHeight: size,
      ),
      child: Image.asset(
        isCorrect
            ? 'assets/images/CorrectImage.png'
            : 'assets/images/WrongImage.png',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildNextButton(double screenWidth, double screenHeight, bool isLandscape) {
    return ElevatedButton(
      onPressed: onNext,
      style: ElevatedButton.styleFrom(
        backgroundColor: isCorrect ? const Color(0xFFEE7C9E) : const Color(0xFF8F9ABA),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          vertical: isLandscape ? screenHeight * 0.015 : screenHeight * 0.015,
          horizontal: isLandscape ? screenWidth * 0.05 : screenWidth * 0.08,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 3,
      ),
      child: Text(
        'Next',
        style: TextStyle(
          fontSize: isLandscape ? screenHeight * 0.045 : screenWidth * 0.05,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}