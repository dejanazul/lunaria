/// App Constants
/// Contains all constant values used throughout the app
import 'package:flutter/material.dart';

class AppConstants {
  // ================ APP INFO ================
  static const String appName = 'Lunaria';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'Your Personal Fitness Journey Companion';

  // ================ DIMENSIONS ================

  // Padding & Margins
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 12.0;
  static const double paddingL = 16.0;
  static const double paddingXL = 20.0;
  static const double paddingXXL = 24.0;
  static const double paddingXXXL = 32.0;

  // Border Radius
  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 15.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;
  static const double radiusRound = 100.0;

  // Sizes
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 20.0;
  static const double iconSizeL = 24.0;
  static const double iconSizeXL = 28.0;
  static const double iconSizeXXL = 32.0;

  // Button Heights
  static const double buttonHeightS = 40.0;
  static const double buttonHeightM = 48.0;
  static const double buttonHeightL = 55.0;
  static const double buttonHeightXL = 60.0;

  // Container Sizes
  static const double containerSizeS = 60.0;
  static const double containerSizeM = 80.0;
  static const double containerSizeL = 100.0;
  static const double containerSizeXL = 120.0;
  static const double containerSizeXXL = 150.0;

  // ================ LAYOUT ================

  // Screen Breakpoints
  static const double mobileBreakpoint = 768.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1440.0;

  // Grid
  static const double gridSpacing = 16.0;
  static const int gridCrossAxisCount = 2;
  static const double gridChildAspectRatio = 1.0;

  // List
  static const double listItemHeight = 72.0;
  static const double listItemSpacing = 8.0;

  // ================ ANIMATION ================

  // Duration
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration animationVerySlow = Duration(milliseconds: 1000);

  // Curves
  static const Curve animationCurve = Curves.easeInOut;
  static const Curve animationCurveIn = Curves.easeIn;
  static const Curve animationCurveOut = Curves.easeOut;

  // ================ FITNESS CONSTANTS ================

  // Activity Goals
  static const int defaultCalorieGoal = 400;
  static const int defaultStepsGoal = 10000;
  static const double defaultDistanceGoal = 5.0; // km
  static const int defaultWorkoutGoal = 30; // minutes

  // Training Categories
  static const List<String> trainingCategories = [
    'Yoga',
    'Dance',
    'Aerobic',
    'Zumba',
    'HIIT',
    'Strength',
    'Cardio',
    'Pilates',
  ];

  // Difficulty Levels
  static const List<String> difficultyLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert',
  ];

  // Workout Duration Options (minutes)
  static const List<int> workoutDurations = [15, 30, 45, 60, 90];

  // ================ USER INTERFACE ================

  // Bottom Navigation
  static const int bottomNavItemCount = 5;
  static const List<String> bottomNavLabels = [
    'Calendar',
    'Train',
    'Pet',
    'Community',
    'Profile',
  ];

  // Tab Bar
  static const double tabBarHeight = 48.0;
  static const double tabIndicatorWeight = 3.0;

  // App Bar
  static const double appBarHeight = 56.0;
  static const double appBarElevation = 0.0;

  // Card
  static const double cardElevation = 4.0;
  static const double cardBorderRadius = 15.0;

  // ================ VALIDATION ================

  // Text Field Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 20;
  static const int maxEmailLength = 100;

  // Regular Expressions
  static const String emailRegex =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneRegex = r'^\+?[\d\s\-\(\)]+$';
  static const String usernameRegex = r'^[a-zA-Z0-9_]+$';

  // ================ API CONSTANTS ================

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration apiConnectionTimeout = Duration(seconds: 10);

  // Retry
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // ================ STORAGE KEYS ================

  // Shared Preferences Keys
  static const String keyIsFirstLaunch = 'is_first_launch';
  static const String keyUserToken = 'user_token';
  static const String keyUserId = 'user_id';
  static const String keyUserProfile = 'user_profile';
  static const String keyAppSettings = 'app_settings';
  static const String keyFitnessData = 'fitness_data';
  static const String keyLastSync = 'last_sync';

  // ================ NOTIFICATIONS ================

  // Notification Channels
  static const String notificationChannelGeneral = 'general';
  static const String notificationChannelWorkout = 'workout';
  static const String notificationChannelReminder = 'reminder';

  // ================ FIGMA SPECIFIC VALUES ================

  // Based on Figma design system
  static const double figmaFrameWidth = 390.0;
  static const double figmaFrameHeight = 844.0;
  static const double figmaStatusBarHeight = 44.0;
  static const double figmaBottomNavHeight = 129.0;
  static const double figmaHomeIndicatorHeight = 34.0;

  // Figma Component Sizes
  static const double figmaButtonHeight = 55.0;
  static const double figmaInputHeight = 60.0;
  static const double figmaCardMinHeight = 80.0;
  static const double figmaLogoSize = 150.0;

  // ================ ERROR MESSAGES ================

  static const String errorNetworkConnection =
      'Please check your internet connection';
  static const String errorServerError =
      'Server error occurred. Please try again';
  static const String errorUnauthorized = 'Please login to continue';
  static const String errorInvalidCredentials = 'Invalid email or password';
  static const String errorEmailRequired = 'Email is required';
  static const String errorPasswordRequired = 'Password is required';
  static const String errorInvalidEmail = 'Please enter a valid email';
  static const String errorPasswordTooShort =
      'Password must be at least 6 characters';
  static const String errorGeneric = 'Something went wrong. Please try again';

  // ================ SUCCESS MESSAGES ================

  static const String successLogin = 'Login successful!';
  static const String successSignup = 'Account created successfully!';
  static const String successPasswordReset = 'Password reset email sent!';
  static const String successProfileUpdate = 'Profile updated successfully!';
  static const String successWorkoutComplete = 'Workout completed!';
}
