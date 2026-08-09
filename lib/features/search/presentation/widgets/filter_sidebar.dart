import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/search_filter_options.dart';
import '../../data/models/search_filters.dart';
import 'filter_panel.dart';

/// Persistent filter sidebar for the expanded layout (≥840dp, contract
/// `responsive-search-layout.md`). Hosts the same shared [FilterPanel] as the
/// compact/medium bottom sheet (D10 / FR-015) — no filter logic here. Its own
/// column scrolls so long option lists never overflow the region.
class FilterSidebar extends StatelessWidget {
  const FilterSidebar({
    super.key,
    required this.options,
    required this.filters,
    required this.onApply,
  });

  final SearchFilterOptions options;
  final SearchFilters filters;
  final ValueChanged<SearchFilters> onApply;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Container(
      width: 300.w,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.outline)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, AppSpacing.lg.h, 24.w, 8.h),
            child: Text(
              l10n.searchFilters,
              style: AppTypography.heading4,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24.w, 0.h, 24.w, AppSpacing.xl.h),
              child: FilterPanel(
                options: options,
                initialFilters: filters,
                onApply: onApply,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
