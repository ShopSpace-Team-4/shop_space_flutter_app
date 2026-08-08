import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../listing/data/models/browse_listing.dart';
import 'home_listing_card.dart';
import 'home_section_heading.dart';

/// Nearby Listings section (Figma `95:4028`): heading + stacked 343×84
/// horizontal cards (thumbnail left, text right). Tapping a card opens the
/// listing detail (landlord-oriented `/my-listings/{id}` for now — flagged
/// for Phase 3).
class HomeNearbySection extends StatelessWidget {
  const HomeNearbySection({super.key, required this.listings});

  final List<BrowseListing> listings;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HomeSectionHeading(title: l10n.homeNearbyTitle),
        SizedBox(height: 10.h),
        if (listings.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              l10n.homeEmptyNearby,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          )
        else
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                for (final (int i, BrowseListing listing) in listings.indexed) ...[
                  if (i > 0) SizedBox(height: 10.h),
                  HomeListingCard(
                    horizontal: true,
                    listing: listing,
                    onTap: () => context.push('/my-listings/${listing.id}'),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
