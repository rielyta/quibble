import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final double size;
  final bool showEditBadge;
  final List<double>? decorativeCircleSizes;
  final bool isDarkMode;

  const UserAvatar({
    super.key,
    required this.size,
    this.showEditBadge = false,
    this.decorativeCircleSizes,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    if (decorativeCircleSizes != null) {
      return _buildAvatarWithDecoration();
    }
    return _buildSimpleAvatar();
  }

  Widget _buildSimpleAvatar() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEE7C9E), Color(0xFFF295B0)],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEE7C9E).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        Icons.person,
        color: Colors.white,
        size: size * 0.6,
      ),
    );
  }

  Widget _buildAvatarWithDecoration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Decorative circles
        if (decorativeCircleSizes != null && decorativeCircleSizes!.isNotEmpty)
          ...decorativeCircleSizes!.asMap().entries.map((entry) {
            final index = entry.key;
            final circleSize = entry.value;
            final alpha = isDarkMode
                ? 0.2 - (index * 0.05)
                : 0.1 - (index * 0.05);

            return Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEE7C9E).withValues(alpha: alpha),
              ),
            );
          }),

        // Main Avatar
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFEE7C9E),
                Color(0xFFF295B0),
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFEE7C9E).withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.person,
            size: size * 0.6,
            color: Colors.white,
          ),
        ),

        // Edit Badge
        if (showEditBadge)
          Positioned(
            bottom: size * 0.05,
            right: size * 0.05,
            child: Container(
              padding: EdgeInsets.all(size * 0.15),
              decoration: BoxDecoration(
                color: const Color(0xFF8F9ABA),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.edit,
                size: size * 0.25,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}