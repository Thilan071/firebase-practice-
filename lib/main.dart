import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'theme/app_theme.dart';
import 'views/splash_screen.dart';
import 'views/login_screen.dart';
import 'views/signup_screen.dart';
import 'widgets/main_navigation_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Enable Firebase emulator
  FirebaseFirestore.instance.settings = const Settings(
    host: '127.0.0.1:8080', // For local emulator
    sslEnabled: false,
    persistenceEnabled: false,
  );

  // Print a confirmation message
  print(
    'Firebase initialized with emulator at: ${FirebaseFirestore.instance.settings.host}',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusConnect',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const MainNavigationScreen(),
      },
    );
  }
}
