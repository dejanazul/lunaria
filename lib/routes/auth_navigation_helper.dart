import 'package:flutter/material.dart';
import '../routes/routes.dart';

/// Helper class untuk menangani navigasi authentication
class AuthNavigationHelper {
  /// Navigate ke login screen dan clear semua stack
  static Future<void> navigateToLogin() {
    return NavigationService.navigateAndClearStack(RouteNames.login);
  }

  /// Navigate ke signup dari login
  static Future<void> navigateToSignupFromLogin() {
    return NavigationService.navigateToRoute(RouteNames.signup);
  }

  /// Navigate ke login dari signup
  static Future<void> navigateToLoginFromSignup() async {
    NavigationService.goBack();
  }

  /// Navigate ke home setelah berhasil login
  static Future<void> navigateToHomeAfterLogin() {
    return NavigationService.navigateAndClearStack(RouteNames.home);
  }

  /// Logout dan kembali ke login
  static Future<void> logout() {
    return NavigationService.navigateAndClearStack(RouteNames.login);
  }

  /// Check apakah user sedang di authentication screens
  static bool isInAuthFlow() {
    final currentContext = NavigationService.context;
    if (currentContext == null) return false;

    final currentRoute = ModalRoute.of(currentContext)?.settings.name;
    return currentRoute == RouteNames.login ||
        currentRoute == RouteNames.signup;
  }
}
