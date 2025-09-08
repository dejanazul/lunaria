import 'package:flutter/material.dart';
import 'route_names.dart';
import '../screens/calendar/calendar_screen.dart';
import '../screens/train/train_screen.dart';
import '../screens/home_pet/vp_home.dart';
import '../screens/home_pet/buy_cookies.dart';
import '../screens/community/community_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../authentication/login.dart';
import '../authentication/signup.dart';

/// Kelas untuk generate route berdasarkan nama route
class RouteGenerator {
  /// Generate route berdasarkan RouteSettings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.calendar:
        return _createRoute(const CalendarScreen());
      case RouteNames.train:
        return _createRoute(const TrainScreen());
      case RouteNames.home:
        return _createRoute(const VPHomeScreen());
      case RouteNames.community:
        return _createRoute(const CommunityScreen());
      case RouteNames.profile:
        return _createRoute(const ProfileScreen());
      case RouteNames.login:
        return _createRoute(const LoginScreen());
      case RouteNames.signup:
        return _createRoute(const SignUpScreen());
      case RouteNames.buyCookies:
        return _createRoute(BuyCookiesScreen());
      default:
        return _createRoute(const VPHomeScreen()); // Default ke home
    }
  }

  /// Membuat route dengan animasi fade transition
  static PageRoute _createRoute(Widget screen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return FadeTransition(opacity: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Membuat route dengan slide transition untuk navigasi bottom nav
  static PageRoute createBottomNavRoute(Widget screen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionDuration: Duration.zero, // Tanpa animasi untuk bottom nav
    );
  }
}
