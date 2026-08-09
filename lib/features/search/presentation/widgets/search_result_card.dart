import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../listing/data/models/browse_listing.dart';

/// One search result card (FR-007): thumbnail, title, location
/// (city/district), the VAT-inclusive annual rent via
/// [Formatters.formatPrice] (`annualRentWithVat`, never the raw `annualRent`),
/// and a save heart.
///
/// The card is presentational: card tap behavior (push detail on compact /
/// select-in-pane on expanded) is owned by the caller via [onTap], and the
/// heart fires [onToggleSaved] (the screen wires it to
/// `SearchCubit.toggleSaved` — D8). All values scale with screenutil; the row
/// flexes so content never overflows.
class SearchResultCard extends StatelessWidget {
  const SearchResultCard({
    super.key,
    required this.listing,
    this.onTap,
    this.onToggleSaved,
    this.selected = false,
  });

  final BrowseListing listing;
  final VoidCallback? onTap;
  final VoidCallback? onToggleSaved;

  /// True when this card is the one shown in the expanded right detail pane
  /// (US2, T032): renders a primary selection border.
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String location = '${listing.city}, ${listing.district}';
    final String price = Formatters.formatPrice(
      listing.annualRentWithVat,
      l10n,
      compact: true,
    );

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        side: selected
            ? const BorderSide(color: AppColors.primary)
            : const BorderSide(color: AppColors.outline),
      ),
      color: selected ? AppColors.surfaceVariant : null,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 112.w,
              height: 96.h,
              child: _Thumbnail(url: listing.thumbnailUrl),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppSpacing.md.h,
                  horizontal: 0.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            price,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        _SaveHeartButton(
                          saved: listing.isSaved == true,
                          onPressed: onToggleSaved,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Save/unsave heart (D8): filled primary when saved, outline otherwise.
/// Tapping fires [onPressed]; the optimistic flip + revert lives in the cubit.
class _SaveHeartButton extends StatelessWidget {
  const _SaveHeartButton({required this.saved, this.onPressed});

  final bool saved;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return IconButton(
      onPressed: onPressed,
      tooltip: saved ? l10n.searchSavedTooltip : l10n.searchSaveTooltip,
      icon: Icon(
        saved ? Icons.favorite : Icons.favorite_border,
        size: 20.sp,
        color: saved ? AppColors.primary : AppColors.textTertiary,
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
