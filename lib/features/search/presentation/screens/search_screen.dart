import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injectable.dart';
import '../../../../core/errors/failure_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/responsive/window_size.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../listing/data/models/browse_listing.dart';
import '../../../listing/data/locality_options.dart';
import '../../../listing/repository/listing_repository.dart';
import '../../../saved/repository/saved_listings_repository.dart';
import '../../data/models/search_filter_options.dart';
import '../../data/models/search_filters.dart';
import '../../data/search_query_resolver.dart';
import '../cubits/listing_detail_cubit.dart';
import '../cubits/search_cubit.dart';
import '../widgets/filter_chips.dart';
import '../widgets/filter_sidebar.dart';
import '../widgets/filter_sheet.dart';
import '../widgets/search_bar_pill.dart';
import '../widgets/search_result_card.dart';
import '../widgets/shop_detail_pane.dart';
import '../widgets/sort_control.dart';

/// Tenant search & discovery screen (US1, Figma phase-3 Search frame): the
/// newest AVAILABLE shops as cards, filterable by city/district, price, size,
/// category and amenities; sortable (newest / price asc / price desc); paginated
/// on scroll with an end-of-list state; skeleton on first load; localized
/// empty/error states with reset/retry actions.
///
/// Layout (contract `responsive-search-layout.md`, D10):
/// - **expanded (≥840dp)**: three-region row = `FilterSidebar` + results list +
///   the tenant detail right pane (US2, T032): "select a shop" placeholder until
///   a card is selected, then `ShopDetailPane` in place — no navigation;
/// - **compact/medium (<840dp)**: full-screen list, a filter button opening
///   `FilterSheet`, and cards pushing `/search/:listingId`.
///
/// All sizes/spacing scale with screenutil; layout structure is chosen only by
/// [breakpointOf].
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.focusRequested = false});

  /// Set when the route is `/search?focus=search` — the home hero pill. The
  /// screen then does a fresh start (clears the bar + resets filters) and
  /// autofocuses the pill once, consuming the flag via `context.go('/search')`.
  final bool focusRequested;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final SearchCubit _cubit;
  final ScrollController _scrollController = ScrollController();
  bool _initialized = false;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  /// Whether a `/search?focus=search` request has already been honored (fresh
  /// start + autofocus + query-flag consumed) so it never repeats on rebuilds.
  bool _focusHandled = false;

  /// The search-bar text that was last resolved against loaded options. Lets
  /// the listener re-apply pending text once options arrive, without loops.
  String? _lastAppliedQuery;

  /// Id of the shop currently shown in the expanded right detail pane
  /// (US2, T032). Null = "select a shop to view details" placeholder.
  String? _selectedListingId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final AppLocalizations l10n = AppLocalizations.of(context);
      _cubit = SearchCubit(
        listingRepository: getIt<ListingRepository>(),
        savedListingsRepository: getIt<SavedListingsRepository>(),
      );
      _cubit.loadOptions(LocalityOptions.cities(l10n));
      _cubit.load();
      _scrollController.addListener(_onScroll);
    }
    _maybeHandleFocusRequest();
  }

  @override
  void didUpdateWidget(SearchScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.focusRequested && widget.focusRequested) {
      _maybeHandleFocusRequest();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _cubit.close();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final ScrollPosition position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200.h) {
      _cubit.loadMore();
    }
  }

  void _openFilterSheet(SearchState state) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => FilterSheet(
        options: state.options!,
        initialFilters: state.filters,
        onApply: (filters) {
          _applyFilters(filters);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _onCardTap(BrowseListing listing) {
    // Expanded → select in the right pane in place (no navigation); compact /
    // medium → push the tenant detail route (D10, T031/T032).
    if (breakpointOf(context) == AppBreakpoint.expanded) {
      setState(() => _selectedListingId = listing.id);
    } else {
      context.push('/search/${listing.id}');
    }
  }

  void _onSortChanged(SearchSort sort) {
    _applyFilters(_cubit.state.filters.copyWith(sort: sort.wire));
  }

  void _maybeHandleFocusRequest() {
    if (!widget.focusRequested || _focusHandled) return;
    _focusHandled = true;
    _searchController.clear();
    _lastAppliedQuery = null;
    _cubit.resetFilters();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _searchFocusNode.requestFocus();
      context.go('/search');
    });
  }

  /// Resolves the bar's text into filter slots and commits the merged filters.
  /// Bar-derived fields override matching chip values while the text is present
  /// (AND composition); price/size/amenities/sort pass through untouched.
  /// Clearing the text resolves to nothing and keeps the current filters.
  void _applySearchText(String text) {
    final SearchFilterOptions? options = _cubit.state.options;
    if (options == null) return;
    _lastAppliedQuery = text;
    final AppLocalizations l10n = AppLocalizations.of(context);
    final SearchQueryResolution resolution = SearchQueryResolver.resolve(
      query: text,
      cities: options.cities,
      districtsFor: (city) => options.districtsFor(city, l10n),
      categories: options.categories,
    );
    final SearchFilters base = _cubit.state.filters;
    final SearchFilters next = base.copyWith(
      city: resolution.city ?? base.city,
      district: resolution.district ?? base.district,
      category: resolution.category ?? base.category,
    );
    if (next == base) return;
    _cubit.applyFilters(next);
  }

  /// Single funnel for every non-bar filter change (chips / sheet / sidebar /
  /// sort). If the change removes or replaces a field the bar currently
  /// drives, the bar clears — the explicit control wins over the bar's
  /// override; price/size/amenities/sort changes never clear the bar.
  void _applyFilters(SearchFilters filters) {
    _clearBarIfConflicting(filters);
    _cubit.applyFilters(filters);
  }

  void _clearBarIfConflicting(SearchFilters incoming) {
    final SearchFilterOptions? options = _cubit.state.options;
    final String text = _searchController.text;
    if (options == null || text.trim().isEmpty) return;
    final AppLocalizations l10n = AppLocalizations.of(context);
    final SearchQueryResolution resolved = SearchQueryResolver.resolve(
      query: text,
      cities: options.cities,
      districtsFor: (city) => options.districtsFor(city, l10n),
      categories: options.categories,
    );
    final bool conflicts =
        (resolved.city != null && incoming.city != resolved.city) ||
            (resolved.district != null &&
                incoming.district != resolved.district) ||
            (resolved.category != null &&
                incoming.category != resolved.category);
    if (!conflicts) return;
    _searchController.clear();
    _lastAppliedQuery = null;
  }

  /// Empty-state / panel reset: clears the bar and restores the empty default
  /// filters (immediate, not debounced).
  void _resetFilters() {
    _searchController.clear();
    _lastAppliedQuery = null;
    _cubit.resetFilters();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool expanded = breakpointOf(context) == AppBreakpoint.expanded;

    return BlocListener<SearchCubit, SearchState>(
      bloc: _cubit,
      listener: (context, state) {
        final Failure? transient = state.transientFailure;
        if (transient != null) {
          final AppLocalizations sheetL10n = AppLocalizations.of(context);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(failureMessage(sheetL10n, transient))),
            );
          _cubit.clearTransientFailure();
        }
        if (state.options != null &&
            _searchController.text.trim().isNotEmpty &&
            _lastAppliedQuery != _searchController.text) {
          _applySearchText(_searchController.text);
        }
      },
      child: BlocBuilder<SearchCubit, SearchState>(
        bloc: _cubit,
        builder: (context, state) {
          if (state.options == null) {
            if (state.optionsFailure != null) {
              return Scaffold(
                appBar: _appBar(expanded: false),
                body: AppErrorView(
                  failure: state.optionsFailure!,
                  onRetry: () =>
                      _cubit.loadOptions(LocalityOptions.cities(l10n)),
                ),
              );
            }
            return Scaffold(
              appBar: _appBar(expanded: false),
              body: const AppLoadingView(),
            );
          }

          if (expanded) {
            return Scaffold(
              body: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilterSidebar(
                    options: state.options!,
                    filters: state.filters,
                    onApply: _applyFilters,
                  ),
                  const VerticalDivider(width: 1, thickness: 1),
                  Expanded(
                    child: _ResultsArea(
                      cubit: _cubit,
                      state: state,
                      scrollController: _scrollController,
                      showTitle: true,
                      selectedId: _selectedListingId,
                      onOpenFilters: () => _openFilterSheet(state),
                      onCardTap: _onCardTap,
                      onSortChanged: _onSortChanged,
                      onApplyFilters: _applyFilters,
                      onResetFilters: _resetFilters,
                      onAskAdvisor: () => context.go('/advisor'),
                      searchController: _searchController,
                      searchFocusNode: _searchFocusNode,
                      onSearchChanged: _applySearchText,
                    ),
                  ),
                  const VerticalDivider(width: 1, thickness: 1),
                  Expanded(
                    child: _selectedListingId == null
                        ? const _ShopDetailPlaceholder()
                        : _ShopDetailRegion(
                            key: ValueKey(_selectedListingId),
                            listingId: _selectedListingId!,
                            onReturnToResults: () =>
                                setState(() => _selectedListingId = null),
                          ),
                  ),
                ],
              ),
            );
          }

          return Scaffold(
            appBar: _appBar(expanded: false, showSearch: true),
            body: _ResultsArea(
              cubit: _cubit,
              state: state,
              scrollController: _scrollController,
              showTitle: false,
              onOpenFilters: () => _openFilterSheet(state),
              onCardTap: _onCardTap,
              onSortChanged: _onSortChanged,
              onApplyFilters: _applyFilters,
              onResetFilters: _resetFilters,
              onAskAdvisor: () => context.go('/advisor'),
              searchController: _searchController,
              searchFocusNode: _searchFocusNode,
              onSearchChanged: _applySearchText,
            ),
          );
        },
      ),
    );
  }

  AppBar _appBar({required bool expanded, bool showSearch = false}) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return AppBar(
      title: showSearch
          ? SearchBarPill(
              controller: _searchController,
              focusNode: _searchFocusNode,
              hint: l10n.searchBarHint,
              clearTooltip: l10n.searchBarClear,
              onChanged: _applySearchText,
            )
          : Text(l10n.searchTitle),
      centerTitle: false,
      actions: [
        if (!expanded)
          IconButton(
            onPressed: () => _openFilterSheet(_cubit.state),
            tooltip: AppLocalizations.of(context).searchOpenFilters,
            icon: const Icon(Icons.tune),
          ),
      ],
    );
  }
}

/// Shared results region: title (expanded only), sort control, active-filter
/// chips, then the list / skeleton / empty / error body. Used by both the
/// compact/medium screen body and the expanded middle region.
class _ResultsArea extends StatelessWidget {
  const _ResultsArea({
    required this.cubit,
    required this.state,
    required this.scrollController,
    required this.showTitle,
    this.selectedId,
    required this.onOpenFilters,
    required this.onCardTap,
    required this.onSortChanged,
    required this.onApplyFilters,
    required this.onResetFilters,
    required this.onAskAdvisor,
    required this.searchController,
    required this.searchFocusNode,
    required this.onSearchChanged,
  });

  final SearchCubit cubit;
  final SearchState state;
  final ScrollController scrollController;
  final bool showTitle;
  final String? selectedId;
  final VoidCallback onOpenFilters;
  final ValueChanged<BrowseListing> onCardTap;
  final ValueChanged<SearchSort> onSortChanged;

  /// Every non-bar filter change funnels through this (chips / empty reset) so
  /// the screen can clear the bar when the explicit change conflicts with it.
  final ValueChanged<SearchFilters> onApplyFilters;
  final VoidCallback onResetFilters;

  /// Opens the AI Space Advisor from the empty state (US5, T029).
  final VoidCallback onAskAdvisor;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 8.h),
          child: Row(
            children: [
              if (showTitle) ...[
                Expanded(
                  child: SearchBarPill(
                    controller: searchController,
                    focusNode: searchFocusNode,
                    hint: l10n.searchBarHint,
                    clearTooltip: l10n.searchBarClear,
                    onChanged: onSearchChanged,
                  ),
                ),
                SizedBox(width: AppSpacing.md.w),
              ] else
                const Spacer(),
              SortControl(
                current: SearchSort.fromWire(state.filters.sort),
                onChanged: onSortChanged,
              ),
            ],
          ),
        ),
        if (state.loaded)
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, AppSpacing.sm.h),
            child: FilterChips(
              filters: state.filters,
              onChange: onApplyFilters,
            ),
          ),
        Expanded(child: _buildBody(l10n)),
      ],
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (state.failure != null) {
      return AppErrorView(failure: state.failure!, onRetry: cubit.load);
    }
    if (state.isLoading && !state.loaded) {
      return _SkeletonList();
    }
    if (state.loaded && state.items.isEmpty) {
      return _EmptySearchView(
        onReset: onResetFilters,
        onAskAdvisor: onAskAdvisor,
      );
    }

    final int footerCount = (state.isLoadingMore || !state.hasMore) ? 1 : 0;
    return ListView.separated(
      controller: scrollController,
      padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, AppSpacing.xl.h),
      itemCount: state.items.length + footerCount,
      separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md.h),
      itemBuilder: (context, index) {
        if (index < state.items.length) {
          final BrowseListing listing = state.items[index];
          return SearchResultCard(
            listing: listing,
            selected: listing.id == selectedId,
            onTap: () => onCardTap(listing),
            onToggleSaved: () => cubit.toggleSaved(listing.id, listing.isSaved == true),
          );
        }
        if (state.isLoadingMore) {
          return const _LoadingMoreIndicator();
        }
        return _EndOfListMarker(label: l10n.searchEndOfList);
      },
    );
  }
}

/// Skeleton placeholder cards rendered from the first frame (FR-006).
class _SkeletonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, AppSpacing.xl.h),
      itemCount: 5,
      separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md.h),
      itemBuilder: (context, index) => const _SkeletonCard(),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        side: const BorderSide(color: AppColors.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 112.w, height: 96.h, color: AppColors.surfaceVariant),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _bar(width: 0.7, height: 12.h),
                  SizedBox(height: AppSpacing.sm.h),
                  _bar(width: 0.45, height: 10.h),
                  SizedBox(height: AppSpacing.lg.h),
                  _bar(width: 0.3, height: 12.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bar({required double width, required double height}) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: width,
      child: Container(height: height, decoration: _barDecoration),
    );
  }

  BoxDecoration get _barDecoration => BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.small.r),
      );
}

class _LoadingMoreIndicator extends StatelessWidget {
  const _LoadingMoreIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg.h),
      child: Center(
        child: SizedBox(
          width: 20.r,
          height: 20.r,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _EndOfListMarker extends StatelessWidget {
  const _EndOfListMarker({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg.h),
      child: Row(
        children: [
          const Expanded(child: Divider(color: AppColors.outline)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
            child: Text(
              label,
              style: AppTypography.caption.copyWith(color: AppColors.textTertiary),
            ),
          ),
          const Expanded(child: Divider(color: AppColors.outline)),
        ],
      ),
    );
  }
}

/// Localized empty state with an advisor entry (US5, T029) and a one-tap
/// reset-filters action (US1 scenario 3). The advisor CTA uses the established
/// `AppEmptyView` + `FilledButton.tonal` pattern; tapping it opens the
/// guarded `/advisor` chat route.
class _EmptySearchView extends StatelessWidget {
  const _EmptySearchView({
    required this.onReset,
    required this.onAskAdvisor,
  });

  final VoidCallback onReset;
  final VoidCallback onAskAdvisor;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppEmptyView(
          title: l10n.searchEmptyTitle,
          message: l10n.searchEmptyMessage,
        ),
        SizedBox(height: AppSpacing.lg.h),
        FilledButton.tonalIcon(
          onPressed: onAskAdvisor,
          icon: Icon(Icons.auto_awesome, size: 18.sp),
          label: Text(l10n.searchAskAdvisor),
        ),
        SizedBox(height: AppSpacing.sm.h),
        FilledButton.tonal(
          onPressed: onReset,
          child: Text(l10n.searchResetFilters),
        ),
      ],
    );
  }
}

/// Expanded-layout right-region detail pane (US2, T032): a fresh
/// [ListingDetailCubit] per selected shop, rendering the same [ShopDetailPane]
/// used by the pushed compact/medium screen (D10). Selecting another card
/// recreates the region via `ValueKey(listingId)`. The "no longer available"
/// state's return-to-results action clears the selection via
/// [onReturnToResults].
class _ShopDetailRegion extends StatefulWidget {
  const _ShopDetailRegion({
    super.key,
    required this.listingId,
    required this.onReturnToResults,
  });

  final String listingId;
  final VoidCallback onReturnToResults;

  @override
  State<_ShopDetailRegion> createState() => _ShopDetailRegionState();
}

class _ShopDetailRegionState extends State<_ShopDetailRegion> {
  late final ListingDetailCubit _cubit;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _cubit = ListingDetailCubit(
      listingRepository: getIt<ListingRepository>(),
      savedListingsRepository: getIt<SavedListingsRepository>(),
    );
    _cubit.load(widget.listingId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ListingDetailCubit, ListingDetailState>(
      bloc: _cubit,
      listener: (context, state) {
        final Failure? transient = state.transientFailure;
        if (transient != null) {
          final AppLocalizations l10n = AppLocalizations.of(context);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(failureMessage(l10n, transient))),
            );
          _cubit.clearTransientFailure();
        }
      },
      child: BlocBuilder<ListingDetailCubit, ListingDetailState>(
        bloc: _cubit,
        builder: (context, state) {
          return ShopDetailPane(
            state: state,
            onToggleSaved: () => _cubit.toggleSaved(),
            onRetry: () => _cubit.load(widget.listingId),
            onReturnToResults: widget.onReturnToResults,
          );
        },
      ),
    );
  }
}

/// Expanded-layout right-region placeholder (shown while no shop is selected).
class _ShopDetailPlaceholder extends StatelessWidget {
  const _ShopDetailPlaceholder();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Container(
      color: AppColors.surfaceVariant,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.storefront_outlined,
                size: 48.sp,
                color: AppColors.textTertiary,
              ),
              SizedBox(height: AppSpacing.lg.h),
              Text(
                l10n.searchSelectShop,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
