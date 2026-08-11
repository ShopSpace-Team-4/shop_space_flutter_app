import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

/// 3-dot carousel indicator (Figma `92:1867`): the active dot is a `primary`
/// 24×8 pill, inactive dots are 8×8 circles in `outline`. Figma counts the
/// splash as a fourth step; with splash excluded the carousel shows three
/// (flagged deviation).
class OnboardingPageDots extends StatelessWidget {
  const OnboardingPageDots({
    super.key,
    required this.count,
    required this.activeIndex,
  });

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < count; i++) ...[
          if (i > 0) SizedBox(width: AppSpacing.sm.w),
          AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOut,
            width: i == activeIndex ? 24.w : 8.w,
            height: 8.h,
            decoration: BoxDecoration(
              color:
                  i == activeIndex ? AppColors.primary : AppColors.outline,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),
        ],
      ],
    );
  }
}