import 'package:flutter/material.dart';

ThemeData get appTheme {
  return ThemeData(
    primarySwatch: Colors.blue,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(Colors.white),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
      backgroundColor: Colors.grey.shade600,
    ),
  );
}
