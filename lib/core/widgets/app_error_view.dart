import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../errors/failure_messages.dart';
import '../errors/failures.dart';
import '../localization/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Shared error state with a localized message and a manual Retry action.
///
/// Recovery is user-triggered (FR-011). The offline variant renders a
/// localized offline message; the unauthorized variant renders a sign-in
/// surface that fires [onSignIn] to redirect the user. All values scale with
/// screenutil; flex layout adapts at every breakpoint.
class AppErrorView extends StatelessWidget {
  const AppErrorView({
    super.key,
    required this.failure,
    required this.onRetry,
    this.onSignIn,
  });

  /// The typed failure driving the message, icon and variant.
  final Failure failure;

  /// Invoked when the user taps Retry.
  final VoidCallback onRetry;

  /// Invoked when an unauthorized failure's sign-in surface is tapped.
  final VoidCallback? onSignIn;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool unauthorized = failure is UnauthorizedFailure;

    final IconData icon = switch (failure) {
      OfflineFailure() => Icons.wifi_off_outlined,
      UnauthorizedFailure() => Icons.lock_outline,
      _ => Icons.error_outline,
    };
    final Color color = switch (failure) {
      OfflineFailure() => AppColors.warning,
      _ => AppColors.error,
    };

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48.sp, color: color),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              failureMessage(l10n, failure),
              textAlign: TextAlign.center,
              style: AppTypography.heading4,
            ),
            SizedBox(height: AppSpacing.xl.h),
            FilledButton(
              onPressed: onRetry,
              child: Text(l10n.retry),
            ),
            if (unauthorized && onSignIn != null) ...[
              SizedBox(height: AppSpacing.sm.h),
              TextButton(
                onPressed: onSignIn,
                child: Text(l10n.authLogin),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
