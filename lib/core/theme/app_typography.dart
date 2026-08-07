import 'package:flutter/material.dart';

@immutable
abstract final class AppTypography {
  static const String displayFontFamily = 'Inter';
  static const String arabicFontFamily = 'IBM Plex Sans Arabic';
  static const String monoFontFamily = 'JetBrains Mono';

  static const TextStyle displayXL = TextStyle(
    fontFamily: displayFontFamily,
    fontSize: 56,
    fontWeight: FontWeight.w800,
    height: 60.48 / 56,
  );

  static const TextStyle displayL = TextStyle(
    fontFamily: displayFontFamily,
    fontSize: 44,
    fontWeight: FontWeight.w800,
    height: 48.4 / 44,
  );

  static const TextStyle heading1 = TextStyle(
    fontFamily: displayFontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 41.4 / 36,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: displayFontFamily,
    fontSize: 30,
    fontWeight: FontWeight.w700,
    height: 36 / 30,
  );

  static const TextStyle heading3 = TextStyle(
    fontFamily: displayFontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 31.2 / 24,
  );

  static const TextStyle heading4 = TextStyle(
    fontFamily: displayFontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 27 / 20,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: displayFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 26.4 / 16,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: displayFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 22.4 / 14,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: displayFontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 20.15 / 13,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: displayFontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 15.4 / 11,
    letterSpacing: 0.5,
    
  );

  static const TextStyle mono = TextStyle(
    fontFamily: monoFontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 20.8 / 13,
  );
}
