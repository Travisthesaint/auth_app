import 'package:flutter/material.dart';

/// Central place for colours and the app-wide theme.
/// Change [primary] and the whole app re-colours itself.
class AppTheme {
  AppTheme._();

  static const Color primary = Color(0xFF4F46E5); // indigo
  static const Color primaryDark = Color(0xFF312E81);
  static const Color background = Color(0xFFF5F6FA);
  static const Color textDark = Color(0xFF1F2937);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color border = Color(0xFFD1D5DB);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
    );
  }
}
