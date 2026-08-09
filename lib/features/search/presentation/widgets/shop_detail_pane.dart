import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/errors/failure_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../listing/data/models/listing_status.dart';
import '../../../listing/data/models/shop_listing.dart';
import '../../../listing/presentation/widgets/listing_status_badge.dart';
import '../../../listing/presentation/widgets/whatsapp_contact_button.dart';
import '../cubits/listing_detail_cubit.dart';
import 'gallery_viewer.dart';

/// Shared tenant listing-detail body (US2, T029). **This is the ONE pane used
/// both as the expanded search right region and as the body of the pushed
/// compact/medium screen** (D10, contract `responsive-search-layout.md`), so
/// both render identically.
///
/// Locked redesign (Figma `97:5547`, 2026-08-10): full-bleed gallery with a
/// top scrim and circular back/heart overlays, an inline price row with a
/// localized `/year` suffix and a status pill (the green "Available" pill, or
/// the real [ListingStatusBadge] for any other status), a 3-up stat-tile row
/// (Area · Floor · Available from), responsive amenity chips with a "+n more"
/// overflow, and the below-fold rows (floors, lease, deposit, category) in core
/// tokens. The bottom contact action stays the full-width
/// [WhatsAppContactButton] (user decision 2026-08-10 — no new landlord card).
///
/// [onBack] is optional: the pushed compact/medium screen supplies it to draw
/// the back circle overlay (and the screen keeps no AppBar); the expanded right
/// region passes nothing so only the heart overlay renders there. A
/// [ListingDetailState.isUnavailable] state renders the friendly "no longer
/// available" message + return-to-results action (US2 scenario 4). Fully
/// responsive — every value scales with screenutil and layout flexes.
class ShopDetailPane extends StatelessWidget {
  const ShopDetailPane({
    super.key,
    required this.state,
    required this.onToggleSaved,
    required this.onRetry,
    required this.onReturnToResults,
    this.onBack,
  });

  final ListingDetailState state;
  final VoidCallback onToggleSaved;
  final VoidCallback onRetry;
  final VoidCallback onReturnToResults;

  /// When non-null the pane draws a back circle overlay (top-start); the
  /// pushed compact/medium screen passes it, the expanded region does not.
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final ShopListing? listing = state.listing;
    if (listing != null) {
      return _DetailBody(
        listing: listing,
        onToggleSaved: onToggleSaved,
        onBack: onBack,
      );
    }

    final Widget content;
    if (state.failure != null) {
      content = _DetailError(failure: state.failure!, onRetry: onRetry);
    } else if (state.isUnavailable) {
      content = _UnavailableView(onReturnToResults: onReturnToResults);
    } else {
      content = const AppLoadingView();
    }

    // Non-body states have no gallery to host the overlay, so add a floating
    // back circle for the pushed screen (which has no AppBar).
    if (onBack == null) return content;
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Stack(
      children: [
        Positioned.fill(child: content),
        Positioned(
          top: MediaQuery.paddingOf(context).top + AppSpacing.sm.h,
          left: AppSpacing.sm.w,
          child: _OverlayCircleButton(
            icon: Icons.arrow_back,
            onPressed: onBack,
            tooltip: l10n.commonBack,
          ),
        ),
      ],
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({
    required this.listing,
    required this.onToggleSaved,
    this.onBack,
  });

  final ShopListing listing;
  final VoidCallback onToggleSaved;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool saved = listing.isSaved == true;
    final bool hasDescription =
        listing.description != null && listing.description!.isNotEmpty;
    final bool hasAddress =
        listing.address != null && listing.address!.isNotEmpty;
    final bool hasFloors = listing.numberOfFloors != null;
    final bool hasLease = listing.minimumLeaseTerm != null &&
        listing.minimumLeaseTerm!.isNotEmpty;
    final bool hasDeposit = listing.securityDepositMonths != null;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              GalleryViewer(media: listing.media),
              if (onBack != null)
                Positioned(
                  top: MediaQuery.paddingOf(context).top + AppSpacing.sm.h,
                  left: AppSpacing.sm.w,
                  child: _OverlayCircleButton(
                    icon: Icons.arrow_back,
                    onPressed: onBack,
                    tooltip: l10n.commonBack,
                  ),
                ),
              Positioned(
                top: MediaQuery.paddingOf(context).top + AppSpacing.sm.h,
                right: AppSpacing.sm.w,
                child: _OverlayCircleButton(
                  icon: saved ? Icons.favorite : Icons.favorite_border,
                  onPressed: onToggleSaved,
                  tooltip:
                      saved ? l10n.searchSavedTooltip : l10n.searchSaveTooltip,
                ),
              ),
            ],
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title,
                    style: AppTypography.heading3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  Text(
                    '${listing.city}, ${listing.district}',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (hasAddress) ...[
                    SizedBox(height: AppSpacing.xs.h),
                    Text(
                      listing.address!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                  SizedBox(height: AppSpacing.lg.h),
                  _PriceRow(listing: listing),
                  SizedBox(height: AppSpacing.xl.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _StatTile(
                          label: l10n.detailArea,
                          value: Formatters.formatArea(listing.areaSqm, l10n),
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm.w),
                      Expanded(
                        child: _StatTile(
                          label: l10n.detailFloor,
                          value: listing.floorNumber == 0
                              ? l10n.detailGround
                              : l10n.detailFloorsCount(listing.floorNumber),
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm.w),
                      Expanded(
                        child: _StatTile(
                          label: l10n.detailAvailableFrom,
                          value: listing.availableFrom != null
                              ? Formatters.formatDate(
                                  listing.availableFrom!,
                                  l10n,
                                )
                              : l10n.detailNotAvailable,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xl.h),
                  if (hasFloors)
                    _LabeledValue(
                      label: l10n.detailFloors,
                      value: '${listing.numberOfFloors}',
                    ),
                  if (hasLease)
                    _LabeledValue(
                      label: l10n.detailMinimumLease,
                      value: Formatters.formatLease(
                        listing.minimumLeaseTerm,
                        l10n,
                      ),
                    ),
                  if (hasDeposit)
                    _LabeledValue(
                      label: l10n.detailSecurityDeposit,
                      value: Formatters.formatDeposit(
                        listing.securityDepositMonths,
                        l10n,
                      ),
                    ),
                  _LabeledValue(
                    label: l10n.detailCategory,
                    value: listing.category,
                  ),
                  SizedBox(height: AppSpacing.xl.h),
                  Text(
                    l10n.detailAmenities,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  _AmenityChips(amenities: listing.amenities),
                  if (hasDescription) ...[
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
                  SizedBox(height: AppSpacing.xxl.h),
                  WhatsAppContactButton(listing: listing),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Inline price row (Figma `97:5547`): the VAT-inclusive annual rent in primary
/// (display-only via [Formatters.formatPrice], FR-003), a muted localized
/// `/year` suffix, and a status pill that only uses the green "Available" pill
/// when the listing is actually [ListingStatus.available] — any other status
/// renders the real [ListingStatusBadge] instead.
class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.listing});

  final ShopListing listing;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: Formatters.formatPrice(
                    listing.annualRentWithVat,
                    l10n,
                  ),
                  style: AppTypography.heading4.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                TextSpan(
                  text: ' ${l10n.detailPerYear}',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: AppSpacing.sm.w),
        _StatusPill(status: listing.status),
      ],
    );
  }
}

/// Status pill for the inline price row: a green "Available" pill
/// (`availableContainer`/`availableOnContainer`, Figma `97:5547`) for
/// [ListingStatus.available], and the standard localized [ListingStatusBadge]
/// for every other status.
class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final ListingStatus status;

  @override
  Widget build(BuildContext context) {
    if (status != ListingStatus.available) {
      return ListingStatusBadge(status: status);
    }
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm.w,
        vertical: AppSpacing.xs.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.availableContainer,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        l10n.statusAvailable,
        style: AppTypography.caption.copyWith(
          color: AppColors.availableOnContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Stat tile (Figma `97:5547`): `surfaceVariant` fill, r10; value `textPrimary`
/// on top of a muted `textTertiary` label. The value scales down with
/// [FittedBox] so a long date/floor string never overflows the third-width
/// tile.
class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.caption.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          SizedBox(height: AppSpacing.xs.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              value,
              maxLines: 1,
              style: AppTypography.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Responsive amenity chips: a greedy width-based fit (via [LayoutBuilder] and
/// [TextPainter]) shows as many chips as fit on the first row while reserving a
/// "+n more" chip ([AppLocalizations.detailMoreCount]) — so fewer chips show on
/// narrow compact widths and more on expanded. Chips use `primaryContainer`
/// fill with `textPrimary` (Figma `97:5547`).
class _AmenityChips extends StatelessWidget {
  const _AmenityChips({required this.amenities});

  final List<String> amenities;

  @override
  Widget build(BuildContext context) {
    if (amenities.isEmpty) return const SizedBox.shrink();
    return LayoutBuilder(
      builder: (context, constraints) {
        final AppLocalizations l10n = AppLocalizations.of(context);
        final double maxWidth = constraints.maxWidth;
        final List<double> widths = [
          for (final String amenity in amenities) _chipWidth(context, amenity),
        ];

        int visible = 0;
        double rowWidth = 0;
        for (int i = 0; i < amenities.length; i++) {
          final double gap = rowWidth == 0 ? 0 : AppSpacing.sm.w;
          final int remaining = amenities.length - i;
          final double reserved = remaining > 1
              ? _chipWidth(context, l10n.detailMoreCount(remaining - 1)) +
                  AppSpacing.sm.w
              : 0;
          if (rowWidth + gap + widths[i] + reserved <= maxWidth) {
            rowWidth += gap + widths[i];
            visible++;
          } else {
            break;
          }
        }

        final int hidden = amenities.length - visible;
        return Wrap(
          spacing: AppSpacing.sm.w,
          runSpacing: AppSpacing.sm.h,
          children: [
            for (int i = 0; i < visible; i++) _Chip(label: amenities[i]),
            if (hidden > 0) _Chip(label: l10n.detailMoreCount(hidden)),
          ],
        );
      },
    );
  }

  /// Estimates the rendered width of a chip (text + horizontal padding) using
  /// the same [TextPainter] style as [_Chip].
  double _chipWidth(BuildContext context, String label) {
    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: label,
        style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary),
      ),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    return painter.width + AppSpacing.md.w * 2;
  }
}

/// Circular overlay button (Figma `97:5547`): 34×34, fill `rgba(0,0,0,.40)`,
/// white icon — used for the back and heart controls over the gallery scrim.
class _OverlayCircleButton extends StatelessWidget {
  const _OverlayCircleButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.black.withValues(alpha: 0.40),
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: 34.r,
            height: 34.r,
            child: Icon(
              icon,
              size: 18.sp,
              color: AppColors.textInverse,
            ),
          ),
        ),
      ),
    );
  }
}

class _LabeledValue extends StatelessWidget {
  const _LabeledValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
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
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}

/// Friendly localized "no longer available" state (US2 scenario 4): the shop
/// was deleted or is no longer AVAILABLE mid-view. Offers a return-to-results
/// action.
class _UnavailableView extends StatelessWidget {
  const _UnavailableView({required this.onReturnToResults});

  final VoidCallback onReturnToResults;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.store_mall_directory_outlined,
              size: 48.sp,
              color: AppColors.textTertiary,
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              l10n.shopDetailUnavailableTitle,
              textAlign: TextAlign.center,
              style: AppTypography.heading4,
            ),
            SizedBox(height: AppSpacing.md.h),
            Text(
              l10n.shopDetailUnavailableMessage,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSpacing.xl.h),
            FilledButton(
              onPressed: onReturnToResults,
              child: Text(l10n.shopDetailReturnToResults),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailError extends StatelessWidget {
  const _DetailError({required this.failure, required this.onRetry});

  final Failure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: AppColors.error),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              failureMessage(l10n, failure),
              textAlign: TextAlign.center,
              style: AppTypography.heading4,
            ),
            SizedBox(height: AppSpacing.xl.h),
            FilledButton(
              onPressed: onRetry,
              child: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
