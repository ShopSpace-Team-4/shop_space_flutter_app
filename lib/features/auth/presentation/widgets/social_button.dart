import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';

/// Social sign-in button (T024, US4): Google icon + localized label, minimum
/// 44dp touch target, optional inline loading spinner. Disabled while
/// [loading] or when [enabled] is false (parent form submitting). Rendered as
/// a white pill with dark text per the Figma auth design.
class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.onPressed,
    this.loading = false,
    this.enabled = true,
  });

  final VoidCallback onPressed;
  final bool loading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool isEnabled = enabled && !loading;

    return SizedBox(
      height: 48.h,
      child: OutlinedButton.icon(
        onPressed: isEnabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          elevation: 0,
        ),
        icon: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : SvgPicture.asset(
                'assets/svgs/google_icon.svg',
                width: 20,
                height: 20,
              ),
        label: Text(
          l10n.authGoogleButton,
          style: AppTypography.bodyMedium.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
