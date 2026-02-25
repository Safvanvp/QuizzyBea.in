import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF7C3AED); // Violet-600
  static const Color primaryLight = Color(0xFFA78BFA); // Violet-400
  static const Color primaryDark = Color(0xFF5B21B6); // Violet-800
  static const Color accent = Color(0xFFD5FF5F); // Lime-yellow

  // Backgrounds
  static const Color bgDark = Color(0xFF0F0F1A);
  static const Color bgCard = Color(0xFF1A1A2E);
  static const Color bgSurface = Color(0xFF16213E);

  // Text
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textHint = Color(0xFF64748B);

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // Misc
  static const Color white = Colors.white;
  static const Color divider = Color(0xFF2D2D44);

  // Gradient
  static const List<Color> primaryGradient = [
    Color(0xFF7C3AED),
    Color(0xFF4F46E5),
  ];

  static const List<List<Color>> categoryGradients = [
    [Color(0xFF7C3AED), Color(0xFF4F46E5)],
    [Color(0xFF0EA5E9), Color(0xFF06B6D4)],
    [Color(0xFFF97316), Color(0xFFEF4444)],
    [Color(0xFF10B981), Color(0xFF059669)],
    [Color(0xFFEC4899), Color(0xFF8B5CF6)],
    [Color(0xFFF59E0B), Color(0xFFEF4444)],
  ];
}
