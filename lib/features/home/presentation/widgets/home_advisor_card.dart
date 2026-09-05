import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// AI Space Advisor promo card (Figma `95:4028`): `#3A1E8B → #4F8EE6`
/// gradient, white icon bubble, 2-line copy and a RTL-aware chevron. Tap opens
/// the `/advisor` route.
class HomeAdvisorCard extends StatelessWidget {
  const HomeAdvisorCard({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.large.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/advisor'),
        child: Ink(
          width: double.infinity,
          height: 81.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.promoGradientStart, AppColors.promoGradientEnd],
            ),
            borderRadius: BorderRadius.circular(AppRadius.large.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg.w,
              vertical: AppSpacing.md.h,
            ),
            child: Row(
              children: [
                const _IconBubble(),
                SizedBox(width: AppSpacing.md.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.homeAdvisorTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.textInverse,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Flexible(
                        child: Text(
                          l10n.homeAdvisorSubtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textInverse.withValues(alpha: 0.85),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppSpacing.sm.w),
                Icon(
                  isRtl ? Icons.chevron_left : Icons.chevron_right,
                  size: 16.w,
                  color: AppColors.textInverse,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38.r,
      height: 38.r,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.medium.r),
      ),
      child: Icon(
        Icons.auto_awesome,
        size: 20.sp,
        color: AppColors.promoGradientStart,
      ),
    );
  }
}
