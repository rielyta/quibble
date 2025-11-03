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
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(31),
      ),
      child: Container(
        width: screenWidth * 0.84,
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        decoration: BoxDecoration(
          color: isCorrect ? const Color(0xFFF6E1E5) : const Color(0xFFDDE5FA),
          borderRadius: BorderRadius.circular(31),
        ),
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
            Image.asset(
              isCorrect
                ? 'assets/images/CorrectImage.png'
                  : 'assets/images/WrongImage.png'
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                isCorrect ? const Color(0xFFEE7C9E) : const Color(0xFF8F9ABA),
                foregroundColor: Colors.white,
                minimumSize: const Size(96, 37),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Next',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}