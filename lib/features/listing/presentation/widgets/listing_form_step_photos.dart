import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/errors/failure_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/listing_media.dart';
import '../../data/models/pending_media.dart';
import '../../data/models/staged_media_entry.dart';
import '../cubits/listing_form_cubit.dart';

/// Step 2 of the create/edit form — Photos (listing-form.md §Steps, §Photo
/// staging). Gallery/camera pick, a drag-to-reorder photo grid rendered from
/// `pendingOrder` (existing server media in edit mode + staged adds), the ≥3
/// recommendation (never a hard block, D3), and inline type/size rejection
/// (`InvalidMediaFile`) that never disturbs the rest of the form (FR-007).
/// Edit mode shows added photos with a "New" badge and lets the landlord
/// remove existing photos (staged via `pendingDeletes`, nothing hits the
/// server until Save — D6).
class ListingFormStepPhotos extends StatefulWidget {
  const ListingFormStepPhotos({
    super.key,
    required this.cubit,
  });

  final ListingFormCubit cubit;

  @override
  State<ListingFormStepPhotos> createState() => _ListingFormStepPhotosState();
}

class _ListingFormStepPhotosState extends State<ListingFormStepPhotos> {
  final ImagePicker _picker = ImagePicker();
  bool _picking = false;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final ListingFormState state = widget.cubit.state;

    final List<Widget> tiles = [
      for (final StagedMediaEntry entry in state.pendingOrder)
        _tileFor(context, state, entry, l10n),
    ];

    // Invalid file / count-limit errors render inline inside the card instead
    // of the screen-level save-failure banner (which the screen excludes).
    final Failure? inlineError =
        state.submitFailure is InvalidMediaFile ||
            state.submitFailure is PhotoLimitReached
        ? state.submitFailure
        : null;

    return Container(
      padding: EdgeInsets.all(AppSpacing.lg.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PhotoCardHeader(l10n: l10n),
          SizedBox(height: AppSpacing.lg.h),
          Text(
            l10n.formPhotoRecommendation,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          if (inlineError != null) ...[
            SizedBox(height: AppSpacing.md.h),
            Text(
              failureMessage(l10n, inlineError),
              style: AppTypography.bodySmall.copyWith(color: AppColors.error),
            ),
          ],
          if (tiles.length > 1) ...[
            SizedBox(height: AppSpacing.md.h),
            Text(
              l10n.formPhotoReorderHint,
              style: AppTypography.caption.copyWith(color: AppColors.textMuted),
            ),
          ],
          SizedBox(height: AppSpacing.md.h),
          ReorderableBuilder<StagedMediaEntry>(
            children: tiles,
            onReorder: (ReorderedListFunction<StagedMediaEntry> reorderList) {
              widget.cubit.setPendingOrder(reorderList(state.pendingOrder));
            },
            builder: (List<Widget> reordered) => Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                ...reordered,
                _AddTile(
                  picking: _picking,
                  onPick: () => _pick(ImageSource.gallery),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.lg.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _picking ? null : () => _pick(ImageSource.camera),
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: Text(l10n.formPhotoPickCamera),
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _picking ? null : () => _pick(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined),
                  label: Text(l10n.formPhotoPickGallery),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the tile for one [StagedMediaEntry]: an existing server photo
  /// (edit mode) or a locally staged add. Both render in a shared drag grid.
  Widget _tileFor(
    BuildContext context,
    ListingFormState state,
    StagedMediaEntry entry,
    AppLocalizations l10n,
  ) {
    if (entry.isAdd) {
      final PendingMedia? pending = _pendingFor(state, entry.clientId);
      if (pending == null) return const SizedBox.shrink();
      return _PhotoTile(
        key: ValueKey<String>('add_${entry.clientId}'),
        image: Image.file(
          File(pending.file.path),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _brokenImage(),
        ),
        badge: state.isEditMode ? l10n.formPhotoNew : null,
        tooltip: l10n.formPhotoRemove,
        onRemove: () => widget.cubit.removePhoto(entry.clientId!),
      );
    }
    final ListingMedia? media = _mediaFor(state, entry.mediaId);
    if (media == null) return const SizedBox.shrink();
    return _PhotoTile(
      key: ValueKey<String>('existing_${entry.mediaId}'),
      image: CachedNetworkImage(
        imageUrl: media.url,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => _brokenImage(),
      ),
      tooltip: l10n.formPhotoRemove,
      onRemove: () => widget.cubit.removeExistingMedia(entry.mediaId!),
    );
  }

  static PendingMedia? _pendingFor(ListingFormState state, int? clientId) {
    if (clientId == null) return null;
    for (final PendingMedia pending in state.pendingAdds) {
      if (pending.clientId == clientId) return pending;
    }
    return null;
  }

  static ListingMedia? _mediaFor(ListingFormState state, String? mediaId) {
    if (mediaId == null) return null;
    for (final ListingMedia media in state.existingMedia) {
      if (media.id == mediaId) return media;
    }
    return null;
  }

  static Widget _brokenImage() => Container(
        color: AppColors.surfaceVariant,
        child: const Icon(Icons.broken_image_outlined),
      );

  Future<void> _pick(ImageSource source) async {
    if (_picking) return;
    setState(() => _picking = true);
    try {
      if (source == ImageSource.gallery) {
        // Gallery allows multi-select; each file is validated and staged via
        // the cubit (type/size/count, FR-007).
        final List<XFile> files = await _picker.pickMultiImage();
        if (files.isNotEmpty) {
          await widget.cubit.addPhotos(files);
        }
      } else {
        final XFile? file = await _picker.pickImage(source: source);
        if (file != null) {
          await widget.cubit.addPhoto(file);
        }
      }
    } catch (_) {
      // Picker failure is non-fatal; the form stays usable (FR-007).
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }
}

/// Figma `242:1713` photo-upload card header: 📸 emoji (28px) beside the
/// "Add Photos" title (13/600, `#64748B`) and "Up to 10 photos" hint
/// (11/400, `#94A3B8`). The emoji, sizes and colors mirror the design; tokens
/// map to `textMuted`/`textTertiary` and `.sp` keeps them responsive.
class _PhotoCardHeader extends StatelessWidget {
  const _PhotoCardHeader({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📸',
          style: TextStyle(fontSize: 28.sp, height: 1),
        ),
        SizedBox(width: AppSpacing.md.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.formPhotoAdd,
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                l10n.formPhotoMaxHint,
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w400,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A draggable photo tile in the shared create/edit grid. [badge] (edit-mode
/// "New") is overlaid in the top-leading corner; the remove button is in the
/// top-trailing corner.
class _PhotoTile extends StatelessWidget {
  const _PhotoTile({
    super.key,
    required this.image,
    required this.tooltip,
    required this.onRemove,
    this.badge,
  });

  final Widget image;
  final String tooltip;
  final VoidCallback onRemove;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          child: SizedBox(width: 96.r, height: 96.r, child: image),
        ),
        if (badge != null)
          Positioned(
            top: 4.h,
            left: 4.w,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xs.w,
                vertical: 2.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text(
                badge!,
                style: AppTypography.caption.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        Positioned(
          top: 4.h,
          right: 4.w,
          child: IconButton(
            onPressed: onRemove,
            icon: Icon(Icons.close, size: 18.sp),
            color: AppColors.error,
            tooltip: tooltip,
            style: IconButton.styleFrom(
              backgroundColor: AppColors.surface,
              padding: EdgeInsets.all(4.r),
              minimumSize: Size(28.r, 28.r),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),
      ],
    );
  }
}

class _AddTile extends StatelessWidget {
  const _AddTile({required this.picking, required this.onPick});

  final bool picking;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: picking ? null : onPick,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Container(
        width: 96.r,
        height: 96.r,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(color: AppColors.primaryBorder),
        ),
        child: picking
            ? Padding(
                padding: EdgeInsets.all(AppSpacing.lg.r),
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                Icons.add_a_photo_outlined,
                color: AppColors.textTertiary,
                size: 28.sp,
              ),
      ),
    );
  }
}
