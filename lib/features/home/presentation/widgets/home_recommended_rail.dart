import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../listing/data/models/browse_listing.dart';
import 'home_listing_card.dart';
import 'home_section_heading.dart';

/// Spaces rail (Figma `95:4028`, child `95:4339`): heading + "See all" action
/// + a horizontal carousel of 133-wide cards (gap 7). "See all" deep-links to
/// `/search`; tapping a card opens the tenant listing detail `/search/{id}`
/// (US2, T033 — was the landlord-oriented `/my-listings/{id}`).
class HomeRecommendedRail extends StatelessWidget {
  const HomeRecommendedRail({super.key, required this.listings});

  final List<BrowseListing> listings;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HomeSectionHeading(
          title: l10n.homeRecommendedTitle,
          actionLabel: l10n.homeSeeAll,
          onAction: () => context.go('/search'),
        ),
        SizedBox(height: AppSpacing.md.h),
        if (listings.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
            child: Text(
              l10n.homeEmptyRecommended,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          )
        else
          SizedBox(
            height: 208.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
              itemCount: listings.length,
              separatorBuilder: (context, index) => SizedBox(width: 7.w),
              itemBuilder: (context, index) {
                final BrowseListing listing = listings[index];
                return SizedBox(
                  width: 133.w,
                  child: HomeListingCard(
                    listing: listing,
                    onTap: () => context.push('/search/${listing.id}'),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
