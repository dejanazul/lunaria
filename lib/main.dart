import 'package:flutter/material.dart';
import 'package:lunaria/providers/signup_data_provider.dart' as signup;
import 'package:lunaria/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'routes/routes.dart';
import 'providers/chat_history_provider.dart';
import 'providers/cookie_provider.dart';
import 'providers/level_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://vusuygyolfeyaczrjsjh.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ1c3V5Z3lvbGZleWFjenJqc2poIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY4MjcyMzQsImV4cCI6MjA3MjQwMzIzNH0.6mlnuoYNxlHzKqCSzirxnT_bir5N9FELpmHUw5sn64U',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatHistoryProvider()),
        ChangeNotifierProvider(create: (_) => CookieProvider()),
        ChangeNotifierProvider(create: (_) => LevelProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => signup.SignupDataProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        // Gunakan informasi status autentikasi dari UserProvider
        final routerConfig = AppRouter.getRouterConfig();

        // Tentukan initial route berdasarkan status autentikasi
        String initialRoute;

        if (userProvider.isAuthenticated) {
          initialRoute = RouteNames.home;
          debugPrint('📱 User authenticated, redirecting to home screen');
        } else {
          initialRoute = RouteNames.login;
          debugPrint('🔒 User not authenticated, showing login screen');
        }

        return MaterialApp(
          title: 'Lunaria',
          navigatorKey: routerConfig['navigatorKey'],
          onGenerateRoute: routerConfig['onGenerateRoute'],
          initialRoute: initialRoute,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
