import 'package:flutter/material.dart';
import 'package:project_01/screens/welcome_screen.dart';
import 'package:project_01/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      //       useMaterial3: true,
      // ),
      theme: lightMode,
      home: WelcomeScreen(),
    );
  }
}


