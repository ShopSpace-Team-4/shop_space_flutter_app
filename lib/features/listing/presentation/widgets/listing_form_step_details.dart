import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../data/locality_options.dart';
import '../cubits/listing_form_cubit.dart';
import 'listing_form_controllers.dart';

/// Step 1 of the create/edit form — Details (listing-form.md §Steps):
/// title, category (single-select from meta), area, city + district (from the
/// local curated EN/AR list), address and description (both optional). Manual
/// `Form` + custom validators only — NO form package (constitution §Locked).
class ListingFormStepDetails extends StatelessWidget {
  const ListingFormStepDetails({
    super.key,
    required this.cubit,
    required this.controllers,
  });

  final ListingFormCubit cubit;
  final ListingFormControllers controllers;

  static const int maxTitleLength = 80;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FormLabel(l10n.formFieldTitle),
        SizedBox(height: AppSpacing.xs.h),
        TextFormField(
          controller: controllers.title,
          maxLength: maxTitleLength,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (String value) =>
              cubit.updateField(ListingFormFieldKeys.title, value),
          validator: (String? value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.formTitleRequired;
            }
            if (value.trim().length > maxTitleLength) {
              return l10n.formTitleTooLong(maxTitleLength);
            }
            return null;
          },
          decoration: _decoration(hint: l10n.formFieldTitleHint),
        ),
        SizedBox(height: AppSpacing.lg.h),
        _FormLabel(l10n.formFieldCategory),
        SizedBox(height: AppSpacing.xs.h),
        DropdownButtonFormField<String>(
          key: const ValueKey('category'),
          initialValue: _selected(cubit.state, ListingFormFieldKeys.category),
          items: [
            for (final String category in cubit.state.meta?.categories ?? const [])
              DropdownMenuItem(value: category, child: Text(category)),
          ],
          decoration: _decoration(hint: l10n.formCategoryHint),
          onChanged: (String? value) {
            if (value != null) {
              cubit.updateField(ListingFormFieldKeys.category, value);
            }
          },
          validator: (String? value) =>
              (value == null || value.isEmpty) ? l10n.formCategoryRequired : null,
        ),
        SizedBox(height: AppSpacing.lg.h),
        _FormLabel(l10n.formFieldArea),
        SizedBox(height: AppSpacing.xs.h),
        TextFormField(
          controller: controllers.area,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
          onChanged: (String value) =>
              cubit.updateField(ListingFormFieldKeys.areaSqm, value),
          validator: (String? value) {
            final double? area = double.tryParse(value?.trim() ?? '');
            if (value == null || value.trim().isEmpty || area == null) {
              return l10n.formAreaRequired;
            }
            return area > 0 ? null : l10n.formAreaPositive;
          },
          decoration: _decoration(),
        ),
        SizedBox(height: AppSpacing.lg.h),
        _FormLabel(l10n.formFieldCity),
        SizedBox(height: AppSpacing.xs.h),
        DropdownButtonFormField<String>(
          key: const ValueKey('city'),
          initialValue: _selected(cubit.state, ListingFormFieldKeys.city),
          items: [
            for (final String city in LocalityOptions.cities(l10n))
              DropdownMenuItem(value: city, child: Text(city)),
          ],
          decoration: _decoration(hint: l10n.formCityHint),
          onChanged: (String? value) {
            if (value != null) {
              cubit
                ..updateField(ListingFormFieldKeys.city, value)
                ..updateField(ListingFormFieldKeys.district, '');
            }
          },
          validator: (String? value) =>
              (value == null || value.isEmpty) ? l10n.formCityRequired : null,
        ),
        SizedBox(height: AppSpacing.lg.h),
        _FormLabel(l10n.formFieldDistrict),
        SizedBox(height: AppSpacing.xs.h),
        DropdownButtonFormField<String>(
          key: ValueKey<String>(
            'district_${_selected(cubit.state, ListingFormFieldKeys.city) ?? ''}',
          ),
          initialValue: _selected(cubit.state, ListingFormFieldKeys.district),
          items: [
            for (final String district
                in LocalityOptions.districtsFor(
                    l10n,
                    _selected(cubit.state, ListingFormFieldKeys.city) ??
                        ''))
              DropdownMenuItem(value: district, child: Text(district)),
          ],
          decoration: _decoration(hint: l10n.formDistrictHint),
          onChanged: (String? value) {
            if (value != null) {
              cubit.updateField(ListingFormFieldKeys.district, value);
            }
          },
          validator: (String? value) => (value == null || value.isEmpty)
              ? l10n.formDistrictRequired
              : null,
        ),
        SizedBox(height: AppSpacing.lg.h),
        _FormLabel(l10n.formFieldAddress),
        SizedBox(height: AppSpacing.xs.h),
        TextFormField(
          controller: controllers.address,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (String value) =>
              cubit.updateField(ListingFormFieldKeys.address, value),
          decoration: _decoration(),
        ),
        SizedBox(height: AppSpacing.lg.h),
        _FormLabel(l10n.formFieldDescription),
        SizedBox(height: AppSpacing.xs.h),
        TextFormField(
          controller: controllers.description,
          minLines: 3,
          maxLines: 6,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (String value) =>
              cubit.updateField(ListingFormFieldKeys.description, value),
          decoration: _decoration(),
        ),
      ],
    );
  }

  static String? _selected(ListingFormState state, String key) {
    final dynamic value = state.fields[key];
    return value is String && value.isNotEmpty ? value : null;
  }

  InputDecoration _decoration({String? hint}) => InputDecoration(
        hintText: hint,
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
