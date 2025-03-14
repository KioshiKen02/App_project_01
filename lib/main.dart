import 'package:flutter/material.dart';
import 'package:project_01/pages/dashboard.dart';
import 'package:project_01/screens/signin_screen.dart';
import 'package:project_01/screens/welcome_screen.dart';
import 'package:project_01/theme/themeprovider.dart'; // Ensure this path is correct
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: themeProvider.themeData,
      darkTheme: ThemeProvider.darkTheme, // Add dark theme
      themeMode: themeProvider.themeMode, // Use theme mode (light, dark, system)
      home: const WelcomeScreen(),
      routes: {
        '/dashboard': (context) => const DashboardPages(),
        '/signin': (context) => const SignInScreen(),
        '/welcome': (context) => const WelcomeScreen(),
      },
    );
  }
}