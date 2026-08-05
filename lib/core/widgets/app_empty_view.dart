import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Shared empty state, token-styled and localized. Used when a surface has
/// no content to show yet.
class AppEmptyView extends StatelessWidget {
  const AppEmptyView({super.key, this.title, this.message});

  /// Optional localized title; defaults to the shared empty-state string.
  final String? title;

  /// Optional localized supporting message.
  final String? message;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.inbox_outlined,
            size: 48,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title ?? l10n.emptyState,
            textAlign: TextAlign.center,
            style: AppTypography.heading4,
          ),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Text(
                message!,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
