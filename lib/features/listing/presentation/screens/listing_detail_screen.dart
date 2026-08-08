import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injectable.dart';
import '../../../../core/errors/failure_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../data/models/listing_status.dart';
import '../../data/models/shop_listing.dart';
import '../../repository/listing_repository.dart';
import '../cubits/my_listings_cubit.dart';
import '../widgets/listing_detail_pane.dart';
import '../widgets/status_picker.dart';

/// Full listing detail (US2/T031): loads the [ShopListing] via
/// [MyListingsCubit.loadDetail] and renders the shared [ListingDetailPane].
/// Used on compact/medium as a pushed route; the expanded two-pane reuses the
/// same pane widget directly.
class ListingDetailScreen extends StatefulWidget {
  const ListingDetailScreen({super.key, required this.listingId});

  final String listingId;

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  late final MyListingsCubit _cubit;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _cubit = MyListingsCubit(repository: getIt<ListingRepository>());
    _cubit.loadDetail(widget.listingId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.detailBackToMyListings),
        leading: BackButton(
          onPressed: () {
            final NavigatorState navigator = Navigator.of(context);
            if (navigator.canPop()) {
              navigator.pop();
            } else {
              context.go('/my-listings');
            }
          },
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<MyListingsCubit, MyListingsState>(
          bloc: _cubit,
          builder: (context, state) {
            final ShopListing? listing = state.detail;
            if (listing != null) {
              return ListingDetailPane(
                listing: listing,
                isSubmitting: state.isSubmitting,
                onStatusPressed: () => _showStatusPicker(listing),
                onEditPressed: () =>
                    context.push('/listing-form/${listing.id}'),
                onDeletePressed: () => _confirmDelete(listing),
              );
            }
            if (state.detailFailure != null) {
              return _DetailError(
                failure: state.detailFailure!,
                onRetry: () => _cubit.loadDetail(widget.listingId),
              );
            }
            return const AppLoadingView();
          },
        ),
      ),
    );
  }

  Future<void> _showStatusPicker(ShopListing listing) async {
    await StatusPickerSheet.show(
      context,
      current: listing.status,
      isSubmitting: _cubit.state.isSubmitting,
      failure: _cubit.state.statusFailure,
      onSelected: (ListingStatus status) async {
        Navigator.of(context).pop();
        if (status == listing.status) return;
        await _cubit.changeStatus(listing.id, status);
        if (!mounted) return;
        final Failure? failure = _cubit.state.statusFailure;
        if (failure != null) {
          _showMessage(failureMessage(AppLocalizations.of(context), failure));
        }
      },
    );
  }

  /// Delete flow (US4/T061): an explicit confirmation dialog (FR-012) — there
  /// is no Figma frame for it, so it is built from the existing `core/theme`
  /// tokens per the gap protocol (T057). Confirm → DELETE; a typed failure is
  /// surfaced locally; success removes the listing + photos and returns to My
  /// Listings.
  Future<void> _confirmDelete(ShopListing listing) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteConfirmTitle),
        content: Text(l10n.deleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.deleteConfirmAction),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    await _cubit.deleteListing(listing.id);
    if (!mounted) return;

    final Failure? failure = _cubit.state.deleteFailure;
    if (failure != null) {
      _showMessage(failureMessage(l10n, failure));
      return;
    }
    if (_cubit.state.detail == null) {
      _showMessage(l10n.deleteSuccess);
      if (mounted) context.pop();
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
