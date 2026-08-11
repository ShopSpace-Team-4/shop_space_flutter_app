import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Onboarding pill buttons (Figma `92:1871` / `95:2400`).
///
/// Page 1: a full-width primary `Next` with a direction-aware arrow and a
/// `Skip` text button beneath it. Pages 2–3: a secondary `Back` pill beside
/// the primary `Next`/`Let's Go` pill, equally flexed to fill the row
/// (Figma shows Back narrower than the primary; equal flex keeps the pair
/// stable across widths and RTL).
class OnboardingPageButtons extends StatelessWidget {
  const OnboardingPageButtons({
    super.key,
    required this.index,
    required this.nextLabel,
    required this.backLabel,
    required this.skipLabel,
    required this.onNext,
    required this.onBack,
    required this.onSkip,
  });

  final int index;
  final String nextLabel;
  final String backLabel;
  final String skipLabel;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    if (index == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PillButton(primary: true, label: nextLabel, onPressed: onNext),
          SizedBox(height: AppSpacing.sm.h),
          SizedBox(
            height: 44.h,
            child: TextButton(
              onPressed: onSkip,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textTertiary,
              ),
              child: Text(
                skipLabel,
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _PillButton(
            primary: false,
            label: backLabel,
            onPressed: onBack,
          ),
        ),
        SizedBox(width: AppSpacing.sm.w),
        Expanded(
          child: _PillButton(
            primary: true,
            label: nextLabel,
            onPressed: onNext,
          ),
        ),
      ],
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.primary,
    required this.label,
    required this.onPressed,
  });

  final bool primary;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    final Color background =
        primary ? AppColors.primary : AppColors.surfaceVariant;
    final Color foreground =
        primary ? AppColors.onPrimary : AppColors.textPrimary;

    return SizedBox(
      height: 48.h,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: foreground,
              ),
            ),
            if (primary) ...[
              SizedBox(width: 6.w),
              Icon(
                isRtl
                    ? Icons.arrow_back_rounded
                    : Icons.arrow_forward_rounded,
                size: 18.sp,
                color: foreground,
              ),
            ],
          ],
        ),
      ),
    );
  }
}