import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../cubits/listing_form_cubit.dart';
import 'listing_form_controllers.dart';

/// Step 3 of the create/edit form — Price & lease (listing-form.md §Steps,
/// FR-008). Floor count (required int), floor number (0 = ground → "Ground"
/// in EN/AR), available-from date picker (submitted `YYYY-MM-DD`), minimum
/// lease term (free text), annual rent (> 0) with a display-only VAT preview
/// (×1.15, never submitted), fixed read-only currency "EGP", and security
/// deposit in whole months (required).
class ListingFormStepPrice extends StatelessWidget {
  const ListingFormStepPrice({
    super.key,
    required this.cubit,
    required this.controllers,
  });

  final ListingFormCubit cubit;
  final ListingFormControllers controllers;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String? availableFrom =
        _string(cubit.state, ListingFormFieldKeys.availableFrom);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FormLabel(l10n.formFieldFloors),
        SizedBox(height: AppSpacing.xs.h),
        TextFormField(
          controller: controllers.numberOfFloors,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          onChanged: (String value) =>
              cubit.updateField(ListingFormFieldKeys.numberOfFloors, value),
          validator: (String? value) {
            final int? floors = int.tryParse(value?.trim() ?? '');
            if (value == null ||
                value.trim().isEmpty ||
                floors == null ||
                floors <= 0) {
              return l10n.formFloorsRequired;
            }
            return null;
          },
          decoration: _decoration(),
        ),
        SizedBox(height: AppSpacing.lg.h),
        _FormLabel(l10n.formFieldFloorNumber),
        SizedBox(height: AppSpacing.xs.h),
        TextFormField(
          controller: controllers.floorNumber,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          onChanged: (String value) =>
              cubit.updateField(ListingFormFieldKeys.floorNumber, value),
          validator: (String? value) {
            final int? floor = int.tryParse(value?.trim() ?? '');
            if (value == null || value.trim().isEmpty || floor == null) {
              return l10n.formFloorRequired;
            }
            return null;
          },
          decoration: _decoration(hint: l10n.detailGround),
        ),
        SizedBox(height: AppSpacing.lg.h),
        _FormLabel(l10n.formFieldAvailableFrom),
        SizedBox(height: AppSpacing.xs.h),
        FormField<String>(
          initialValue: availableFrom,
          validator: (String? value) => (value == null || value.isEmpty)
              ? l10n.formAvailableFromRequired
              : null,
          builder: (FormFieldState<String> fieldState) {
            final String value = fieldState.value ?? '';
            return InkWell(
              onTap: () => _pickDate(context, availableFrom,
                  onPicked: fieldState.didChange),
              borderRadius: BorderRadius.circular(AppRadius.field),
              child: InputDecorator(
                decoration: _decoration(errorText: fieldState.errorText),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        size: 18.sp, color: AppColors.textTertiary),
                    SizedBox(width: AppSpacing.sm.w),
                    Expanded(
                      child: Text(
                        value.isEmpty ? l10n.formAvailableFromRequired : value,
                        style: AppTypography.bodyMedium.copyWith(
                          color: value.isEmpty
                              ? AppColors.textTertiary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        SizedBox(height: AppSpacing.lg.h),
        _FormLabel(l10n.formFieldMinimumLease),
        SizedBox(height: AppSpacing.xs.h),
        TextFormField(
          controller: controllers.minimumLeaseTerm,
          textInputAction: TextInputAction.next,
          onChanged: (String value) =>
              cubit.updateField(ListingFormFieldKeys.minimumLeaseTerm, value),
          validator: (String? value) =>
              (value == null || value.trim().isEmpty)
                  ? l10n.formMinimumLeaseRequired
                  : null,
          decoration: _decoration(),
        ),
        SizedBox(height: AppSpacing.lg.h),
        _FormLabel(l10n.formFieldAnnualRent),
        SizedBox(height: AppSpacing.xs.h),
        TextFormField(
          controller: controllers.annualRent,
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
          onChanged: (String value) =>
              cubit.updateField(ListingFormFieldKeys.annualRent, value),
          validator: (String? value) {
            final double? rent = double.tryParse(value?.trim() ?? '');
            if (value == null || value.trim().isEmpty || rent == null) {
              return l10n.formRentRequired;
            }
            return rent > 0 ? null : l10n.formRentPositive;
          },
          decoration: _decoration(),
        ),
        SizedBox(height: AppSpacing.sm.h),
        _VatPreview(annualRent: controllers.annualRent.text),
        SizedBox(height: AppSpacing.lg.h),
        _FormLabel(l10n.formCurrencyLabel),
        SizedBox(height: AppSpacing.xs.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppRadius.field),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.formCurrencyLabel,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                'EGP',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.lg.h),
        _FormLabel(l10n.formFieldSecurityDeposit),
        SizedBox(height: AppSpacing.xs.h),
        TextFormField(
          controller: controllers.securityDepositMonths,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          onChanged: (String value) =>
              cubit.updateField(ListingFormFieldKeys.securityDepositMonths, value),
          validator: (String? value) {
            final int? months = int.tryParse(value?.trim() ?? '');
            if (value == null ||
                value.trim().isEmpty ||
                months == null ||
                months <= 0) {
              return l10n.formSecurityDepositRequired;
            }
            return null;
          },
          decoration: _decoration(),
        ),
      ],
    );
  }

  Future<void> _pickDate(
    BuildContext context,
    String? current, {
    ValueChanged<String>? onPicked,
  }) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _parseDate(current) ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      helpText: l10n.formFieldAvailableFrom,
    );
    if (picked == null) return;
    final String serialized = picked.toIso8601String().split('T').first;
    cubit.updateField(ListingFormFieldKeys.availableFrom, serialized);
    onPicked?.call(serialized);
  }

  static DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  static String? _string(ListingFormState state, String key) {
    final dynamic value = state.fields[key];
    return value is String ? value : null;
  }

  InputDecoration _decoration({String? hint, String? errorText}) =>
      InputDecoration(
        hintText: hint,
        errorText: errorText,
        filled: true,
        fillColor: AppColors.surfaceVariant,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 12.h,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.field),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.field),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.field),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.field),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        errorStyle: AppTypography.caption.copyWith(color: AppColors.error),
      );
}

class _VatPreview extends StatelessWidget {
  const _VatPreview({required this.annualRent});

  final String annualRent;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final double? rent = double.tryParse(annualRent.trim());
    if (rent == null || rent <= 0) return const SizedBox.shrink();
    final double withVat = rent * 1.15;
    return Row(
      children: [
        Icon(Icons.info_outline, size: 16.h, color: AppColors.textMuted),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '${l10n.formVatPreview}: ${withVat.toStringAsFixed(0)} EGP',
          style: AppTypography.caption.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }
}

class _FormLabel extends StatelessWidget {
  const _FormLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.caption.copyWith(
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textMuted,
        letterSpacing: 0.4,
      ),
    );
  }
}
