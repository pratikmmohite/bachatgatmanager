import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData of(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(centerTitle: false),
    );
  }
}
