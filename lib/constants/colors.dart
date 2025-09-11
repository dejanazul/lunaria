import 'package:flutter/material.dart';

/// Lunaria App Color Palette
/// Based on Figma Design System
class AppColors {
  // Primary Colors from Figma
  static const Color primary = Color(0xFF913F9E);
  static const Color primaryDark = Color(0xFF210535);
  static const Color primaryLight = Color(0xFFC774B2);
  static const Color secondary = Color(0xFF420D4A);
  static const Color accent = Color(0xFF7B347E);

  // Background Colors
  static const Color background = Color(0xFFF4D5E0);
  static const Color backgroundLight = Colors.white;
  static const Color surface = Colors.white;

  // Text Colors
  static const Color textPrimary = Color(0xFF210535);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textLight = Color(0xFF999999);
  static const Color textOnPrimary = Colors.white;

  // Neutral Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1A000000);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [primaryDark, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Activity Ring Colors (from Figma Train page)
  static const Color moveRing = Color(0xFF913F9E);
  static const Color exerciseRing = Color(0xFFC774B2);
  static const Color standRing = Color(0xFF7B347E);

  // Training Category Colors
  static const Color yogaColor = Color(0xFF9C27B0);
  static const Color danceColor = Color(0xFFE91E63);
  static const Color aerobicColor = Color(0xFF673AB7);
  static const Color zumbaColor = Color(0xFF3F51B5);
  static const Color hiitColor = Color(0xFF2196F3);

  // Pet Colors (from Pet page)
  static const Color petBackground = Color(0xFFF4D5E0);
  static const Color petAccent = Color(0xFF913F9E);

  // Community Colors
  static const Color communityPrimary = Color(0xFF913F9E);
  static const Color communitySecondary = Color(0xFFC774B2);

  // Calendar Colors
  static const Color calendarToday = Color(0xFF913F9E);
  static const Color calendarSelected = Color(0xFFC774B2);
  static const Color calendarEvent = Color(0xFF7B347E);

  static var purpleDark;

  static var purpleMid;
}

/// App Theme Data
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: AppColors.backgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4,
          shadowColor: AppColors.primary.withOpacity(0.4),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.all(20),
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shadowColor: AppColors.shadow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
