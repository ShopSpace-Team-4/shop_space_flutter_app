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
  static  const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color surfaceInverse = Color(0xFF0F172A);

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFFCBD5E1);
  static const Color textInverse = Color(0xFFFFFFFF);
  static const Color textLink = Color(0xFF2563EB);

  static const Color success = Color(0xFF22C55E);
  static const Color successContainer = Color(0xFFF0FDF4);
  static const Color successOnContainer = Color(0xFF16A34A);

  /// "Available" inline pill (Figma `97:5547` shop detail): fill `#ECFDF5`,
  /// text `#10B981`. Distinct from [successContainer]'s `#F0FDF4`/`#16A34A`.
  static const Color availableContainer = Color(0xFFECFDF5);
  static const Color availableOnContainer = Color(0xFF10B981);

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

  /// Saved empty-state icon circle gradient end (Figma `242:2576`): `#E0E7FF`,
  /// with `#EFF6FF` (=[primaryContainer]) as the start.
  static const Color savedIconGradientEnd = Color(0xFFE0E7FF);

  /// Change-password hero lock block gradient end (Figma `270:7299`):
  /// `#DBEAFE`, with `#EFF6FF` (=[primaryContainer]) as the start. Added for
  /// the T037 revamp; the back button instead reuses [surfaceVariant] (the
  /// Figma-exact fill per pull).
  static const Color lockGradientEnd = Color(0xFFDBEAFE);

  /// Home hero header gradient (Figma `95:4028`): `#0F172A` → `#3A1E8B`.
  /// Start equals [AppColors.surfaceInverse].
  static const Color heroGradientStart = Color(0xff0F172A);
  static const Color heroGradientEnd = Color(0xFF1E3A8A);

  /// Pure black base token, e.g. the α0.40 scrim behind the floating
  /// back/close button over listing photos (`shop_detail_pane.dart`).
  static const Color black = Color(0xFF000000);

  /// AI Space Advisor promo card gradient (Figma `95:4028`): `#3A1E8B` →
  /// `#4F8EE6`.
  static const Color promoGradientStart = Color(0xFF1E3A8A);
  static const Color promoGradientEnd = Color(0xFF4F46E5);
}
