import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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
/// enum categories — localized labels flagged for Phase 3). Tapping a chip
/// selects it and deep-links to `/search?category=<value>`.
class HomeCategoryChips extends StatefulWidget {
  const HomeCategoryChips({super.key, required this.categories});

  final List<String> categories;

  @override
  State<HomeCategoryChips> createState() => _HomeCategoryChipsState();
}

class _HomeCategoryChipsState extends State<HomeCategoryChips> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HomeSectionHeading(title: l10n.homeCategoriesTitle),
        SizedBox(height: AppSpacing.md.h),
        if (widget.categories.isEmpty)
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
              itemCount: widget.categories.length,
              separatorBuilder: (context, index) => SizedBox(width: 8.w),
              itemBuilder: (context, index) {
                final String category = widget.categories[index];
                final bool isActive = index == _selectedIndex;
                return _CategoryChip(
                  label: category,
                  isActive: isActive,
                  onTap: () {
                    setState(() => _selectedIndex = index);
                    context.go(
                      '/search?category=${Uri.encodeQueryComponent(category)}',
                    );
                  },
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
