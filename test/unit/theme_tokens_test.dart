import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_space/core/theme/app_colors.dart';
import 'package:shop_space/core/theme/app_theme.dart';
import 'package:shop_space/core/theme/app_typography.dart';

void main() {
  test('spot-checked token values match the Figma extraction record', () {
    expect(AppColors.background, const Color(0xFFF8FAFC));
    expect(AppColors.primary, const Color(0xFF2563EB));
    expect(AppColors.textPrimary, const Color(0xFF0F172A));
  });

  test('heading font size from type scale', () {
    expect(AppTypography.heading1.fontSize, 36);
  });

  test('AppTheme.build produces a light-only ThemeData', () {
    final theme = AppTheme.build(BuildContextPlaceholder());
    expect(theme.brightness, Brightness.light);
    expect(theme.colorScheme.primary, AppColors.primary);
    expect(theme.scaffoldBackgroundColor, AppColors.background);
  });
}

/// Minimal BuildContext stand-in — AppTheme.build only reads ThemeData inputs
/// synchronously, so the context is not actually used in Phase 0.
class BuildContextPlaceholder implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
