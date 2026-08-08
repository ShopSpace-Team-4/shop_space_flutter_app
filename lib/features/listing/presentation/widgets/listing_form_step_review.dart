import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../cubits/listing_form_cubit.dart';
import 'amenity_label.dart';
import 'listing_form_controllers.dart';

/// Step 4 of the create/edit form — Review & Submit (listing-form.md §Steps).
/// Renders every entered field from [ListingFormState.fields] plus the photo
/// outcome and the VAT-inclusive rent tenants see (FR-008). Edit mode shows
/// the staged media diff (used in US3). Fully responsive (screenutil + flex).
class ListingFormStepReview extends StatelessWidget {
  const ListingFormStepReview({
    super.key,
    required this.cubit,
    required this.controllers,
  });

  final ListingFormCubit cubit;
  final ListingFormControllers controllers;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final Map<String, dynamic> fields = cubit.state.fields;

    final List<(String, String)> rows = [
      (
        l10n.formFieldTitle,
        _text(fields, ListingFormFieldKeys.title),
      ),
      (
        l10n.formFieldCategory,
        _text(fields, ListingFormFieldKeys.category),
      ),
      (
        l10n.formFieldArea,
        '${_text(fields, ListingFormFieldKeys.areaSqm)} m²',
      ),
      (
        l10n.formFieldCity,
        _text(fields, ListingFormFieldKeys.city),
      ),
      (
        l10n.formFieldDistrict,
        _text(fields, ListingFormFieldKeys.district),
      ),
      if (_text(fields, ListingFormFieldKeys.address).isNotEmpty)
        (l10n.formFieldAddress, _text(fields, ListingFormFieldKeys.address)),
      if (_text(fields, ListingFormFieldKeys.description).isNotEmpty)
        (
          l10n.formFieldDescription,
          _text(fields, ListingFormFieldKeys.description),
        ),
      if (_text(fields, ListingFormFieldKeys.numberOfFloors).isNotEmpty)
        (
          l10n.formFieldFloors,
          _text(fields, ListingFormFieldKeys.numberOfFloors),
        ),
      (
        l10n.formFieldFloorNumber,
        _floorNumber(l10n, fields),
      ),
      if (_text(fields, ListingFormFieldKeys.availableFrom).isNotEmpty)
        (
          l10n.formFieldAvailableFrom,
          _text(fields, ListingFormFieldKeys.availableFrom),
        ),
      if (_text(fields, ListingFormFieldKeys.minimumLeaseTerm).isNotEmpty)
        (
          l10n.formFieldMinimumLease,
          _text(fields, ListingFormFieldKeys.minimumLeaseTerm),
        ),
      (
        l10n.formFieldAnnualRent,
        '${_text(fields, ListingFormFieldKeys.annualRent)} EGP',
      ),
      if (_text(fields, ListingFormFieldKeys.securityDepositMonths).isNotEmpty)
        (
          l10n.formFieldSecurityDeposit,
          _text(fields, ListingFormFieldKeys.securityDepositMonths),
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.formStepReview,
          style: AppTypography.heading4.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: AppSpacing.lg.h),
        for (final (String label, String value) in rows)
          Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.md.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    label,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.md.w),
                Expanded(
                  flex: 3,
                  child: Text(
                    value,
                    textAlign: TextAlign.end,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (_amenities(fields).isNotEmpty) ...[
          SizedBox(height: AppSpacing.sm.h),
          Text(
            l10n.formFieldAmenities,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          SizedBox(height: AppSpacing.xs.h),
          Wrap(
            spacing: AppSpacing.sm.w,
            runSpacing: AppSpacing.sm.h,
            children: [
              for (final String amenity in _amenities(fields))
                _Chip(label: amenityLabel(l10n, amenity)),
            ],
          ),
        ],
        SizedBox(height: AppSpacing.lg.h),
        _VatRow(l10n: l10n, fields: fields),
        SizedBox(height: AppSpacing.lg.h),
        _PhotoOutcome(l10n: l10n, cubit: cubit),
      ],
    );
  }

  static String _text(Map<String, dynamic> fields, String key) {
    final dynamic value = fields[key];
    return value == null ? '' : value.toString();
  }

  static String _floorNumber(AppLocalizations l10n, Map<String, dynamic> fields) {
    final int? floor = int.tryParse(_text(fields, ListingFormFieldKeys.floorNumber));
    return floor == null || floor == 0 ? l10n.detailGround : '$floor';
  }

  static List<String> _amenities(Map<String, dynamic> fields) {
    final dynamic value = fields[ListingFormFieldKeys.amenities];
    return value is List ? value.cast<String>() : const [];
  }
}

class _VatRow extends StatelessWidget {
  const _VatRow({required this.l10n, required this.fields});

  final AppLocalizations l10n;
  final Map<String, dynamic> fields;

  @override
  Widget build(BuildContext context) {
    final double? rent =
        double.tryParse(ListingFormStepReview._text(fields, ListingFormFieldKeys.annualRent));
    if (rent == null || rent <= 0) return const SizedBox.shrink();
    final double withVat = rent * 1.15;
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg.r),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              l10n.formVatPreview,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.sm.w),
          Text(
            '${withVat.toStringAsFixed(0)} EGP',
            textAlign: TextAlign.end,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoOutcome extends StatelessWidget {
  const _PhotoOutcome({required this.l10n, required this.cubit});

  final AppLocalizations l10n;
  final ListingFormCubit cubit;

  @override
  Widget build(BuildContext context) {
    final ListingFormState state = cubit.state;
    if (!state.isEditMode) {
      final int count = state.pendingAdds.length;
      return Row(
        children: [
          Icon(Icons.photo_library_outlined,
              size: 20.sp, color: AppColors.textMuted),
          SizedBox(width: AppSpacing.sm.w),
          Expanded(
            child: Text(
              l10n.formPhotoCount(count),
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      );
    }

    final int kept = state.existingMedia.length - state.pendingDeletes.length;
    final int added = state.pendingAdds.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DiffRow(
          icon: Icons.photo_library_outlined,
          label: l10n.formPhotoCount(kept + added),
        ),
        if (added > 0) ...[
          SizedBox(height: AppSpacing.sm.h),
          _DiffRow(
            icon: Icons.add_circle_outline,
            label: '$added ${l10n.formPhotoNew}',
            color: AppColors.successOnContainer,
          ),
        ],
        if (state.pendingDeletes.isNotEmpty) ...[
          SizedBox(height: AppSpacing.sm.h),
          _DiffRow(
            icon: Icons.remove_circle_outline,
            label:
                '${state.pendingDeletes.length} ${l10n.formPhotoRemoved}',
            color: AppColors.errorOnContainer,
          ),
        ],
      ],
    );
  }
}

class _DiffRow extends StatelessWidget {
  const _DiffRow({
    required this.icon,
    required this.label,
    this.color = AppColors.textMuted,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: color),
        SizedBox(width: AppSpacing.sm.w),
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodyMedium.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md.w,
        vertical: AppSpacing.sm.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}
