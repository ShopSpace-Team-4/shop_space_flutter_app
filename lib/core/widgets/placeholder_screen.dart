import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../localization/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Shared placeholder for not-yet-implemented feature routes (Phase 0).
///
/// Rendered by [AppRouter] for every planned feature route until its phase
/// ships real UI. Token-styled, localized, and fully responsive (all values
/// scale with screenutil; flex layout never overflows).
class AppPlaceholderScreen extends StatelessWidget {
  const AppPlaceholderScreen({super.key, required this.title});

  /// Localized title shown in the app bar.
  final String title;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.construction_outlined,
                size: 48.sp,
                color: AppColors.textTertiary,
              ),
              SizedBox(height: AppSpacing.lg.h),
              Text(
                l10n.comingSoon,
                textAlign: TextAlign.center,
                style: AppTypography.heading3,
              ),
              SizedBox(height: AppSpacing.md.h),
              Text(
                l10n.placeholderBody,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
