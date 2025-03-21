import 'package:flutter/material.dart';

// Define a custom theme for mental health application
class MentalHealthTheme {
  // Calming purple palette
  static const Color primaryPurple = Color(0xFF6B5B95);
  static const Color lightPurple = Color(0xFFAA98CB);
  static const Color darkPurple = Color(0xFF4A3D70);

  // Accent colors
  static const Color accentTeal = Color(0xFF26A69A);
  static const Color calmBlue = Color(0xFF5C6BC0);

  // Text colors
  static const Color textLight = Color(0xFFF5F5F5);
  static const Color textDark = Color(0xFF333333);

  // Add methods to integrate with the main app's theme
  static ThemeData getTheme() {
    return ThemeData(
      primaryColor: primaryPurple,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPurple,
        primary: primaryPurple,
        secondary: accentTeal,
      ),
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: Colors.white,
    );
  }
}