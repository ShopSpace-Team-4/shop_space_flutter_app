import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import 'home_section_heading.dart';

/// Categories filter bar (Figma `95:4028`): heading + horizontally scrollable
/// single-select chip row. The active chip is filled with the primary color;
/// the rest use a white fill (`AppColors.surface`) with an outline border and
/// muted text. Chips are rendered as returned by `GET /listings/meta` (English
/// enum categories — localized labels flagged for Phase 3). A leading "All"
/// chip resets the filter. Tapping a chip reports the selection via
/// [onSelected] (`null` = "All"); the parent filters the already-loaded
/// Recommended/Nearby lists in memory — no `/search` deep link, no backend
/// request.
class HomeCategoryChips extends StatelessWidget {
  const HomeCategoryChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HomeSectionHeading(title: l10n.homeCategoriesTitle),
        SizedBox(height: AppSpacing.md.h),
        if (categories.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              l10n.homeEmptyCategories,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          )
        else
          SizedBox(
            height: 32.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: categories.length + 1,
              separatorBuilder: (context, index) => SizedBox(width: 8.w),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _CategoryChip(
                    label: l10n.homeCategoryAll,
                    isActive: selectedCategory == null,
                    onTap: () => onSelected(null),
                  );
                }
                final String category = categories[index - 1];
                final bool isActive = selectedCategory == category;
                return _CategoryChip(
                  label: category,
                  isActive: isActive,
                  onTap: () => onSelected(category),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32.h,
      child: Material(
        color: isActive ? AppColors.primary : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          side: isActive
              ? BorderSide.none
              : const BorderSide(color: AppColors.outline),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Center(
              child: Text(
                label,
                maxLines: 1,
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isActive ? AppColors.onPrimary : AppColors.textMuted,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
