import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injectable.dart';
import '../../../../core/errors/failure_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../listing/data/models/browse_listing.dart';
import '../../../saved/repository/saved_listings_repository.dart';

/// Marketplace card for the home feed (Figma `95:4028`): thumbnail + title +
/// district + compact annual rent (`120K EGP/yr` via [homeRentPerYear]). Two
/// layouts:
/// - vertical (`horizontal: false`): Recommended/Spaces rail card (133-wide,
///   120-tall image on top, text below, visual-only save heart beside price);
/// - horizontal: Nearby Listings card (76×68 flush thumbnail left, text right,
///   area right-aligned).
///
/// Rent is compacted to `K` units (`120000 → 120K`); the `K` token is not
/// Arabic-number-localized (gap-log). The save heart reflects `isSaved` but is
/// visual-only until Phase 3. The browse API has no street/address, so the
/// card shows `district` as its location line (gap-log).
class HomeListingCard extends StatelessWidget {
  const HomeListingCard({
    super.key,
    required this.listing,
    this.horizontal = false,
    this.onTap,
  });

  final BrowseListing listing;
  final bool horizontal;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String location = listing.district;
    final String areaLabel = l10n.detailAreaValue(
      listing.areaSqm.toStringAsFixed(0),
    );
    final String rent = l10n.homeRentPerYear(
      '${_compactAmount(listing.annualRentWithVat)} ${listing.currency}',
    );

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          horizontal ? AppRadius.card.r : AppRadius.large.r,
        ),
        side: const BorderSide(color: AppColors.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: horizontal
            ? _HorizontalLayout(
                listing: listing,
                location: location,
                areaLabel: areaLabel,
                rent: rent,
              )
            : _VerticalLayout(listing: listing, location: location, rent: rent),
      ),
    );
  }

  /// `120000 → "120K"`, `1200 → "1.2K"`; amounts under 1,000 render as-is.
  String _compactAmount(double amount) {
    if (amount >= 1000) {
      final double thousands = amount / 1000;
      return '${thousands.toStringAsFixed(thousands % 1 == 0 ? 0 : 1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}

class _VerticalLayout extends StatelessWidget {
  const _VerticalLayout({
    required this.listing,
    required this.location,
    required this.rent,
  });

  final BrowseListing listing;
  final String location;
  final String rent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 105.h,
          width: double.infinity,
          child: _Thumbnail(url: listing.thumbnailUrl),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.sm.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  listing.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text(
                        rent,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    Expanded(flex: 1, child: _SaveHeart(listing: listing)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HorizontalLayout extends StatelessWidget {
  const _HorizontalLayout({
    required this.listing,
    required this.location,
    required this.areaLabel,
    required this.rent,
  });

  final BrowseListing listing;
  final String location;
  final String areaLabel;
  final String rent;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.card.r),
          child: SizedBox(
            width: 73.w,
            height: 73.h,
            child: _Thumbnail(url: listing.thumbnailUrl),
          ),
        ),
        SizedBox(width: AppSpacing.md.w),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      listing.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.xs.w),
                  Text(
                    areaLabel,
                    maxLines: 1,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                location,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                rent,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: AppSpacing.md.w),
      ],
    );
  }
}

/// Interactive save heart (US5, T058): injects the ONE shared
/// [SavedListingsRepository] (via `getIt`, D8) and toggles save/unsave with
/// the optimistic flip + revert + a localized failure message (contract
/// `saved-listings.md` consistency protocol). A single in-flight flag blocks
/// duplicate taps (FR-014). No per-screen save logic — every heart goes
/// through this one repository.
class _SaveHeart extends StatefulWidget {
  const _SaveHeart({required this.listing});

  final BrowseListing listing;

  @override
  State<_SaveHeart> createState() => _SaveHeartState();
}

class _SaveHeartState extends State<_SaveHeart> {
  late bool _saved;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _saved = widget.listing.isSaved == true;
  }

  @override
  void didUpdateWidget(covariant _SaveHeart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.listing.isSaved != widget.listing.isSaved) {
      _saved = widget.listing.isSaved == true;
    }
  }

  Future<void> _toggle() async {
    if (_saving) return;
    _saving = true;
    final bool previous = _saved;
    final bool target = !_saved;
    setState(() => _saved = target);
    try {
      final SavedListingsRepository repository =
          getIt<SavedListingsRepository>();
      if (target) {
        await repository.save(widget.listing.id);
      } else {
        await repository.unsave(widget.listing.id);
      }
    } on Failure catch (failure) {
      _revertAndSurface(previous, failure);
    } catch (_) {
      _revertAndSurface(previous, const ServerFailure(''));
    } finally {
      _saving = false;
    }
  }

  void _revertAndSurface(bool previous, Failure failure) {
    if (!mounted) return;
    setState(() => _saved = previous);
    final AppLocalizations l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(failureMessage(l10n, failure))));
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return IconButton(
      onPressed: _toggle,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      tooltip: _saved ? l10n.savedUnsaveTooltip : l10n.savedSaveTooltip,
      icon: Icon(
        _saved ? Icons.favorite : Icons.favorite_border,
        size: 16.sp,
        color: _saved ? AppColors.primary : AppColors.textTertiary,
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return const _ThumbnailPlaceholder();
    }
    return CachedNetworkImage(
      imageUrl: url!,
      fit: BoxFit.cover,
      errorWidget: (context, _, _) => const _ThumbnailPlaceholder(),
    );
  }
}

class _ThumbnailPlaceholder extends StatelessWidget {
  const _ThumbnailPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceVariant,
      child: Icon(
        Icons.storefront_outlined,
        size: 28.sp,
        color: AppColors.textTertiary,
      ),
    );
  }
}
