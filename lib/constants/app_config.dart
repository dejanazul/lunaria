/// General app constants and configuration
class AppConstants {
  // App information
  static const String appName = 'Lunaria';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Your Personal Fitness Companion';

  // API configuration
  static const String baseUrl = 'https://api.lunaria.app';
  static const String apiVersion = 'v1';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Storage keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyUserProfile = 'user_profile';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyOnboardingComplete = 'onboarding_complete';

  // Validation constants
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int maxBioLength = 500;

  // UI constants
  static const double borderRadius = 12.0;
  static const double buttonHeight = 56.0;
  static const double inputHeight = 56.0;
  static const double cardElevation = 4.0;
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);

  // Social login providers
  static const String googleProvider = 'google';
  static const String facebookProvider = 'facebook';
  static const String appleProvider = 'apple';

  // Error messages
  static const String errorNetworkConnection =
      'Please check your internet connection';
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorInvalidEmail = 'Please enter a valid email address';
  static const String errorPasswordTooShort =
      'Password must be at least $minPasswordLength characters';
  static const String errorPasswordsNotMatch = 'Passwords do not match';
  static const String errorRequiredField = 'This field is required';

  // Success messages
  static const String successAccountCreated = 'Account created successfully!';
  static const String successPasswordReset = 'Password reset email sent!';
  static const String successProfileUpdated = 'Profile updated successfully!';

  // Regex patterns
  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^\+?[\d\s\-\(\)]+$';
  static const String namePattern = r'^[a-zA-Z\s]+$';

  // Workout categories
  static const List<String> workoutCategories = [
    'Cardio',
    'Strength',
    'Flexibility',
    'Balance',
    'HIIT',
    'Yoga',
    'Pilates',
    'CrossFit',
    'Swimming',
    'Running',
    'Cycling',
    'Dancing',
  ];

  // Difficulty levels
  static const List<String> difficultyLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert',
  ];

  // Equipment types
  static const List<String> equipmentTypes = [
    'No Equipment',
    'Dumbbells',
    'Barbell',
    'Resistance Bands',
    'Kettlebell',
    'Medicine Ball',
    'Yoga Mat',
    'Pull-up Bar',
    'Bench',
    'Cable Machine',
  ];

  // Workout durations (in minutes)
  static const List<int> workoutDurations = [15, 30, 45, 60, 90, 120];

  // Days of week
  static const List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  // Goal types
  static const List<String> fitnessGoals = [
    'Lose Weight',
    'Build Muscle',
    'Improve Endurance',
    'Increase Flexibility',
    'General Fitness',
    'Sport Performance',
    'Rehabilitation',
  ];
}
