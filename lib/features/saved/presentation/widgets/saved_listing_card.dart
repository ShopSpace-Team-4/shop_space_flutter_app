import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/models/saved_listing.dart';
import 'saved_heart_button.dart';

/// One saved-listing card (US5, T055; Figma Saved frame): thumbnail, title,
/// the combined `location` string rendered as-is, the VAT-inclusive annual
/// rent via [Formatters.formatPrice] (FR-003 display-only — never the raw
/// `annualRent`), area via [Formatters.formatArea], and a save/unsave heart
/// wired to [SavedListingsCubit] by the caller (D8). Tapping the card opens
/// the shop detail `/search/:listingId` (US2).
///
/// Presentational: tap/heart behavior is owned by the screen via [onTap] and
/// [onToggleSaved]. All values scale with screenutil; the row flexes so
/// content never overflows at any breakpoint.
class SavedListingCard extends StatelessWidget {
  const SavedListingCard({
    super.key,
    required this.listing,
    this.onTap,
    this.onToggleSaved,
  });

  final SavedListing listing;
  final VoidCallback? onTap;
  final VoidCallback? onToggleSaved;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String price = Formatters.formatPrice(
      listing.annualRentWithVat,
      l10n,
      compact: true,
    );
    final String area = Formatters.formatArea(listing.areaSqm, l10n);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card.r),
        side: const BorderSide(color: AppColors.outline),
      ),
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
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            listing.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySmall.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        SizedBox(width: AppSpacing.xs.w),
                        SavedHeartButton(
                          saved: listing.isSaved == true,
                          onPressed: onToggleSaved ?? () {},
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      listing.location,
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
                        SizedBox(width: AppSpacing.sm.w),
                        Text(
                          area,
                          maxLines: 1,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textTertiary,
                          ),
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
