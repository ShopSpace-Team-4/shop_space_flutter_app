import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injectable.dart';
import '../../../listing/repository/listing_repository.dart';
import '../../../saved/repository/saved_listings_repository.dart';
import '../cubits/listing_detail_cubit.dart';
import '../widgets/shop_detail_pane.dart';

/// Tenant shop-detail screen (US2, T030): loads the [ShopListing] via
/// [ListingDetailCubit] and renders the shared [ShopDetailPane]. Used on
/// compact/medium as a pushed route (`/search/:listingId`, T031); the expanded
/// two-pane (T032) reuses the same pane widget directly, so both render
/// identically (D10, contract `responsive-search-layout.md`).
///
/// Locked redesign (Figma `97:5547`, 2026-08-10): the screen has NO AppBar —
/// the pane draws its own back-circle overlay ([ShopDetailPane.onBack]) over
/// the full-bleed gallery, which extends under the status bar. The Scaffold is
/// kept (without `top` SafeArea) so loading/error/snackbar hosts still work
/// while the gallery stays edge-to-edge at the top.
class ShopDetailScreen extends StatefulWidget {
  const ShopDetailScreen({super.key, required this.listingId});

  final String listingId;

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  late final ListingDetailCubit _cubit;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _cubit = ListingDetailCubit(
      listingRepository: getIt<ListingRepository>(),
      savedListingsRepository: getIt<SavedListingsRepository>(),
    );
    _cubit.load(widget.listingId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _goBack() {
    final NavigatorState navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      context.go('/search');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: BlocBuilder<ListingDetailCubit, ListingDetailState>(
          bloc: _cubit,
          builder: (context, state) {
            return ShopDetailPane(
              state: state,
              onBack: _goBack,
              onToggleSaved: () => _cubit.toggleSaved(),
              onRetry: () => _cubit.load(widget.listingId),
              onReturnToResults: _goBack,
            );
          },
        ),
      ),
    );
  }
}
