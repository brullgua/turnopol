import 'package:flutter/material.dart';

class ThemeColors {
  static Color secondary = const Color(0xFF39D2C0);
  static Color primary = const Color(0xFF4B39EF);
  static Color tertiary = const Color(0xFFEE8B60);
  static Color alternate = const Color(0xFF262d34);
  static Color morado = const Color(0xFF8F34EA);
  static Color grisOscuro = const Color(0xFF161F31);
  static Color surface = const Color(0xFF1d2428);
  static Color blanco = const Color(0xFFF8FAFC);
  static Color grisClaro = const Color(0xFF94A3B8);
  static Color surfaceContainer = const Color(0xFF14181B);
  static Color warning = const Color(0xFFf9cf58);
  static Color error = const Color(0xFFff5963);
  static Color success = const Color(0xFF249689);

  static ThemeData themeData = ThemeData(
    primaryColor: primary,
    brightness: Brightness.dark,
    fontFamily: 'Poppins',
    colorScheme: ColorScheme(
      brightness: Brightness.dark, 
      primary: primary, 
      onPrimary: blanco, 
      primaryContainer: alternate,
      onPrimaryContainer: blanco,
      secondary: morado, 
      onSecondary: blanco, 
      error: error, 
      onError: blanco, 
      surface: surfaceContainer,
      onSurface: blanco,
      surfaceContainer: surfaceContainer,
      secondaryContainer: grisClaro,
      tertiary: morado,
    ),
  );
}