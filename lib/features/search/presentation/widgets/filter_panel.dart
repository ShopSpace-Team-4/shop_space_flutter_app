import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/search_filter_options.dart';
import '../../data/models/search_filters.dart';

/// The ONE filter widget tree shared by the bottom sheet (compact/medium) and
/// the persistent sidebar (expanded) — contract `responsive-search-layout.md`
/// FR-015, D10. It edits a **local draft** [SearchFilters] and only commits on
/// "Apply"; "Reset" restores the empty default (newest-first).
///
/// Validation (data-model §1.1 / FR-002): `priceMax > priceMin` and
/// `areaMax > areaMin` when both are set, and no negative values — reported as
/// localized inline errors. All controls scale with screenutil and use flex
/// layout.
class FilterPanel extends StatefulWidget {
  const FilterPanel({
    super.key,
    required this.options,
    required this.initialFilters,
    required this.onApply,
  });

  /// Filter option sources (categories/amenities/cities) loaded by the cubit.
  final SearchFilterOptions options;

  /// The currently committed filters — the draft is initialized from this.
  final SearchFilters initialFilters;

  /// Called with the committed filters when the user taps "Apply" (or "Reset",
  /// which commits the empty default). The caller owns debounce + fetch.
  final ValueChanged<SearchFilters> onApply;

  @override
  State<FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<FilterPanel> {
  late SearchFilters _draft;

  final TextEditingController _priceMin = TextEditingController();
  final TextEditingController _priceMax = TextEditingController();
  final TextEditingController _areaMin = TextEditingController();
  final TextEditingController _areaMax = TextEditingController();

  String? _priceRangeError;
  String? _areaRangeError;

  @override
  void initState() {
    super.initState();
    _draft = widget.initialFilters;
    _priceMin.text = _fieldText(_draft.priceMin);
    _priceMax.text = _fieldText(_draft.priceMax);
    _areaMin.text = _fieldText(_draft.areaMin);
    _areaMax.text = _fieldText(_draft.areaMax);
  }

  @override
  void didUpdateWidget(FilterPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Committed filters changed externally (e.g. a chip removed a filter):
    // re-seed the draft so the panel never shows stale state.
    if (oldWidget.initialFilters != widget.initialFilters) {
      _draft = widget.initialFilters;
      _priceMin.text = _fieldText(_draft.priceMin);
      _priceMax.text = _fieldText(_draft.priceMax);
      _areaMin.text = _fieldText(_draft.areaMin);
      _areaMax.text = _fieldText(_draft.areaMax);
    }
  }

  @override
  void dispose() {
    _priceMin.dispose();
    _priceMax.dispose();
    _areaMin.dispose();
    _areaMax.dispose();
    super.dispose();
  }

  static String _fieldText(double? value) =>
      value == null ? '' : value.toStringAsFixed(0);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final List<String> districts = _draft.city == null
        ? const <String>[]
        : widget.options.districtsFor(_draft.city!, l10n);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel(l10n.searchFilterSort),
        SizedBox(height: AppSpacing.sm.h),
        _buildSortDropdown(l10n),
        SizedBox(height: AppSpacing.lg.h),
        _SectionLabel(l10n.searchFilterCity),
        SizedBox(height: AppSpacing.sm.h),
        _DropdownField<String>(
          value: _draft.city,
          hint: l10n.formCityHint,
          items: _menuItems(widget.options.cities),
          onChanged: (value) => setState(() {
            _draft = _draft.copyWith(city: value, district: null);
          }),
        ),
        SizedBox(height: AppSpacing.md.h),
        _SectionLabel(l10n.searchFilterDistrict),
        SizedBox(height: AppSpacing.sm.h),
        _DropdownField<String>(
          value: _draft.district,
          hint: l10n.formDistrictHint,
          items: _menuItems(districts),
          enabled: _draft.city != null && districts.isNotEmpty,
          onChanged: (value) => setState(() {
            _draft = _draft.copyWith(district: value);
          }),
        ),
        SizedBox(height: AppSpacing.lg.h),
        _SectionLabel(l10n.searchFilterCategory),
        SizedBox(height: AppSpacing.sm.h),
        _DropdownField<String>(
          value: _draft.category,
          hint: l10n.formCategoryHint,
          items: _menuItems(widget.options.categories),
          onChanged: (value) => setState(() {
            _draft = _draft.copyWith(category: value);
          }),
        ),
        SizedBox(height: AppSpacing.lg.h),
        _RangeInput(
          title: l10n.searchFilterPriceRange,
          minLabel: l10n.searchPriceMinLabel,
          maxLabel: l10n.searchPriceMaxLabel,
          minController: _priceMin,
          maxController: _priceMax,
          error: _priceRangeError,
          onChanged: () => setState(() => _priceRangeError = null),
        ),
        SizedBox(height: AppSpacing.lg.h),
        _RangeInput(
          title: l10n.searchFilterSizeRange,
          minLabel: l10n.searchAreaMinLabel,
          maxLabel: l10n.searchAreaMaxLabel,
          minController: _areaMin,
          maxController: _areaMax,
          error: _areaRangeError,
          onChanged: () => setState(() => _areaRangeError = null),
        ),
        SizedBox(height: AppSpacing.lg.h),
        _SectionLabel(l10n.searchFilterAmenities),
        SizedBox(height: AppSpacing.sm.h),
        Wrap(
          spacing: AppSpacing.sm.w,
          runSpacing: AppSpacing.sm.h,
          children: [
            for (final String amenity in widget.options.amenities)
              FilterChip(
                label: Text(amenity),
                selected: _draft.amenities.contains(amenity),
                selectedColor: AppColors.primaryContainer,
                checkmarkColor: AppColors.primary,
                labelStyle: AppTypography.bodySmall,
                onSelected: (_) => setState(() {
                  _draft = _draft.copyWith(
                    amenities: _draft.amenities.contains(amenity)
                        ? _draft.amenities
                              .where((String e) => e != amenity)
                              .toList()
                        : [..._draft.amenities, amenity],
                  );
                }),
              ),
          ],
        ),
        SizedBox(height: AppSpacing.xl.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _reset,
                child: Text(l10n.searchReset),
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: FilledButton(
                onPressed: _apply,
                child: Text(l10n.searchApply),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSortDropdown(AppLocalizations l10n) {
    return _DropdownField<SearchSort>(
      value: SearchSort.fromWire(_draft.sort),
      hint: l10n.searchFilterSort,
      items: [
        for (final SearchSort sort in SearchSort.values)
          DropdownMenuItem<SearchSort>(
            value: sort,
            child: Text(_sortLabel(l10n, sort)),
          ),
      ],
      onChanged: (value) => setState(() {
        _draft = _draft.copyWith(sort: value?.wire);
      }),
    );
  }

  static String _sortLabel(AppLocalizations l10n, SearchSort sort) =>
      switch (sort) {
        SearchSort.newest => l10n.searchSortNewest,
        SearchSort.priceAsc => l10n.searchSortPriceAsc,
        SearchSort.priceDesc => l10n.searchSortPriceDesc,
      };

  List<DropdownMenuItem<String>> _menuItems(List<String> values) => [
        for (final String value in values)
          DropdownMenuItem<String>(
            value: value,
            child: Text(value, overflow: TextOverflow.ellipsis),
          ),
      ];

  void _reset() {
    setState(() {
      _draft = const SearchFilters();
      _priceMin.text = '';
      _priceMax.text = '';
      _areaMin.text = '';
      _areaMax.text = '';
      _priceRangeError = null;
      _areaRangeError = null;
    });
    widget.onApply(const SearchFilters());
  }

  void _apply() {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final double? priceMin = _parse(_priceMin.text);
    final double? priceMax = _parse(_priceMax.text);
    final double? areaMin = _parse(_areaMin.text);
    final double? areaMax = _parse(_areaMax.text);

    final bool anyNegative = (priceMin ?? 0) < 0 ||
        (priceMax ?? 0) < 0 ||
        (areaMin ?? 0) < 0 ||
        (areaMax ?? 0) < 0;
    if (anyNegative) {
      setState(() {
        _priceRangeError = l10n.searchValueNegative;
        _areaRangeError = l10n.searchValueNegative;
      });
      return;
    }
    if (priceMin != null && priceMax != null && priceMax <= priceMin) {
      setState(() => _priceRangeError = l10n.searchPriceRangeInvalid);
      return;
    }
    if (areaMin != null && areaMax != null && areaMax <= areaMin) {
      setState(() => _areaRangeError = l10n.searchAreaRangeInvalid);
      return;
    }

    widget.onApply(_draft.copyWith(
      priceMin: priceMin,
      priceMax: priceMax,
      areaMin: areaMin,
      areaMax: areaMax,
    ));
  }

  double? _parse(String text) {
    final String trimmed = text.trim();
    if (trimmed.isEmpty) return null;
    return double.tryParse(trimmed);
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.bodySmall.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  const _DropdownField({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.enabled = true,
  });

  final T? value;
  final String hint;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      hint: Text(hint),
      items: items,
      onChanged: enabled ? onChanged : null,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md.w,
          vertical: AppSpacing.md.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.field.r),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.field.r),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
      ),
    );
  }
}

/// A labeled pair of numeric min/max fields with a shared inline error.
class _RangeInput extends StatelessWidget {
  const _RangeInput({
    required this.title,
    required this.minLabel,
    required this.maxLabel,
    required this.minController,
    required this.maxController,
    required this.error,
    required this.onChanged,
  });

  final String title;
  final String minLabel;
  final String maxLabel;
  final TextEditingController minController;
  final TextEditingController maxController;
  final String? error;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel(title),
        SizedBox(height: AppSpacing.sm.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _NumberField(
                label: minLabel,
                controller: minController,
                onChanged: onChanged,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm.w),
              child: Text(
                l10n.searchRangeSeparator,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ),
            Expanded(
              child: _NumberField(
                label: maxLabel,
                controller: maxController,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
        if (error != null) ...[
          SizedBox(height: AppSpacing.xs.h),
          Text(
            error!,
            style: AppTypography.caption.copyWith(color: AppColors.error),
          ),
        ],
      ],
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (_) => onChanged(),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTypography.caption,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md.w,
          vertical: AppSpacing.md.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.field.r),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.field.r),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
      ),
    );
  }
}
