import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/search_filters.dart';

/// Sort control (FR-016): newest (default) / price low-to-high / price
/// high-to-low. A compact popup menu that stays usable at every breakpoint.
/// Selecting a sort fires [onChanged] (the screen commits it via
/// `SearchCubit.applyFilters` so it applies to subsequent filter changes);
/// resetting filters restores newest-first. Presentational — no logic here.
class SortControl extends StatelessWidget {
  const SortControl({
    super.key,
    required this.current,
    required this.onChanged,
  });

  /// The current sort; the empty default resolves to [SearchSort.newest].
  final SearchSort current;

  final ValueChanged<SearchSort> onChanged;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return PopupMenuButton<SearchSort>(
      initialValue: current,
      onSelected: onChanged,
      tooltip: l10n.searchFilterSort,
      itemBuilder: (context) => [
        for (final SearchSort sort in SearchSort.values)
          PopupMenuItem<SearchSort>(
            value: sort,
            child: Text(_label(l10n, sort)),
          ),
      ],
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.swap_vert, size: 16.sp, color: AppColors.textSecondary),
            SizedBox(width: 4.w),
            Text(
              _label(l10n, current),
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              size: 18.sp,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  static String _label(AppLocalizations l10n, SearchSort sort) =>
      switch (sort) {
        SearchSort.newest => l10n.searchSortNewest,
        SearchSort.priceAsc => l10n.searchSortPriceAsc,
        SearchSort.priceDesc => l10n.searchSortPriceDesc,
      };
}
