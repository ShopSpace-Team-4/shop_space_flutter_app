import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/models/search_filters.dart';

/// Horizontal, horizontally-scrollable row of active-filter chips with a
/// remove affordance per active filter (T021 / US1). Renders nothing when no
/// filters are active. Each chip's delete calls [onChange] with the filters
/// minus that filter; a trailing "Clear all" affordance restores the empty
/// default. Price/size chips are labeled with the locale-aware compact
/// formatter (`Formatters.formatPriceCompact` / `formatArea`).
class FilterChips extends StatelessWidget {
  const FilterChips({
    super.key,
    required this.filters,
    required this.onChange,
  });

  final SearchFilters filters;

  /// Called with the updated filters whenever a chip is removed or "Clear all"
  /// is tapped — the screen forwards it to `SearchCubit.applyFilters`.
  final ValueChanged<SearchFilters> onChange;

  @override
  Widget build(BuildContext context) {
    final List<Widget> chips = _buildChips(context);
    if (chips.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 40.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        children: chips,
      ),
    );
  }

  List<Widget> _buildChips(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final List<Widget> chips = <Widget>[];

    if (filters.city != null) {
      chips.add(_chip(
        context,
        filters.city!,
        () => onChange(filters.copyWith(city: null, district: null)),
      ));
    }
    if (filters.district != null) {
      chips.add(_chip(
        context,
        filters.district!,
        () => onChange(filters.copyWith(district: null)),
      ));
    }
    if (filters.category != null) {
      chips.add(_chip(
        context,
        filters.category!,
        () => onChange(filters.copyWith(category: null)),
      ));
    }
    if (filters.priceMin != null || filters.priceMax != null) {
      chips.add(_chip(
        context,
        _rangeLabel(
          l10n,
          filters.priceMin == null ? null : Formatters.formatPriceCompact(filters.priceMin!, l10n),
          filters.priceMax == null ? null : Formatters.formatPriceCompact(filters.priceMax!, l10n),
        ),
        () => onChange(filters.copyWith(priceMin: null, priceMax: null)),
      ));
    }
    if (filters.areaMin != null || filters.areaMax != null) {
      chips.add(_chip(
        context,
        _rangeLabel(
          l10n,
          filters.areaMin == null ? null : Formatters.formatArea(filters.areaMin!, l10n),
          filters.areaMax == null ? null : Formatters.formatArea(filters.areaMax!, l10n),
        ),
        () => onChange(filters.copyWith(areaMin: null, areaMax: null)),
      ));
    }
    for (final String amenity in filters.amenities) {
      chips.add(_chip(
        context,
        amenity,
        () => onChange(
          filters.copyWith(
            amenities: filters.amenities
                .where((String e) => e != amenity)
                .toList(),
          ),
        ),
      ));
    }

    if (chips.isNotEmpty) {
      chips.add(SizedBox(width: AppSpacing.sm.w));
      chips.add(
        ActionChip(
          onPressed: () => onChange(const SearchFilters()),
          backgroundColor: AppColors.surfaceVariant,
          label: Text(
            l10n.searchClearAll,
            style: AppTypography.caption.copyWith(color: AppColors.textPrimary),
          ),
        ),
      );
    }
    return chips;
  }

  Widget _chip(BuildContext context, String label, VoidCallback onDeleted) {
    return Padding(
      padding: EdgeInsets.only(right: AppSpacing.sm.w),
      child: InputChip(
        label: Text(label),
        labelStyle: AppTypography.caption.copyWith(
          color: AppColors.textPrimary,
        ),
        deleteIcon: Icon(Icons.close, size: 14.sp),
        onDeleted: onDeleted,
        backgroundColor: AppColors.primaryContainer,
        side: BorderSide.none,
      ),
    );
  }

  String _rangeLabel(AppLocalizations l10n, String? min, String? max) {
    if (min != null && max != null) {
      return l10n.searchRange(min, max);
    }
    if (min != null) return l10n.searchFrom(min);
    return l10n.searchTo(max ?? '');
  }
}
