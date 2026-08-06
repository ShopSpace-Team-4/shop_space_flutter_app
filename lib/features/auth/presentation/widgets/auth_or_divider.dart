import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Figma "or" divider between the CTA button and the social sign-in row.
class AuthOrDivider extends StatelessWidget {
  const AuthOrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.surfaceVariant)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
          child: Text(
            l10n.authOr,
            style: AppTypography.caption.copyWith(color: AppColors.textTertiary),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.surfaceVariant)),
      ],
    );
  }
}
