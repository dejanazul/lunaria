import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes/routes.dart';
import 'providers/chat_history_provider.dart';
import 'providers/cookie_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatHistoryProvider()),
        ChangeNotifierProvider(create: (_) => CookieProvider()),
      ],
      child: const MainApp(),
    ),
  );
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
