import 'package:flutter/material.dart';
import 'package:project_01/pages/note.dart';
import 'package:provider/provider.dart';
import 'package:project_01/pages/dashboard.dart';
import 'package:project_01/provider/event.dart';
import 'package:project_01/screens/signin_screen.dart';
import 'package:project_01/screens/welcome_screen.dart';
import 'package:project_01/theme/themeprovider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // 🌎 Add other locales if needed
      ],
      theme: themeProvider.themeData,
      darkTheme: ThemeProvider.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const WelcomeScreen(),
      routes: {
        '/dashboard': (context) => const DashboardPages(),
        '/signin': (context) => const SignInScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/notes': (context) => const NotePages(),
      },
    );
  }
}
