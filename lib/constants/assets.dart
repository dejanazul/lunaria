/// App Assets Constants
/// Contains all asset paths used in the Lunaria app
class AppAssets {
  // Base asset paths
  static const String _imagesPath = 'assets/images/';
  static const String _iconsPath = 'assets/icons/';

  // ================ ICONS ================

  // Navigation Icons
  static const String iconCalendar = '${_iconsPath}calendar.svg';
  static const String iconBarbell = '${_iconsPath}barbell.svg';
  static const String iconPaw = '${_iconsPath}paw.svg';
  static const String iconPeople = '${_iconsPath}people_outline.svg';
  static const String iconPerson = '${_iconsPath}person.svg';
  static const String iconPersonSharp = '${_iconsPath}person_sharp.svg';

  // Action Icons
  static const String iconArrowUp = '${_iconsPath}arrow_up.svg';
  static const String iconArrowUpBold = '${_iconsPath}arrow_up_bold.svg';
  static const String iconNext = '${_iconsPath}next.svg';
  static const String iconCheck = '${_iconsPath}check.svg';
  static const String iconCheckRounded = '${_iconsPath}check_rounded.svg';
  static const String iconPlus = '${_iconsPath}plus.svg';

  // Communication Icons
  static const String iconChat = '${_iconsPath}chat.svg';
  static const String iconMessage = '${_iconsPath}message_filled.svg';
  static const String iconMessageAdd = '${_iconsPath}message_add.svg';

  // Utility Icons
  static const String iconCalendarOutline = '${_iconsPath}calendar_outline.svg';
  static const String iconSetting = '${_iconsPath}setting_outlined.svg';
  static const String iconUser = '${_iconsPath}user.svg';

  // Media Icons
  static const String iconPlay = '${_iconsPath}play_fill.svg';
  static const String iconFullscreen = '${_iconsPath}fullscreen.svg';

  // ================ IMAGES ================

  // Pet & Character Images
  static const String imagePetIllustration =
      '${_imagesPath}pet_illustration.png';

  // Trainer Profile Images
  static const String imageTrainer1 = '${_imagesPath}trainer_image_1.png';
  static const String imageTrainer2 = '${_imagesPath}trainer_image_2.png';
  static const String imageTrainer3 = '${_imagesPath}trainer_image_3.png';
  static const String imageTrainer4 = '${_imagesPath}trainer_image_4.png';
  static const String imageTrainer5 = '${_imagesPath}trainer_image_5.png';
  static const String imageTrainer6 = '${_imagesPath}trainer_image_6.png';
  static const String imageTrainer7 = '${_imagesPath}trainer_image_7.png';

  // Trainer Images List for easy iteration
  static const List<String> trainerImages = [
    imageTrainer1,
    imageTrainer2,
    imageTrainer3,
    imageTrainer4,
    imageTrainer5,
    imageTrainer6,
    imageTrainer7,
  ];

  // ================ NAVIGATION ASSETS ================

  // Bottom Navigation Icons
  static const Map<String, String> bottomNavIcons = {
    'calendar': iconCalendar,
    'train': iconBarbell,
    'pet': iconPaw,
    'community': iconPeople,
    'profile': iconPerson,
  };

  // ================ TRAINING ASSETS ================

  // Training Category Icons (can be extended with specific icons)
  static const Map<String, String> trainingIcons = {
    'yoga': iconPerson, // Replace with specific yoga icon when available
    'dance': iconPerson, // Replace with specific dance icon when available
    'aerobic': iconPerson, // Replace with specific aerobic icon when available
    'zumba': iconPerson, // Replace with specific zumba icon when available
    'hiit': iconBarbell, // Using barbell for HIIT
  };

  // ================ SOCIAL ASSETS ================

  // Social Media Icons (using system icons for now)
  static const Map<String, String> socialIcons = {
    'google': 'assets/icons/google.svg', // Add when available
    'facebook': 'assets/icons/facebook.svg', // Add when available
    'apple': 'assets/icons/apple.svg', // Add when available
  };

  // ================ HELPER METHODS ================

  /// Get random trainer image
  static String getRandomTrainerImage() {
    return trainerImages[DateTime.now().millisecond % trainerImages.length];
  }

  /// Get trainer image by index
  static String getTrainerImage(int index) {
    if (index < 0 || index >= trainerImages.length) {
      return imageTrainer1; // Default fallback
    }
    return trainerImages[index];
  }

  /// Get navigation icon by name
  static String? getNavIcon(String name) {
    return bottomNavIcons[name.toLowerCase()];
  }

  /// Get training icon by category
  static String? getTrainingIcon(String category) {
    return trainingIcons[category.toLowerCase()];
  }
}
