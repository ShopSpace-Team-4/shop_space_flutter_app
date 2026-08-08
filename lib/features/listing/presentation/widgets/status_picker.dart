import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/errors/failure_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/listing_status.dart';

/// Free-form status picker (D4): offers ALL FOUR statuses with no client-side
/// transition validation (the backend is authoritative and may reject a
/// change — surfaced as a localized inline error). Calls [onSelected] with
/// the picked status; a single in-flight guard prevents duplicate taps
/// (FR-014). The parent re-fetches on rejection so the UI converges. Fully
/// responsive (screenutil + flex layout).
class StatusPickerSheet extends StatelessWidget {
  const StatusPickerSheet({
    super.key,
    required this.current,
    this.isSubmitting = false,
    this.failure,
    required this.onSelected,
  });

  final ListingStatus current;
  final bool isSubmitting;
  final Failure? failure;
  final ValueChanged<ListingStatus> onSelected;

  static Future<void> show(
    BuildContext context, {
    required ListingStatus current,
    required bool isSubmitting,
    Failure? failure,
    required ValueChanged<ListingStatus> onSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => StatusPickerSheet(
        current: current,
        isSubmitting: isSubmitting,
        failure: failure,
        onSelected: onSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg.w,
          0,
          AppSpacing.lg.w,
          AppSpacing.xl.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.statusChangeTitle,
              style: AppTypography.heading4.copyWith(color: AppColors.textPrimary),
            ),
            SizedBox(height: AppSpacing.md.h),
            for (final ListingStatus status in ListingStatus.values) ...[
              _StatusOption(
                status: status,
                current: current,
                onTap: isSubmitting
                    ? null
                    : () {
                        // Selecting the already-current status is a no-op —
                        // no redundant PATCH (T062 defensive polish).
                        if (status != current) onSelected(status);
                      },
              ),
              SizedBox(height: AppSpacing.xs.h),
            ],
            if (failure != null) ...[
              SizedBox(height: AppSpacing.sm.h),
              Text(
                failureMessage(l10n, failure!),
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(color: AppColors.error),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusOption extends StatelessWidget {
  const _StatusOption({
    required this.status,
    required this.current,
    required this.onTap,
  });

  final ListingStatus status;
  final ListingStatus current;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool selected = status == current;

    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.outline,
        ),
      ),
      tileColor: selected ? AppColors.primaryContainer : AppColors.surface,
      leading: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        size: 24.sp,
        color: selected ? AppColors.primary : AppColors.textTertiary,
      ),
      title: Text(_label(l10n)),
      onTap: onTap,
    );
  }

  String _label(AppLocalizations l10n) => switch (status) {
        ListingStatus.pending => l10n.statusPending,
        ListingStatus.available => l10n.statusAvailable,
        ListingStatus.rented => l10n.statusRented,
        ListingStatus.expired => l10n.statusExpired,
      };
}
