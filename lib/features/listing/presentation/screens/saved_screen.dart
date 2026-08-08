import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Saved spaces screen (placeholder, per the Phase 0 gap protocol).
///
/// Rendered inside [AppAdaptiveShell]'s Saved tab; the saved-listings
/// feature lands in a later phase. Fully responsive: values scale with
/// screenutil; flex layout adapts at every breakpoint.
class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.savedTitle),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.bookmark_outline,
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
