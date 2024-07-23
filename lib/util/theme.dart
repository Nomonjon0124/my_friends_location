import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      background: Colors.grey.shade400,
      primary: Colors.grey.shade300,
      secondary: Colors.grey.shade200,
    ),
    scaffoldBackgroundColor: Colors.grey.shade400,
    textTheme: const TextTheme().apply(bodyColor: Colors.black)
);
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(background: Color(0xFF161622), primary: Colors.grey.shade900),
  scaffoldBackgroundColor: Color(0xFF252429),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.white),
  ),
);
