import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Always-on "informational only" banner under every assistant answer (D9,
/// FR-003). Copy = the backend `disclaimer` when non-empty, else the fixed
/// localized `advisorDisclaimer` fallback. Styled with `AppColors.surfaceVariant`
/// + `textSecondary` at caption scale.
class DisclaimerBanner extends StatelessWidget {
  const DisclaimerBanner({super.key, this.disclaimer});

  final String? disclaimer;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String copy = (disclaimer == null || disclaimer!.isEmpty)
        ? l10n.advisorDisclaimer
        : disclaimer!;

    return Container(
      padding: EdgeInsets.all(AppSpacing.md.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.medium.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 14.sp,
            color: AppColors.textSecondary,
          ),
          SizedBox(width: AppSpacing.sm.w),
          Expanded(
            child: Text(
              copy,
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
