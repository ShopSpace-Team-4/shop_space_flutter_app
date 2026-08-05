import 'package:flutter/material.dart';

@immutable
abstract final class AppColors {
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryContainer = Color(0xFFEFF6FF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryHover = Color(0xFF1D4ED8);
  static const Color primaryBorder = Color(0xFFBFDBFE);

  static const Color accent = Color(0xFF14B8A6);
  static const Color accentHover = Color(0xFF0D9488);
  static const Color accentSubtle = Color(0xFFF0FDFA);

  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color surfaceInverse = Color(0xFF0F172A);

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFFCBD5E1);
  static const Color textInverse = Color(0xFFFFFFFF);
  static const Color textLink = Color(0xFF2563EB);

  static const Color success = Color(0xFF22C55E);
  static const Color successContainer = Color(0xFFF0FDF4);
  static const Color successOnContainer = Color(0xFF16A34A);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningContainer = Color(0xFFFFFBEB);
  static const Color warningOnContainer = Color(0xFFD97706);

  static const Color error = Color(0xFFEF4444);
  static const Color errorContainer = Color(0xFFFEF2F2);
  static const Color errorOnContainer = Color(0xFFDC2626);

  static const Color outline = Color(0xFFE2E8F0);
  static const Color outlineVariant = Color(0xFFCBD5E1);
  static const Color outlineSubtle = Color(0xFFF1F5F9);
  static const Color outlineFocus = Color(0xFF93C5FD);
}
