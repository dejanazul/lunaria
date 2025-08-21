import 'package:flutter/material.dart';

/// App color constants based on Lunaria design system
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF913F9E);
  static const Color secondary = Color(0xFFC774B2);
  static const Color accent = Color(0xFF7B347E);

  // Background colors
  static const Color background = Color(0xFFF4D5E0);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF8F0F4);

  // Text colors
  static const Color textPrimary = Color(0xFF210535);
  static const Color textSecondary = Color(0xFF6B4C7A);
  static const Color textTertiary = Color(0xFF9B8AA3);

  // Functional colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Button colors
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = secondary;
  static const Color buttonDisabled = Color(0xFFE0E0E0);

  // Border colors
  static const Color borderLight = Color(0xFFE8E8E8);
  static const Color borderMedium = Color(0xFFD0D0D0);
  static const Color borderDark = Color(0xFFB0B0B0);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF420D4A), Color(0xFF7B347E)],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, surface],
  );

  // Social login colors
  static const Color google = Color(0xFFDB4437);
  static const Color facebook = Color(0xFF4267B2);
  static const Color apple = Color(0xFF000000);

  // Transparent colors
  static const Color transparent = Colors.transparent;
  static const Color shadow = Color(0x1A000000);
  static const Color overlay = Color(0x80000000);
}
