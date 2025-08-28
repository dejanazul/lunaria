import 'package:flutter/material.dart';
import '../screens/calendar/calendar_screen.dart';
import '../screens/train/train_screen.dart';
import '../screens/home_pet/vp_home.dart';
import '../screens/community/community_screen.dart';
import '../screens/profile/profile_screen.dart';

class NavigationHelper {
  static void navigateToScreen(
    BuildContext context,
    int index,
    int currentIndex,
  ) {
    if (index == currentIndex) return;

    Widget screen;
    switch (index) {
      case 0:
        screen = const CalendarScreen();
        break;
      case 1:
        screen = const TrainScreen();
        break;
      case 2:
        screen = const VPHomeScreen();
        break;
      case 3:
        screen = const CommunityScreen();
        break;
      case 4:
        screen = const ProfileScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionDuration: Duration.zero,
      ),
    );
  }
}
