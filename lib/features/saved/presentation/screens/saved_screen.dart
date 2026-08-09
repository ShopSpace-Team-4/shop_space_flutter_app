import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injectable.dart';
import '../../../../core/errors/failure_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../data/models/saved_listing.dart';
import '../../repository/saved_listings_repository.dart';
import '../cubits/saved_listings_cubit.dart';
import '../widgets/saved_listing_card.dart';

/// Saved shops screen (US5, T056; replaces the Phase 0 placeholder, Figma
/// Saved frame `242:2494`): AppBar "Saved" + a `BlocBuilder` over
/// [SavedListingsCubit] rendering the saved card list, a localized empty
/// state, and a localized error + retry. Every unsave from anywhere disappears
/// on refresh (FR-013) and every save from anywhere appears (SC-006) because
/// the cubit refetches `getSavedListings()` on open/refresh through the ONE
/// shared [SavedListingsRepository] (D8). Tapping a card pushes the shop
/// detail `/search/:listingId` (US2).
///
/// All sizes/spacing scale with screenutil; flex layout adapts at every
/// breakpoint.
class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  late final SavedListingsCubit _cubit;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _cubit = SavedListingsCubit(
      savedListingsRepository: getIt<SavedListingsRepository>(),
    );
    _cubit.load();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return BlocListener<SavedListingsCubit, SavedListingsState>(
      bloc: _cubit,
      listener: (context, state) {
        final Failure? transient = state.transientFailure;
        if (transient != null) {
          final AppLocalizations sheetL10n = AppLocalizations.of(context);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(failureMessage(sheetL10n, transient))),
            );
          _cubit.clearTransientFailure();
        }
      },
      child: BlocBuilder<SavedListingsCubit, SavedListingsState>(
        bloc: _cubit,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.savedTitle),
              centerTitle: true,
            ),
            body: _buildBody(state),
          );
        },
      ),
    );
  }

  Widget _buildBody(SavedListingsState state) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    if (state.failure != null) {
      return AppErrorView(failure: state.failure!, onRetry: _cubit.load);
    }
    if (state.isLoading && !state.loaded) {
      return const AppLoadingView();
    }
    if (state.loaded && state.items.isEmpty) {
      return AppEmptyView(
        title: l10n.savedEmptyTitle,
        message: l10n.savedEmptyMessage,
      );
    }
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, AppSpacing.xl.h),
      itemCount: state.items.length,
      separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md.h),
      itemBuilder: (context, index) {
        final SavedListing listing = state.items[index];
        return SavedListingCard(
          listing: listing,
          onTap: () => context.push('/search/${listing.id}'),
          onToggleSaved: () => _cubit.unsave(listing.id),
        );
      },
    );
  }
}
