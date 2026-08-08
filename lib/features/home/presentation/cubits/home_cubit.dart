import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../../listing/data/models/browse_listing.dart';
import '../../../listing/data/models/browse_page.dart';
import '../../../listing/data/models/browse_query.dart';
import '../../../listing/data/models/listing_meta.dart';
import '../../../listing/data/models/listing_status.dart';
import '../../../listing/repository/listing_repository.dart';
import '../../../user/data/models/user.dart';
import '../../../user/repository/user_repository.dart';

part 'home_cubit.freezed.dart';

/// Tenant-facing home feed state (Figma `95:4028`).
@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(false) bool isLoading,
    @Default([]) List<String> categories,
    @Default([]) List<BrowseListing> recommended,
    @Default([]) List<BrowseListing> nearby,
    User? user,
    Failure? failure,
  }) = _HomeState;
}

/// Loads everything the home screen renders in parallel: category chips from
/// `GET /listings/meta`, the Recommended rail (AVAILABLE, limit 5), Nearby
/// Listings (AVAILABLE, limit 3), and the greeting profile. The profile is
/// best-effort — if `getProfile()` fails the page still renders with a generic
/// greeting instead of a failure state.
class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required ListingRepository listingRepository,
    required UserRepository userRepository,
  })  : _listingRepository = listingRepository,
        _userRepository = userRepository,
        super(const HomeState());

  final ListingRepository _listingRepository;
  final UserRepository _userRepository;

  Future<void> load() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, failure: null));

    final User? user = await _loadProfileBestEffort();

    try {
      final (
        ListingMeta meta,
        BrowsePage recommendedPage,
        BrowsePage nearbyPage,
      ) = await (
        _listingRepository.fetchMeta(),
        _listingRepository.browse(
          const BrowseQuery(
            status: ListingStatus.available,
            limit: 5,
          ),
        ),
        _listingRepository.browse(
          const BrowseQuery(
            status: ListingStatus.available,
            limit: 3,
          ),
        ),
      ).wait;

      emit(HomeState(
        isLoading: false,
        categories: meta.categories,
        recommended: recommendedPage.items,
        nearby: nearbyPage.items,
        user: user,
      ));
    } on Failure catch (failure) {
      emit(state.copyWith(isLoading: false, failure: failure));
    } catch (_) {
      emit(state.copyWith(isLoading: false, failure: const ServerFailure('')));
    }
  }

  /// Greeting/avatar data is a nicety, never a blocker: swallow any failure so
  /// the feed still renders with a generic greeting (plan §4).
  Future<User?> _loadProfileBestEffort() async {
    try {
      return await _userRepository.getProfile();
    } on Failure {
      return null;
    } catch (_) {
      return null;
    }
  }
}
