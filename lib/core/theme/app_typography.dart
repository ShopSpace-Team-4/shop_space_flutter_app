import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@immutable
abstract final class AppTypography {
  static const String displayFontFamily = 'Inter';
  static const String arabicFontFamily = 'IBM Plex Sans Arabic';
  static const String monoFontFamily = 'JetBrains Mono';

  /// Design-system text styles, fully responsive: every `fontSize` scales
  /// with `.sp` against the Figma reference frame (375×812). Getters (not
  /// `const`) because screenutil needs a runtime instance — so callers must
  /// not use these inside `const` widget trees.
  static TextStyle get displayXL => TextStyle(
        fontFamily: displayFontFamily,
        fontSize: 56.sp,
        fontWeight: FontWeight.w800,
        height: 60.48 / 56,
      );

  static TextStyle get displayL => TextStyle(
        fontFamily: displayFontFamily,
        fontSize: 44.sp,
        fontWeight: FontWeight.w800,
        height: 48.4 / 44,
      );

  static TextStyle get heading1 => TextStyle(
        fontFamily: displayFontFamily,
        fontSize: 36.sp,
        fontWeight: FontWeight.w700,
        height: 41.4 / 36,
      );

  static TextStyle get heading2 => TextStyle(
        fontFamily: displayFontFamily,
        fontSize: 30.sp,
        fontWeight: FontWeight.w700,
        height: 36 / 30,
      );

  static TextStyle get heading3 => TextStyle(
        fontFamily: displayFontFamily,
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        height: 31.2 / 24,
      );

  static TextStyle get heading4 => TextStyle(
        fontFamily: displayFontFamily,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        height: 27 / 20,
      );

  static TextStyle get bodyLarge => TextStyle(
        fontFamily: displayFontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        height: 26.4 / 16,
      );

  static TextStyle get bodyMedium => TextStyle(
        fontFamily: displayFontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        height: 22.4 / 14,
      );

  static TextStyle get bodySmall => TextStyle(
        fontFamily: displayFontFamily,
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        height: 20.15 / 13,
      );

  static TextStyle get caption => TextStyle(
        fontFamily: displayFontFamily,
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        height: 15.4 / 11,
        letterSpacing: 0.5,
      );

  static TextStyle get mono => TextStyle(
        fontFamily: monoFontFamily,
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        height: 20.8 / 13,
      );
}
