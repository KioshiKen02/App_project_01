import 'package:flutter/material.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF416FDF),
  onPrimary: Color(0xFFFFFFFF),
  secondary: Color(0xFF6EAEE7),
  onSecondary: Color(0xFFFFFFFF),
  error: Color(0xFFBA1A1A),
  onError: Color(0xFFFFFFFF),
  surface: Color(0xFFFCFDF6),
  onSurface: Color(0xFF1A1C18),
  shadow: Color(0xFF000000),
  outlineVariant: Color(0xFFC2C8BC),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF416FDF),
  onPrimary: Color(0xFFFFFFFF),
  secondary: Color(0xFF6EAEE7),
  onSecondary: Color(0xFFFFFFFF),
  error: Color(0xFFBA1A1A),
  onError: Color(0xFFFFFFFF),
  surface: Color(0xFF1A1C18),
  onSurface: Color(0xFFFCFDF6),
  shadow: Color(0xFF000000),
  outlineVariant: Color(0xFFC2C8BC),
);

/// Button Style with Hover Effect
final ButtonStyle elevatedButtonStyle = ButtonStyle(
  backgroundColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
      if (states.contains(WidgetState.hovered)) {
        return Colors.blue[900]!; // Darker on hover
      }
      return Colors.blue[700]!;
    },
  ),
  foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
  elevation: WidgetStateProperty.resolveWith<double>(
        (Set<WidgetState> states) {
      if (states.contains(WidgetState.hovered)) {
        return 15.0; // Increase elevation on hover
      }
      return 5.0;
    },
  ),
  padding: WidgetStateProperty.all<EdgeInsets>(
    EdgeInsets.symmetric(horizontal: 20, vertical: 18),
  ),
  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
    ),
  ),
);

/// Light Mode Theme
ThemeData lightMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: lightColorScheme,
  elevatedButtonTheme: ElevatedButtonThemeData(style: elevatedButtonStyle),
);

/// Dark Mode Theme
ThemeData darkMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: darkColorScheme,
  elevatedButtonTheme: ElevatedButtonThemeData(style: elevatedButtonStyle),
);
