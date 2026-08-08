import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/listing_media.dart';
import '../../data/models/listing_status.dart';
import '../../data/models/shop_listing.dart';
import 'listing_status_badge.dart';

/// Shared full-detail body for [ShopListing]. Used by the pushed
/// `ListingDetailScreen` (compact/medium) and the two-pane expanded layout
/// (US2/T030/T031) so both render identically. Fully responsive (screenutil +
/// flex layout).
class ListingDetailPane extends StatelessWidget {
  const ListingDetailPane({
    super.key,
    required this.listing,
    this.isSubmitting = false,
    this.onStatusPressed,
    this.onEditPressed,
    this.onDeletePressed,
  });

  final ShopListing listing;
  final bool isSubmitting;
  final VoidCallback? onStatusPressed;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (listing.media.isNotEmpty) _MediaGallery(media: listing.media),
          Padding(
            padding: EdgeInsets.all(AppSpacing.lg.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        listing.title,
                        style: AppTypography.heading3.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    ListingStatusBadge(status: listing.status),
                  ],
                ),
                SizedBox(height: AppSpacing.sm.h),
                Text(
                  '${listing.category} · ${listing.city}, ${listing.district}',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (listing.status == ListingStatus.pending) ...[
                  SizedBox(height: AppSpacing.xs.h),
                  Text(
                    l10n.myListingsNotPublic,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.warningOnContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                if (listing.address != null && listing.address!.isNotEmpty) ...[
                  SizedBox(height: AppSpacing.xs.h),
                  Text(
                    listing.address!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
                SizedBox(height: AppSpacing.lg.h),
                Row(
                  children: [
                    Expanded(
                      child: _PriceTile(
                        label: l10n.detailAnnualRent,
                        value:
                            '${listing.annualRent.toStringAsFixed(0)} ${listing.currency}',
                      ),
                    ),
                    SizedBox(width: AppSpacing.md.w),
                    Expanded(
                      child: _PriceTile(
                        label: l10n.detailAnnualRentWithVat,
                        value:
                            '${listing.annualRentWithVat.toStringAsFixed(0)} ${listing.currency}',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xl.h),
                _InfoGrid(listing: listing),
                SizedBox(height: AppSpacing.xl.h),
                Text(
                  l10n.detailAmenities,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSpacing.sm.h),
                Wrap(
                  spacing: AppSpacing.sm.w,
                  runSpacing: AppSpacing.sm.h,
                  children: [
                    for (final String amenity in listing.amenities)
                      _Chip(label: amenity),
                  ],
                ),
                if (listing.description != null &&
                    listing.description!.isNotEmpty) ...[
                  SizedBox(height: AppSpacing.xl.h),
                  Text(
                    l10n.detailDescription,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  Text(
                    listing.description!,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                if (onStatusPressed != null) ...[
                  SizedBox(height: AppSpacing.xxl.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: isSubmitting ? null : onStatusPressed,
                          icon: const Icon(Icons.swap_vert),
                          label: Text(l10n.statusChangeTitle),
                        ),
                      ),
                      SizedBox(width: AppSpacing.md.w),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: isSubmitting ? null : onEditPressed,
                          icon: const Icon(Icons.edit_outlined),
                          label: Text(l10n.detailEdit),
                        ),
                      ),
                    ],
                  ),
                ],
                if (onDeletePressed != null) ...[
                  SizedBox(height: AppSpacing.md.h),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: isSubmitting ? null : onDeletePressed,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                      ),
                      icon: const Icon(Icons.delete_outline),
                      label: Text(l10n.detailDelete),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MediaGallery extends StatelessWidget {
  const _MediaGallery({required this.media});

  final List<ListingMedia> media;

  @override
  Widget build(BuildContext context) {
    final List<ListingMedia> ordered = [...media]
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return SizedBox(
      height: 240.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(AppSpacing.lg.r),
        itemCount: ordered.length,
        separatorBuilder: (context, index) => SizedBox(width: AppSpacing.md.w),
        itemBuilder: (context, index) {
          final ListingMedia item = ordered[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.large),
            child: CachedNetworkImage(
              imageUrl: item.url,
              fit: BoxFit.cover,
              width: 280.w,
              errorWidget: (context, _, _) => Container(
                width: 280.w,
                color: AppColors.surfaceVariant,
                child: Icon(
                  Icons.image_not_supported_outlined,
                  size: 48.sp,
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PriceTile extends StatelessWidget {
  const _PriceTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          SizedBox(height: AppSpacing.xs.h),
          Text(
            value,
            style: AppTypography.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.listing});

  final ShopListing listing;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    final List<(String, String)> rows = [
      (
        l10n.detailArea,
        '${listing.areaSqm.toStringAsFixed(0)} m²',
      ),
      (
        l10n.detailFloor,
        listing.floorNumber == 0 ? l10n.detailGround : '${listing.floorNumber}',
      ),
      if (listing.numberOfFloors != null)
        (l10n.detailFloors, '${listing.numberOfFloors}'),
      if (listing.availableFrom != null)
        (
          l10n.detailAvailableFrom,
          _formatDate(listing.availableFrom!),
        ),
      if (listing.minimumLeaseTerm != null &&
          listing.minimumLeaseTerm!.isNotEmpty)
        (l10n.detailMinimumLease, listing.minimumLeaseTerm!),
      if (listing.securityDepositMonths != null)
        (
          l10n.detailSecurityDeposit,
          '${listing.securityDepositMonths} ${l10n.detailMonths}',
        ),
    ];

    return Column(
      children: [
        for (final (String label, String value) in rows)
          Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.md.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.sm.w),
                Text(
                  value,
                  textAlign: TextAlign.end,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md.w,
        vertical: AppSpacing.sm.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}
