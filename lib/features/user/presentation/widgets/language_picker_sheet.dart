import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/localization_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Language picker sheet (Settings → Appearance): offers the two app locales
/// (English / العربية) as radio options with the active locale highlighted.
/// Selecting a locale calls [LocalizationCubit.setLocale] (persists via
/// `PreferencesService`) and closes the sheet; the root `BlocBuilder` in
/// `bootstrap.dart` rebuilds the app with the new locale (RTL flip included).
/// Fully responsive (screenutil + flex layout) — mirrors the StatusPickerSheet
/// pattern.
class LanguagePickerSheet extends StatelessWidget {
  const LanguagePickerSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => const LanguagePickerSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final Locale current = context.select<LocalizationCubit, Locale>(
      (cubit) => cubit.state,
    );

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
              l10n.settingsLanguageSheetTitle,
              style: AppTypography.heading4.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.md.h),
            _LanguageOption(
              label: l10n.settingsLanguageEnglish,
              selected: current.languageCode == 'en',
              onTap: () => _select(context, const Locale('en')),
            ),
            SizedBox(height: AppSpacing.sm.h),
            _LanguageOption(
              label: l10n.settingsLanguageArabic,
              selected: current.languageCode == 'ar',
              onTap: () => _select(context, const Locale('ar')),
            ),
          ],
        ),
      ),
    );
  }

  void _select(BuildContext context, Locale locale) {
    final Locale current = context.read<LocalizationCubit>().state;
    Navigator.of(context).pop();
    if (locale == current) return;
    context.read<LocalizationCubit>().setLocale(locale);
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
      title: Text(
        label,
        style: AppTypography.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      onTap: onTap,
    );
  }
}