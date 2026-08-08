import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../localization/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Shared empty state, token-styled, localized, and fully responsive (values
/// scale with screenutil; flex layout adapts). Used when a surface has no
/// content to show yet.
class AppEmptyView extends StatelessWidget {
  const AppEmptyView({super.key, this.title, this.message});

  /// Optional localized title; defaults to the shared empty-state string.
  final String? title;

  /// Optional localized supporting message.
  final String? message;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 48.sp,
              color: AppColors.textTertiary,
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              title ?? l10n.emptyState,
              textAlign: TextAlign.center,
              style: AppTypography.heading4,
            ),
            if (message != null) ...[
              SizedBox(height: AppSpacing.md.h),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
