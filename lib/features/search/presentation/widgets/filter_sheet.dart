import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/search_filter_options.dart';
import '../../data/models/search_filters.dart';
import 'filter_panel.dart';

/// Bottom-sheet container for the shared [FilterPanel] (compact/medium only,
/// contract `responsive-search-layout.md`). Hosts NO filter logic — it just
/// gives the panel a sheet scaffold (drag handle, header, scrollable body).
///
/// The screen opens it via `showModalBottomSheet(isScrollControlled: true)`;
/// [onApply] is forwarded straight from the panel.
class FilterSheet extends StatelessWidget {
  const FilterSheet({
    super.key,
    required this.options,
    required this.initialFilters,
    required this.onApply,
  });

  final SearchFilterOptions options;
  final SearchFilters initialFilters;
  final ValueChanged<SearchFilters> onApply;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DragHandle(),
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 4.h, 12.w, 4.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.searchFilters,
                    style: AppTypography.heading4,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: l10n.commonBack,
                  icon: const Icon(Icons.close),
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24.w, 4.h, 24.w, AppSpacing.xl.h),
              child: FilterPanel(
                options: options,
                initialFilters: initialFilters,
                onApply: onApply,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: 40.w,
        height: 4.h,
        margin: EdgeInsets.only(top: AppSpacing.sm.h),
        decoration: BoxDecoration(
          color: AppColors.outlineVariant,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
      ),
    );
  }
}
