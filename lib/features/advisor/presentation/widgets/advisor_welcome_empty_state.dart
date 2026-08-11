import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Empty-conversation welcome (Figma `97:6473` + `97:6481`): the welcome row
/// (28×28 gradient avatar + the white `advisorWelcome` bubble), the
/// `advisorTryAsking` label, and 4 suggested-question buttons wired to send.
///
/// FLAGGED gap: the Figma welcome-avatar gradient ends at `#6366F1`, which is
/// NOT an existing token — `AppColors.promoGradientEnd` (`#4F46E5`) is used
/// instead (0.05 delta from the source).
class AdvisorWelcomeEmptyState extends StatelessWidget {
  const AdvisorWelcomeEmptyState({super.key, required this.onAsk});

  final ValueChanged<String> onAsk;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.lg.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _WelcomeAvatar(),
              SizedBox(width: AppSpacing.sm.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(AppSpacing.lg.r),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.medium.r),
                    border: Border.all(color: AppColors.outline),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0F000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    l10n.advisorWelcome,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xl.h),
          Text(
            l10n.advisorTryAsking,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          SizedBox(height: AppSpacing.md.h),
          for (final String question in _exampleQuestions(l10n)) ...[
            _SuggestionButton(question: question, onTap: () => onAsk(question)),
            SizedBox(height: AppSpacing.md.h),
          ],
        ],
      ),
    );
  }

  List<String> _exampleQuestions(AppLocalizations l10n) => [
        l10n.advisorExampleQuestion1,
        l10n.advisorExampleQuestion2,
        l10n.advisorExampleQuestion3,
        l10n.advisorExampleQuestion4,
      ];
}

class _WelcomeAvatar extends StatelessWidget {
  const _WelcomeAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28.r,
      height: 28.r,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.promoGradientEnd],
        ),
        borderRadius: BorderRadius.circular(AppRadius.field.r),
      ),
      child: Icon(
        Icons.auto_awesome,
        size: 15.sp,
        color: AppColors.textInverse,
      ),
    );
  }
}

class _SuggestionButton extends StatelessWidget {
  const _SuggestionButton({required this.question, required this.onTap});

  final String question;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.medium.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.medium.r),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg.w,
            vertical: AppSpacing.sm.h,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.medium.r),
            border: Border.all(color: AppColors.outline),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  question,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.sm.w),
              Icon(
                isRtl ? Icons.arrow_back : Icons.arrow_forward,
                size: 16.sp,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
