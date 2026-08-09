import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../listing/data/models/listing_media.dart';

/// Tenant-detail photo gallery (FR-008, T028): renders [ListingMedia] ordered
/// by `sortOrder` as a swipeable, full-bleed pager (Figma `97:5547`) with a top
/// scrim for the overlaid controls, a dot indicator overlaying bottom-center
/// and a localized counter pill at bottom-end. Empty media renders a neutral
/// placeholder consistent with the `core/theme` tokens. Fully responsive —
/// every size scales with screenutil.
class GalleryViewer extends StatefulWidget {
  const GalleryViewer({super.key, required this.media});

  final List<ListingMedia> media;

  @override
  State<GalleryViewer> createState() => _GalleryViewerState();
}

class _GalleryViewerState extends State<GalleryViewer> {
  late final List<ListingMedia> _ordered = [...widget.media]
    ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return SizedBox(
      height: 292.h,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (_ordered.isEmpty)
            const _GalleryPlaceholder()
          else
            PageView.builder(
              onPageChanged: (index) => setState(() => _current = index),
              itemCount: _ordered.length,
              itemBuilder: (context, index) {
                final ListingMedia item = _ordered[index];
                return _GalleryImage(url: item.url);
              },
            ),
          const _TopScrim(),
          if (_ordered.length > 1)
            Positioned(
              bottom: AppSpacing.sm.h,
              left: 0,
              right: 0,
              child: _DotsIndicator(
                count: _ordered.length,
                current: _current,
              ),
            ),
          if (_ordered.length > 1)
            Positioned(
              bottom: AppSpacing.sm.h,
              right: AppSpacing.sm.w,
              child: _CounterPill(
                label: l10n.shopDetailGalleryCounter(
                  _current + 1,
                  _ordered.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Top scrim (Figma `97:5547`): `rgba(0,0,0,.30)` fading to fully transparent
/// at 50% height, so the overlaid back/heart circles stay legible. Deliberately
/// [IgnorePointer] so swipes pass through to the pager.
class _TopScrim extends StatelessWidget {
  const _TopScrim();

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.5],
            colors: [Color(0x4D000000), Color(0x00000000)],
          ),
        ),
      ),
    );
  }
}

class _GalleryImage extends StatelessWidget {
  const _GalleryImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceVariant,
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        errorWidget: (context, _, _) => const _GalleryPlaceholder(),
      ),
    );
  }
}

/// Neutral full-bleed placeholder (fills the gallery Stack) for an empty media
/// list or a failed image load.
class _GalleryPlaceholder extends StatelessWidget {
  const _GalleryPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceVariant,
      child: Icon(
        Icons.storefront_outlined,
        size: 56.sp,
        color: AppColors.textTertiary,
      ),
    );
  }
}

/// Localized position counter pill, e.g. "1 of 4" (overlaid bottom-end on the
/// pager so it never clips in RTL).
class _CounterPill extends StatelessWidget {
  const _CounterPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm.w,
        vertical: AppSpacing.xs.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceInverse.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: AppColors.textInverse,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Dot pager indicator overlaid bottom-center — active dot is larger/white,
/// inactive dots white at 50% so they stay legible on photos.
class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < count; i++) ...[
          if (i > 0) SizedBox(width: AppSpacing.xs.w),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: i == current ? 16.w : 6.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: i == current
                  ? AppColors.textInverse
                  : AppColors.textInverse.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),
        ],
      ],
    );
  }
}
