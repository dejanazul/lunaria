import 'package:flutter/material.dart';

class ResponsiveHelper {
  static const double _mobileMaxWidth = 480;
  static const double _tabletMaxWidth = 1024;

  // Screen size breakpoints
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < _mobileMaxWidth;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= _mobileMaxWidth &&
        MediaQuery.of(context).size.width < _tabletMaxWidth;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= _tabletMaxWidth;
  }

  // Responsive padding
  static EdgeInsets getHorizontalPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 16);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 32);
    } else {
      return const EdgeInsets.symmetric(horizontal: 64);
    }
  }

  static EdgeInsets getVerticalPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.symmetric(vertical: 16);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(vertical: 24);
    } else {
      return const EdgeInsets.symmetric(vertical: 32);
    }
  }

  static EdgeInsets getAllPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(16);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24);
    } else {
      return const EdgeInsets.all(32);
    }
  }

  // Responsive font sizes
  static double getFontSize(
    BuildContext context, {
    double small = 12.0,
    double medium = 14.0,
    double large = 16.0,
  }) {
    if (isMobile(context)) {
      return small;
    } else if (isTablet(context)) {
      return medium;
    } else {
      return large;
    }
  }

  // Responsive font sizes
  static double getHeadingFontSize(BuildContext context) {
    if (isMobile(context)) {
      return 20;
    } else if (isTablet(context)) {
      return 24;
    } else {
      return 28;
    }
  }

  static double getSubheadingFontSize(BuildContext context) {
    if (isMobile(context)) {
      return 16;
    } else if (isTablet(context)) {
      return 18;
    } else {
      return 20;
    }
  }

  static double getBodyFontSize(BuildContext context) {
    if (isMobile(context)) {
      return 14;
    } else if (isTablet(context)) {
      return 15;
    } else {
      return 16;
    }
  }

  static double getCaptionFontSize(BuildContext context) {
    if (isMobile(context)) {
      return 12;
    } else if (isTablet(context)) {
      return 13;
    } else {
      return 14;
    }
  }

  // Responsive spacing
  static double getSmallSpacing(BuildContext context) {
    if (isMobile(context)) {
      return 8;
    } else if (isTablet(context)) {
      return 12;
    } else {
      return 16;
    }
  }

  static double getMediumSpacing(BuildContext context) {
    if (isMobile(context)) {
      return 16;
    } else if (isTablet(context)) {
      return 20;
    } else {
      return 24;
    }
  }

  static double getLargeSpacing(BuildContext context) {
    if (isMobile(context)) {
      return 24;
    } else if (isTablet(context)) {
      return 32;
    } else {
      return 40;
    }
  }

  // Responsive dimensions
  static double getButtonHeight(BuildContext context) {
    if (isMobile(context)) {
      return 48;
    } else if (isTablet(context)) {
      return 52;
    } else {
      return 56;
    }
  }

  static double getIconSize(BuildContext context) {
    if (isMobile(context)) {
      return 24;
    } else if (isTablet(context)) {
      return 28;
    } else {
      return 32;
    }
  }

  static double getCardBorderRadius(BuildContext context) {
    if (isMobile(context)) {
      return 12;
    } else if (isTablet(context)) {
      return 16;
    } else {
      return 20;
    }
  }

  // Screen width helpers
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Safe area helpers
  static double getSafeAreaTop(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static double getSafeAreaBottom(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  // Responsive container max width
  static double getMaxContentWidth(BuildContext context) {
    if (isMobile(context)) {
      return double.infinity;
    } else if (isTablet(context)) {
      return 600;
    } else {
      return 800;
    }
  }

  // Grid layout helpers
  static int getGridCrossAxisCount(
    BuildContext context, {
    int mobileCount = 2,
    int tabletCount = 3,
    int desktopCount = 4,
  }) {
    if (isMobile(context)) {
      return mobileCount;
    } else if (isTablet(context)) {
      return tabletCount;
    } else {
      return desktopCount;
    }
  }

  static double getGridChildAspectRatio(BuildContext context) {
    if (isMobile(context)) {
      return 1.0;
    } else if (isTablet(context)) {
      return 1.1;
    } else {
      return 1.2;
    }
  }
}
