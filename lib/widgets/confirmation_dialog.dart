import 'package:flutter/material.dart';
import 'dialog_header.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final String confirmText;
  final String cancelText;
  final Color confirmButtonColor;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isDarkMode;
  final Widget? additionalContent;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.confirmButtonColor = const Color(0xFFEE7C9E),
    required this.onConfirm,
    this.onCancel,
    this.isDarkMode = false,
    this.additionalContent,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
      title: DialogHeader(
        icon: icon,
        title: title,
        iconColor: iconColor,
        iconSize: screenWidth * 0.06,
        titleSize: screenWidth * 0.05,
        isDarkMode: isDarkMode,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w400,
              fontSize: screenWidth * 0.04,
              color: isDarkMode ? Colors.white70 : const Color(0xFF5D4037),
            ),
          ),
          if (additionalContent != null) ...[
            const SizedBox(height: 12),
            additionalContent!,
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.pop(context),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: Text(
            cancelText,
            style: TextStyle(
              color: const Color(0xFF8F9ABA),
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w700,
              fontSize: screenWidth * 0.04,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmButtonColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            confirmText,
            style: TextStyle(
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w700,
              fontSize: screenWidth * 0.04,
            ),
          ),
        ),
      ],
    );
  }
}