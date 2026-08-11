import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injectable.dart';
import '../../../../core/errors/failure_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../listing/data/models/browse_listing.dart';
import '../../../saved/repository/saved_listings_repository.dart';
import '../../../search/presentation/widgets/search_result_card.dart';

/// "Recommended Listings" section beneath an assistant answer (US3, contract
/// `contracts/advisor-recommended-listings.md`, D5): the localized
/// `advisorRecommendedListings` title above a vertical stack of the EXISTING
/// [SearchResultCard]s (FR-008 — never a new or AI-generated card). No AI
/// score or scoring badge is ever rendered (FR-011).
///
/// The whole section returns [SizedBox.shrink] when the message carries no
/// valid listings (FR-007 — hidden for absent/null/empty/fully-malformed
/// data), so a section failure can never hide the AI answer or crash the chat
/// (FR-006/007).
///
/// Save hearts (T025) go through the SHARED [SavedListingsRepository]
/// (D5/D8): this widget resolves it from get_it and mutates only through it —
/// no advisor-local save logic. The Phase 3 D8 protocol applies: optimistic
/// `isSaved` flip on tap, revert on failure, typed failure surfaced via a
/// localized snackbar. Card taps (T026) push the EXISTING `/search/:listingId`
/// detail route through normal app navigation — no advisor-specific detail
/// screen (FR-009).
class RecommendedListingsSection extends StatefulWidget {
  const RecommendedListingsSection({super.key, required this.listings});

  final List<BrowseListing> listings;

  @override
  State<RecommendedListingsSection> createState() =>
      _RecommendedListingsSectionState();
}

class _RecommendedListingsSectionState extends State<RecommendedListingsSection> {
  SavedListingsRepository? _savedRepository;

  /// Optimistic per-listing `isSaved` overrides (D8). Flips immediately on tap,
  /// reverts to the value before the tap on failure. Server-authoritative
  /// payload `isSaved` is the base otherwise.
  final Map<String, bool> _optimisticSaved = <String, bool>{};

  /// Per-listing in-flight guard so a double tap fires exactly one mutation.
  final Set<String> _savingIds = <String>{};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Shared repo resolved once from get_it (D5/D8) — the same instance the
    // search/detail/saved surfaces use, so hearts stay consistent everywhere.
    _savedRepository ??= getIt<SavedListingsRepository>();
  }

  bool _isSaved(BrowseListing listing) =>
      _optimisticSaved[listing.id] ?? (listing.isSaved == true);

  /// Optimistic heart toggle (D8, contract `saved-listings.md`): flips
  /// `isSaved` immediately, mutates only through the shared
  /// [SavedListingsRepository], and reverts + surfaces a localized snackbar
  /// on error. A single in-flight flag per listing blocks duplicate taps.
  Future<void> _toggleSaved(BrowseListing listing) async {
    if (_savingIds.contains(listing.id)) return;
    final bool current = _isSaved(listing);
    final bool target = !current;
    _savingIds.add(listing.id);
    setState(() => _optimisticSaved[listing.id] = target);
    try {
      final SavedListingsRepository repo = _savedRepository!;
      if (target) {
        await repo.save(listing.id);
      } else {
        await repo.unsave(listing.id);
      }
    } on Failure catch (failure) {
      _revertAndSurface(listing, current, failure);
    } catch (_) {
      _revertAndSurface(listing, current, const ServerFailure(''));
    } finally {
      _savingIds.remove(listing.id);
    }
  }

  void _revertAndSurface(BrowseListing listing, bool current, Failure failure) {
    if (!mounted) return;
    setState(() => _optimisticSaved[listing.id] = current);
    final AppLocalizations l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(failureMessage(l10n, failure))));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.listings.isEmpty) {
      return const SizedBox.shrink();
    }
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.advisorRecommendedListings,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSpacing.md.h),
        for (final BrowseListing listing in widget.listings) ...[
          SearchResultCard(
            listing: listing.copyWith(isSaved: _isSaved(listing)),
            onTap: () => context.push('/search/${listing.id}'),
            onToggleSaved: () => _toggleSaved(listing),
          ),
          SizedBox(height: AppSpacing.md.h),
        ],
      ],
    );
  }
}
