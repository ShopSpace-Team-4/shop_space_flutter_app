import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Chat header (Figma `97:6459`/`97:6467`): gradient bar
/// `AppColors.heroGradientStart → heroGradientEnd`, a RTL-aware back button
/// (`97:6460`, tooltip `commonBack`), the 34×34 avatar bubble (`97:6463`),
/// the white `advisorTitle`, and the white-50% `advisorStatus` line.
class AdvisorChatHeader extends StatelessWidget {
  const AdvisorChatHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.heroGradientStart, AppColors.heroGradientEnd],
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.sm.w,
        AppSpacing.md.h,
        AppSpacing.md.w,
        AppSpacing.md.h,
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              onPressed: () => context.pop(),
              tooltip: l10n.commonBack,
              icon: Icon(
                isRtl ? Icons.arrow_forward : Icons.arrow_back,
                size: 24.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: AppSpacing.sm.w),
            const _HeaderAvatar(),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.advisorTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textInverse,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    l10n.advisorStatus,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textInverse.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderAvatar extends StatelessWidget {
  const _HeaderAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34.r,
      height: 34.r,
      decoration: BoxDecoration(
        color: AppColors.textInverse.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.medium.r),
        border: Border.all(color: AppColors.textInverse.withValues(alpha: 0.5)),
      ),
      child: Icon(
        Icons.auto_awesome,
        size: 18.sp,
        color: AppColors.textInverse,
      ),
    );
  }
}
