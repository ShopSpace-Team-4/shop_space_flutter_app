import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/failure_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../data/models/saved_listing.dart';
import '../cubits/saved_listings_cubit.dart';
import '../widgets/saved_listing_card.dart';

/// Saved shops screen (US5, T056; Figma Saved frame `242:2494`): a full-bleed
/// navy→blue gradient header ("Saved Spaces" + a decorative heart, with the
/// "Your wishlist is empty" subtitle only in the empty state) above a
/// `BlocBuilder` over [SavedListingsCubit] rendering the saved card list, a
/// Figma empty state with a "Explore Spaces" CTA into `/search`, and a
/// localized error + retry. Every unsave from anywhere disappears on refresh
/// (FR-013) and every save from anywhere appears (SC-006) because the cubit
/// refetches `getSavedListings()` on open/refresh through the ONE shared
/// [SavedListingsRepository] (D8). Tapping a card pushes the shop detail
/// `/search/:listingId` (US2).
///
/// All sizes/spacing scale with screenutil; flex layout adapts at every
/// breakpoint.
class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  late final SavedListingsCubit _cubit;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    // Provided by the router's BlocProvider; it owns this cubit's lifecycle.
    _cubit = context.read<SavedListingsCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SavedListingsCubit, SavedListingsState>(
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
      },
      child: BlocBuilder<SavedListingsCubit, SavedListingsState>(
        bloc: _cubit,
        builder: (context, state) {
          return Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SavedHeader(
                  showSubtitle: state.loaded && state.items.isEmpty,
                ),
                Expanded(child: _buildBody(state)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(SavedListingsState state) {
    if (state.failure != null) {
      return AppErrorView(failure: state.failure!, onRetry: _cubit.load);
    }
    if (state.isLoading && !state.loaded) {
      return const AppLoadingView();
    }
    if (state.loaded && state.items.isEmpty) {
      return const _SavedEmptyView();
    }
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, AppSpacing.xl.h),
      itemCount: state.items.length,
      separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md.h),
      itemBuilder: (context, index) {
        final SavedListing listing = state.items[index];
        return SavedListingCard(
          listing: listing,
          onTap: () => context.push('/search/${listing.id}'),
          onToggleSaved: () => _cubit.unsave(listing.id),
        );
      },
    );
  }
}

/// Figma Saved header (`242:2494`): full-bleed `#0F172A → #1E3A8A` gradient
/// (same tokens as the home hero `home_hero_header.dart`) holding a 60h row of
/// the "Saved Spaces" title (left, with the "Your wishlist is empty" subtitle
/// beneath it in the empty state) and a decorative heart button (right).
/// Every value scales with screenutil.
class _SavedHeader extends StatelessWidget {
  const _SavedHeader({required this.showSubtitle});

  /// True only while the list is loaded and empty (Figma shows the subtitle
  /// alongside the empty state).
  final bool showSubtitle;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.heroGradientStart, AppColors.heroGradientEnd],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 20.h),
          child: SizedBox(
            height: 60.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.savedTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.heading4.copyWith(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800,
                          height: 33 / 22,
                          color: AppColors.textInverse,
                        ),
                      ),
                      if (showSubtitle) ...[
                        SizedBox(height: 4.h),
                        Text(
                          l10n.savedWishlistEmptySubtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textInverse.withValues(
                              alpha: 0.55,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: AppSpacing.md.w),
                const _DecorativeHeart(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Figma Saved header heart (`242:2570`): a 44.r rounded-square (radius 14.r)
/// with a white α0.10 fill, a 1px white α0.15 border and a filled heart icon.
/// Non-interactive — decoration only.
class _DecorativeHeart extends StatelessWidget {
  const _DecorativeHeart();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44.r,
      height: 44.r,
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        border: Border.all(
          color: AppColors.surface.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Icon(
        Icons.favorite,
        size: 20.sp,
        color: AppColors.error,
      ),
    );
  }
}

/// Figma Saved empty state (`242:2575–2584`): a 100.r rounded-square (radius
/// 28.r) with the `primaryContainer → savedIconGradientEnd` gradient and an
/// outlined heart, the "Nothing saved yet" heading, the muted helper copy, and
/// a primary "Explore Spaces" pill that opens `/search`.
class _SavedEmptyView extends StatelessWidget {
  const _SavedEmptyView();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100.r,
              height: 100.r,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28.r),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryContainer,
                    AppColors.savedIconGradientEnd,
                  ],
                ),
              ),
              child: Icon(
                Icons.favorite_border,
                size: 44.sp,
                color: AppColors.outlineFocus,
              ),
            ),
            SizedBox(height: 20.h),
            Text(l10n.savedEmptyTitle, style: AppTypography.heading4),
            SizedBox(height: AppSpacing.sm.h),
            Text(
              l10n.savedEmptyMessage,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            SizedBox(height: 28.h),
            FilledButton(
              onPressed: () => context.go('/search'),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 13.h),
                shape: const StadiumBorder(),
                textStyle: AppTypography.bodyMedium.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: Text(l10n.savedExploreSpaces),
            ),
          ],
        ),
      ),
    );
  }
}