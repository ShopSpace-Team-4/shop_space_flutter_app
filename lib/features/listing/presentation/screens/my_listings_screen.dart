import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injectable.dart';
import '../../../../core/errors/failure_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/responsive/window_size.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../data/models/listing_status.dart';
import '../../data/models/listing_summary.dart';
import '../../data/models/shop_listing.dart';
import '../../repository/listing_repository.dart';
import '../cubits/my_listings_cubit.dart';
import '../list_a_shop_flow.dart';
import '../widgets/listing_card.dart';
import '../widgets/listing_detail_pane.dart';
import '../widgets/status_picker.dart';

/// Landlord home base (US2/T030): two-pane list + detail on expanded
/// (≥840dp), single-pane list pushing `/my-listings/:listingId` on
/// compact/medium (FR-015, D8). Lazy `ListView.builder` (bare array, no
/// pagination); loading / error+retry / empty states; pull-to-refresh;
/// "List a shop" CTA → gate on `roles[]`: landlord → `/listing-form`,
/// tenant → Become-a-Landlord sheet (US1/T047, FR-001/FR-002).
class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  late final MyListingsCubit _cubit;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _cubit = MyListingsCubit(repository: getIt<ListingRepository>());
    _cubit.loadList();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  /// "List a shop" entry (FR-001/FR-002): shared roles[] gate — landlord goes
  /// straight to the form, tenant gets the Become-a-Landlord sheet
  /// ([openCreateListingFlow]). Never gates on `activeRole` (FR-013).
  void _openCreateFlow() => openCreateListingFlow(context);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool expanded = breakpointOf(context) == AppBreakpoint.expanded;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(
          onPressed: () {
            final NavigatorState navigator = Navigator.of(context);
            if (navigator.canPop()) {
              navigator.pop();
            } else {
              context.go('/profile');
            }
          },
        ),
        title: Text(l10n.myListingsTitle),
      ),
      body: SafeArea(
        child: BlocBuilder<MyListingsCubit, MyListingsState>(
          bloc: _cubit,
          builder: (context, state) {
            if (expanded) {
              return _ExpandedPane(
                cubit: _cubit,
                state: state,
                onListAShop: _openCreateFlow,
              );
            }
            return _CompactPane(
              cubit: _cubit,
              state: state,
              onListAShop: _openCreateFlow,
            );
          },
        ),
      ),
    );
  }
}

class _CompactPane extends StatelessWidget {
  const _CompactPane({
    required this.cubit,
    required this.state,
    required this.onListAShop,
  });

  final MyListingsCubit cubit;
  final MyListingsState state;
  final VoidCallback onListAShop;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && state.listings.isEmpty) {
      return const AppLoadingView();
    }
    if (state.listFailure != null && state.listings.isEmpty) {
      return AppErrorView(failure: state.listFailure!, onRetry: cubit.loadList);
    }
    if (state.listings.isEmpty) {
      return _MyListingsEmpty(onListAShop: onListAShop);
    }
    return RefreshIndicator(
      onRefresh: cubit.refresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppSpacing.lg.r),
        itemCount: state.listings.length,
        itemBuilder: (context, index) {
          final ListingSummary summary = state.listings[index];
          return Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.md.h),
            child: ListingCard(
              summary: summary,
              onTap: () async {
                await context.push('/my-listings/${summary.id}');
                // The pushed detail owns a separate Cubit instance, so the
                // list is refreshed on return to converge after a status
                // change or delete performed there (T062).
                if (context.mounted) cubit.refresh();
              },
            ),
          );
        },
      ),
    );
  }
}

class _ExpandedPane extends StatelessWidget {
  const _ExpandedPane({
    required this.cubit,
    required this.state,
    required this.onListAShop,
  });

  final MyListingsCubit cubit;
  final MyListingsState state;
  final VoidCallback onListAShop;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 420.w,
          child: _listPane(context),
        ),
        const VerticalDivider(width: 1, thickness: 1),
        Expanded(child: _detailPane(context)),
      ],
    );
  }

  Widget _listPane(BuildContext context) {
    if (state.isLoading && state.listings.isEmpty) {
      return const AppLoadingView();
    }
    if (state.listFailure != null && state.listings.isEmpty) {
      return AppErrorView(failure: state.listFailure!, onRetry: cubit.loadList);
    }
    if (state.listings.isEmpty) {
      return _MyListingsEmpty(onListAShop: onListAShop);
    }
    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.lg.r),
      itemCount: state.listings.length,
      itemBuilder: (context, index) {
        final ListingSummary summary = state.listings[index];
        return Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.md.h),
          child: ListingCard(
            summary: summary,
            onTap: () => cubit.loadDetail(summary.id),
          ),
        );
      },
    );
  }

  Widget _detailPane(BuildContext context) {
    if (state.detailLoading) {
      return const AppLoadingView();
    }
    if (state.detailFailure != null) {
      return Padding(
        padding: EdgeInsets.all(AppSpacing.xl.r),
        child: AppErrorView(
          failure: state.detailFailure!,
          onRetry: () => cubit.loadDetail(state.detail?.id ?? ''),
        ),
      );
    }
    if (state.detail != null) {
      return ListingDetailPane(
        listing: state.detail!,
        isSubmitting: state.isSubmitting,
        onStatusPressed: () => _showStatusPicker(context, state.detail!),
        onEditPressed: () => context.push('/listing-form/${state.detail!.id}'),
        onDeletePressed: () => _confirmDelete(context, state.detail!),
      );
    }
    return const _SelectHint();
  }

  Future<void> _showStatusPicker(BuildContext context, ShopListing listing) async {
    await StatusPickerSheet.show(
      context,
      current: listing.status,
      isSubmitting: cubit.state.isSubmitting,
      failure: cubit.state.statusFailure,
      onSelected: (ListingStatus status) async {
        Navigator.of(context).pop();
        if (status == listing.status) return;
        await cubit.changeStatus(listing.id, status);
        if (!context.mounted) return;
        final Failure? failure = cubit.state.statusFailure;
        if (failure != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(failureMessage(AppLocalizations.of(context), failure)),
            ),
          );
        }
      },
    );
  }

  /// Delete flow for the expanded two-pane (US4/T061): confirmation dialog
  /// built from existing `core/theme` tokens (no Figma frame — T057), then
  /// DELETE via the shared Cubit. Success clears the pane (back to the select
  /// hint); failures surface the typed localized message.
  Future<void> _confirmDelete(BuildContext context, ShopListing listing) async {
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
    if (confirmed != true || !context.mounted) return;

    await cubit.deleteListing(listing.id);
    if (!context.mounted) return;

    final Failure? failure = cubit.state.deleteFailure;
    if (failure != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failureMessage(l10n, failure))),
      );
      return;
    }
    if (cubit.state.detail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.deleteSuccess)),
      );
    }
  }
}

class _MyListingsEmpty extends StatelessWidget {
  const _MyListingsEmpty({required this.onListAShop});

  final VoidCallback onListAShop;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppEmptyView(
            title: l10n.myListingsEmptyTitle,
            message: l10n.myListingsEmptyMessage,
          ),
          SizedBox(height: AppSpacing.xl.h),
          FilledButton.icon(
            onPressed: onListAShop,
            icon: const Icon(Icons.add),
            label: Text(l10n.myListingsListAShop),
          ),
        ],
      ),
    );
  }
}

class _SelectHint extends StatelessWidget {
  const _SelectHint();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Center(
      child: Text(
        l10n.myListingsEmptyMessage,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}
