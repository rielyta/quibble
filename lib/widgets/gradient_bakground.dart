import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/theme_provider.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<double>? stops;
  final List<Color>? lightColors;
  final List<Color>? darkColors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const GradientBackground({
    super.key,
    required this.child,
    this.stops,
    this.lightColors,
    this.darkColors,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    // Default colors jika tidak disediakan
    final defaultLightColors = [
      const Color(0xFFFFF8E7),
      const Color(0xFFFFE19E),
    ];

    final defaultDarkColors = [
      const Color(0xFF1A1A1A),
      const Color(0xFF2D2D2D),
    ];

    // Default stops jika tidak disediakan
    final defaultStops = stops ?? [0.3, 1.0];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: isDarkMode
              ? (darkColors ?? defaultDarkColors)
              : (lightColors ?? defaultLightColors),
          stops: defaultStops,
        ),
      ),
      child: child,
    );
  }
}

// Variant khusus untuk QuizListScreen (gradient 3 warna)
class GradientBackgroundTriple extends StatelessWidget {
  final Widget child;
  final List<double>? stops;

  const GradientBackgroundTriple({
    super.key,
    required this.child,
    this.stops,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    final defaultStops = stops ?? [0.0, 0.5, 1.0];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
            const Color(0xFF1A1A1A),
            const Color(0xFF2D2D2D),
            const Color(0xFF3D3D3D),
          ]
              : [
            const Color(0xFFFFF8E7),
            const Color(0xFFFFE19E),
            const Color(0xFFFFD180),
          ],
          stops: defaultStops,
        ),
      ),
      child: child,
    );
  }
}