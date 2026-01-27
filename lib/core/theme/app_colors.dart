import 'package:flutter/material.dart';

class AppColors {
  static const Color backgroundLight = Color(0xFFFDFCFE);
  static const Color surfaceWhite = Colors.white;
  static const Color primaryPink = Color(0xFFEA4472);
  static const Color primaryPinkDark = Color(0xFFD83663);
  static const Color primaryGreen = Color(0xFF4ADE80);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);

  static const Gradient bgGradient = RadialGradient(
    center: Alignment(1.0, -1.0),
    radius: 1.5,
    colors: [Color(0xFFE9D5FF), Color(0xFFFDFCFE)],
    stops: [0.0, 0.6],
  );

  static const Gradient breakBgGradient = RadialGradient(
    center: Alignment(1.0, -1.0),
    radius: 1.5,
    colors: [Color(0xFFDCFCE7), Color(0xFFFDFCFE)],
    stops: [0.0, 0.6],
  );

  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: const Color(0xFF000000).withValues(alpha: 0.05),
      blurRadius: 30,
      offset: const Offset(0, 10),
    ),
  ];

  static const Gradient fabGradient = LinearGradient(
    colors: [Color(0xFFFF7597), Color(0xFFEA4472)],
  );
}