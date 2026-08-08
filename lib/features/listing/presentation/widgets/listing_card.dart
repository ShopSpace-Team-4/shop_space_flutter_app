import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/listing_status.dart';
import '../../data/models/listing_summary.dart';
import 'listing_status_badge.dart';

/// One My Listings list item (US2/T028): thumbnail rendered as-is (absolute
/// Cloudinary URL — never prepend a base, D3), title, category, area,
/// `annualRent` + `currency`, and the status badge. Tap opens the detail.
/// Fully responsive (screenutil + flex).
class ListingCard extends StatelessWidget {
  const ListingCard({super.key, required this.summary, this.onTap});

  final ListingSummary summary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
        side: const BorderSide(color: AppColors.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Thumbnail(url: summary.thumbnailUrl),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      summary.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs.h),
                    Text(
                      '${summary.category} · ${summary.areaSqm.toStringAsFixed(0)} m²',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    Text(
                      _rentText(summary),
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    ListingStatusBadge(status: summary.status),
                    if (summary.status == ListingStatus.pending) ...[
                      SizedBox(height: AppSpacing.xs.h),
                      Text(
                        l10n.myListingsNotPublic,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.warningOnContainer,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _rentText(ListingSummary summary) =>
      '${summary.annualRent.toStringAsFixed(0)} ${summary.currency}';
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final double size = 88.r;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: SizedBox(
        width: size,
        height: size,
        child: _image(url),
      ),
    );
  }

  Widget _image(String? url) {
    if (url == null || url.isEmpty) {
      return const _ThumbnailPlaceholder();
    }
    return CachedNetworkImage(
      imageUrl: url,
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
        size: 32.sp,
        color: AppColors.textTertiary,
      ),
    );
  }
}
