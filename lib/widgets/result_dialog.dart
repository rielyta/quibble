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
                  vertical: isLandscape ? 20 : 40,
                  horizontal: 20,
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
              fontSize: 48,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 60),
          _buildImage(screenWidth * 0.5),
          const SizedBox(height: 60),
          _buildNextButton(),
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
                    fontSize: 36,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildNextButton(),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 5,
            child: _buildImage(screenHeight * 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(double size) {
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

  Widget _buildNextButton() {
    return ElevatedButton(
      onPressed: onNext,
      style: ElevatedButton.styleFrom(
        backgroundColor:
        isCorrect ? const Color(0xFFEE7C9E) : const Color(0xFF8F9ABA),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 3,
      ),
      child: const Text(
        'Next',
        style: TextStyle(
          fontSize: 20,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}