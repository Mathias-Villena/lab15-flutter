import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF7F00FF);
  static const Color accent = Color(0xFFE100FF);
  static const Color background = Color(0xFF0D0D0D);
  static const Color card = Color(0xFF1C1C1E);

  static ThemeData themeData = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    primaryColor: primary,
    useMaterial3: true,
    fontFamily: "Roboto",
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: accent,
      background: background,
    ),
  );
}
