import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme () {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(0XFFec6956),
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: Color(0xFFFAF5EC),
    );
  }
}