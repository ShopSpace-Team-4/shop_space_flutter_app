import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Immutable content for one onboarding carousel page (Figma frames
/// `92:1597` / `95:2075` / `95:2406`). The title/subtitle are localized by the
/// screen; the emoji hero and pre-faded image export are visual constants.
class OnboardingPageData {
  const OnboardingPageData({
    required this.imageAsset,
    required this.title,
    required this.subtitle,
  });

  final String imageAsset;
  final String title;
  final String subtitle;
}

/// One onboarding page: a 280-tall hero image export (already baked at 40%
/// opacity per the design's `opacity: 0.4` Image frame — confirmed, so it is
/// rendered at full opacity) with the large emoji centered over it, then the
/// title (`textPrimary`) and subtitle (`textMuted`). Dots/buttons live in the
/// screen, below the carousel.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key, required this.data});

  final OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 280.h,
          width: double.infinity,
          child: Image.asset(data.imageAsset, fit: BoxFit.cover),
        ),
        // Text column below the hero, centered at a capped width on
        // medium/expanded (the auth-screen max-width pattern).
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.xl.w,
              vertical: AppSpacing.xl.h,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: AppTypography.heading3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  Text(
                    data.subtitle,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
