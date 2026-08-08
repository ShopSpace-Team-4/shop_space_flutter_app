import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../localization/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Shared, breakpoint-aware loading state (renders without overflow at
/// compact/medium/expanded widths). Token-styled, localized, and fully
/// responsive (values scale with screenutil; flex layout adapts).
class AppLoadingView extends StatelessWidget {
  const AppLoadingView({super.key, this.label});

  /// Optional localized label; defaults to the shared loading string.
  final String? label;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 48.r,
              height: 48.r,
              child: const CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              label ?? l10n.loading,
              textAlign: TextAlign.center,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
