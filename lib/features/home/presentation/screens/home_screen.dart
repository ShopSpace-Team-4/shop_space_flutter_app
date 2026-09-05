import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../listing/data/models/browse_listing.dart';
import '../cubits/home_cubit.dart';
import '../widgets/home_advisor_card.dart';
import '../widgets/home_category_chips.dart';
import '../widgets/home_hero_header.dart';
import '../widgets/home_nearby_section.dart';
import '../widgets/home_recommended_rail.dart';

/// Content width cap for medium/expanded so the home sections (Figma `95:4028`
/// 343-wide cards, carousels) don't stretch edge-to-edge on wide screens.
/// This is a deliberate, non-scaling layout-structure constant (constitution
/// §5 allowed exception) — screenutil never picks structure.
const double _maxContentWidth = 720;

/// Tenant-facing home feed (Figma `95:4028`): hero header + AI Space Advisor
/// CTA + Categories chips + Recommended carousel + Nearby Listings, all driven
/// by [HomeCubit] via `GET /listings/meta` and `GET /listings`. No AppBar (the
/// design has none). Content is a scrollable column, centered with a max width
/// on medium/expanded; the hero stays full-bleed. Rendered inside
/// [AppAdaptiveShell].
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeCubit _cubit;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    // Provided by the router's BlocProvider; it owns this cubit's lifecycle.
    _cubit = context.read<HomeCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(
        bloc: _cubit,
        builder: (context, state) {
          final bool hasContent =
              state.categories.isNotEmpty ||
              state.recommended.isNotEmpty ||
              state.nearby.isNotEmpty;
          if (state.isLoading && !hasContent) {
            return const AppLoadingView();
          }
          if (state.failure != null && !hasContent) {
            return AppErrorView(failure: state.failure!, onRetry: _cubit.load);
          }
          return _HomeContent(
            state: state,
            onRefresh: _cubit.refresh,
            onCategorySelected: _cubit.selectCategory,
          );
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.state,
    required this.onRefresh,
    required this.onCategorySelected,
  });

  final HomeState state;
  final Future<void> Function() onRefresh;
  final ValueChanged<String?> onCategorySelected;

  /// Filters a loaded list by the selected category chip, in memory only.
  /// `null` selection ("All") keeps everything; matches are case-insensitive
  /// since chip values come from `GET /listings/meta` while listing categories
  /// come from `GET /listings`.
  List<BrowseListing> _filtered(List<BrowseListing> listings) {
    final String? selected = state.selectedCategory;
    if (selected == null) return listings;
    return listings
        .where(
          (BrowseListing l) =>
              l.category.toLowerCase() == selected.toLowerCase(),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<BrowseListing> recommended = _filtered(state.recommended);
    final List<BrowseListing> nearby = _filtered(state.nearby);
    final String? selected = state.selectedCategory;
    final bool nothingMatches =
        selected != null && recommended.isEmpty && nearby.isEmpty;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          HomeHeroHeader(user: state.user),
          SizedBox(height: AppSpacing.lg.h),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _maxContentWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
                    child: const HomeAdvisorCard(),
                  ),
                  SizedBox(height: 8.h),
                  HomeCategoryChips(
                    categories: state.categories,
                    selectedCategory: state.selectedCategory,
                    onSelected: onCategorySelected,
                  ),
                  SizedBox(height: 8.h),
                  if (nothingMatches)
                    _CategoryFilterEmptyView(
                      category: selected,
                      onShowAll: () => onCategorySelected(null),
                    )
                  else ...[
                    HomeRecommendedRail(listings: recommended),
                    SizedBox(height: 8.h),
                    HomeNearbySection(listings: nearby),
                  ],
                  SizedBox(height: AppSpacing.xxl.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Combined empty state shown when a category filter leaves both home sections
/// (Recommended + Nearby) empty (Figma `95:4028`). Mirrors the established
/// `_EmptySearchView` pattern: `AppEmptyView` + a "Show all"
/// `FilledButton.tonal` that clears the chip filter. The chips row stays
/// visible above so the user can also pick another category instead.
class _CategoryFilterEmptyView extends StatelessWidget {
  const _CategoryFilterEmptyView({
    required this.category,
    required this.onShowAll,
  });

  final String category;
  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.xl.h,
      ),
      child: Column(
        children: [
          AppEmptyView(
            title: l10n.homeCategoryEmptyTitle(category),
            message: l10n.homeCategoryEmptyMessage,
          ),
          SizedBox(height: AppSpacing.lg.h),
          FilledButton.tonal(
            onPressed: onShowAll,
            child: Text(l10n.homeShowAll),
          ),
        ],
      ),
    );
  }
}
