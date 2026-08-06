import 'package:flutter/material.dart';

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
/// surface that fires [onSignIn] to redirect the user.
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
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: AppSpacing.lg),
            Text(
              failureMessage(l10n, failure),
              textAlign: TextAlign.center,
              style: AppTypography.heading4,
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: onRetry,
              child: Text(l10n.retry),
            ),
            if (unauthorized && onSignIn != null) ...[
              const SizedBox(height: AppSpacing.sm),
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
