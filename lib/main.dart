import 'package:flutter/material.dart';
import 'routes/routes.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final routerConfig = AppRouter.getRouterConfig();

    return MaterialApp(
      title: 'Lunaria',
      navigatorKey: routerConfig['navigatorKey'],
      onGenerateRoute: routerConfig['onGenerateRoute'],
      initialRoute: routerConfig['initialRoute'],
      debugShowCheckedModeBanner: false,
    );
  }
}
