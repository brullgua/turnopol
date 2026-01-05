import 'package:flutter/material.dart';

class ThemeColors {
  static Color azulSecundario = const Color(0xFF004182);
  static Color azulPrimario = const Color(0xFF2766EC);
  static Color morado = const Color(0xFF8F34EA);
  static Color grisOscuro = const Color(0xFF161F31);
  static Color negro = const Color(0xFF0F1729);
  static Color blanco = const Color(0xFFF8FAFC);
  static Color grisClaro = const Color(0xFF94A3B8);
  static Color negroOscuro = const Color(0xFF0C0C0B);
  static ThemeData themeData = ThemeData(
    primaryColor: azulPrimario,
    brightness: Brightness.dark,
    fontFamily: 'Poppins',
    colorScheme: ColorScheme(
      brightness: Brightness.dark, 
      primary: azulPrimario, 
      onPrimary: blanco, 
      primaryContainer: azulSecundario,
      onPrimaryContainer: blanco,
      secondary: morado, 
      onSecondary: blanco, 
      error: Colors.red, 
      onError: blanco, 
      surface: negroOscuro,
      onSurface: negro,
      surfaceContainer: grisOscuro,
      secondaryContainer: grisClaro,
      tertiary: morado,
    ),
  );
}