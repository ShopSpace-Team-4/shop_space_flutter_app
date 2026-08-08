import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/listing_status.dart';

/// Renders whatever status the server returned with its localized label and
/// token color (US2/T027). Never derives visibility or validates transitions
/// client-side — it is a pure presentation of [ListingStatus] (FR-011, D4).
/// Fully responsive (screenutil + flex layout).
class ListingStatusBadge extends StatelessWidget {
  const ListingStatusBadge({super.key, required this.status});

  final ListingStatus status;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final (Color background, Color foreground) = switch (status) {
      ListingStatus.pending => (
          AppColors.warningContainer,
          AppColors.warningOnContainer,
        ),
      ListingStatus.available => (
          AppColors.successContainer,
          AppColors.successOnContainer,
        ),
      ListingStatus.rented => (
          AppColors.primaryContainer,
          AppColors.primary,
        ),
      ListingStatus.expired => (
          AppColors.surfaceVariant,
          AppColors.textSecondary,
        ),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm.w,
        vertical: AppSpacing.xs.h,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        _label(l10n),
        style: AppTypography.caption.copyWith(
          color: foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String _label(AppLocalizations l10n) => switch (status) {
        ListingStatus.pending => l10n.statusPending,
        ListingStatus.available => l10n.statusAvailable,
        ListingStatus.rented => l10n.statusRented,
        ListingStatus.expired => l10n.statusExpired,
      };
}
