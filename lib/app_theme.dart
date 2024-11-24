import 'package:flutter/material.dart';

class AppTheme {
  static const Color green = Color(0xFF58CFA4);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color gray = Color(0xFFecf1ff);

  static ThemeData lightTheme = ThemeData(
    primaryColor: green,
    appBarTheme: const AppBarTheme(
      foregroundColor: green,
      centerTitle: true,
      backgroundColor: white,
      titleTextStyle:
          TextStyle(color: green, fontSize: 24, fontWeight: FontWeight.w600),
    ),
    scaffoldBackgroundColor: white,
    textTheme: const TextTheme(
      titleSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: black,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: black,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: white,
        backgroundColor: green,
        textStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: white,
        ),
      ),
    ),
  );
}
