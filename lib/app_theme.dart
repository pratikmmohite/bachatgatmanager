import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData of(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      appBarTheme: const AppBarTheme(centerTitle: false),
    );
  }
}
