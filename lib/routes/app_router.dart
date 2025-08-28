import 'package:flutter/material.dart';
import 'route_generator.dart';
import 'navigation_service.dart';
import 'route_names.dart';

/// Konfigurasi utama untuk routing aplikasi
class AppRouter {
  /// Konfigurasi MaterialApp dengan routing
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return RouteGenerator.generateRoute(settings);
  }

  /// Initial route aplikasi
  static String get initialRoute => RouteNames.home;

  /// Navigator key untuk akses global
  static GlobalKey<NavigatorState> get navigatorKey =>
      NavigationService.navigatorKey;

  /// Setup routing untuk MaterialApp
  static Map<String, dynamic> getRouterConfig() {
    return {
      'navigatorKey': navigatorKey,
      'onGenerateRoute': onGenerateRoute,
      'initialRoute': initialRoute,
    };
  }
}
