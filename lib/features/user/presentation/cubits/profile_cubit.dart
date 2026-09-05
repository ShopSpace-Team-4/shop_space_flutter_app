import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failure_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../listing/data/models/listing_status.dart';
import '../../../listing/repository/listing_repository.dart';
import '../../data/models/user.dart';
import '../../repository/user_repository.dart';
import '../../../auth/google/auth_google_service.dart';

part 'profile_cubit.freezed.dart';

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(false) bool isLoading,
    User? user,
    String? errorMessage,
    @Default(false) bool isLinking,
    @Default(false) bool linkSuccess,
    String? linkError,
    @Default(false) bool isUpdating,
    @Default(false) bool updateSuccess,
    String? updateError,
    @Default(0) int listingsCount,
    @Default(0) int activeListingsCount,
  }) = _ProfileState;
}

/// Account-screen data loader (T034, US6): fetches the signed-in user's
/// profile (name/email) via `UserRepository.getProfile()` and exposes
/// loading/loaded/error states. Also links a Google identity to the existing
/// password account (`UserRepository.linkGoogle`, API guide §5.6), updates the
/// profile name/phone (`UserRepository.updateProfile`, §5.2), and loads the
/// landlord listing counts shown in the header stats card
/// (silent-on-failure — never blocks the header).
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required UserRepository repository,
    required AuthGoogleService googleAuth,
    required ListingRepository listingRepository,
    required AppLocalizations l10n,
  })  : _repository = repository,
        _googleAuth = googleAuth,
        _listingRepository = listingRepository,
        _l10n = l10n,
        super(const ProfileState());

  final UserRepository _repository;
  final AuthGoogleService _googleAuth;
  final ListingRepository _listingRepository;
  final AppLocalizations _l10n;

  bool _statsLoading = false;

  Future<void> load() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final User user = await _repository.getProfile();
      emit(state.copyWith(isLoading: false, user: user));
    } on Failure catch (failure) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: failureMessage(_l10n, failure),
      ));
    } catch (_) {
      emit(state.copyWith(isLoading: false, errorMessage: _l10n.errorServer));
    }
  }

  /// Loads the My Listings summary for the header stats (US6, Figma
  /// `242:2958`). `activeListingsCount` counts only the `available` listings.
  /// Failures are silent on purpose — a stats hiccup must never block the
  /// header or surface an error screen. The `finally` guarantees the re-entry
  /// guard resets even when a [Failure] (which is not an `Exception`) escapes
  /// the repository call, so the stats can always be retried.
  Future<void> loadListingStats() async {
    if (_statsLoading) return;
    _statsLoading = true;
    try {
      final listings = await _listingRepository.getMyListings();
      emit(state.copyWith(
        listingsCount: listings.length,
        activeListingsCount: listings
            .where((listing) => listing.status == ListingStatus.available)
            .length,
      ));
    } catch (_) {
      // Intentional no-op: stats stay at their previous values on failure.
    } finally {
      _statsLoading = false;
    }
  }

  /// Links the signed-in Google identity to this account. A dismissed Google
  /// sheet is a silent no-op (contract `contracts/google-signin-flow.md`);
  /// every other failure surfaces as [ProfileState.linkError] (consumed as a
  /// SnackBar). Success sets [ProfileState.linkSuccess] (also consumed as a
  /// SnackBar).
  Future<void> linkGoogle() async {
    if (state.isLinking) return;
    emit(state.copyWith(isLinking: true, linkSuccess: false, linkError: null));
    try {
      final String idToken = await _googleAuth.signInAndGetIdToken();
      await _repository.linkGoogle(idToken);
      emit(state.copyWith(isLinking: false, linkSuccess: true));
    } on GoogleSignInCancelled {
      // Dismissed Google sheet: stay on page, no toast.
      emit(state.copyWith(isLinking: false));
    } on Failure catch (failure) {
      emit(state.copyWith(
        isLinking: false,
        linkError: failureMessage(_l10n, failure),
      ));
    } catch (_) {
      emit(state.copyWith(isLinking: false, linkError: _l10n.errorServer));
    }
  }

  /// Clears the transient link feedback ([ProfileState.linkSuccess] /
  /// [ProfileState.linkError]) after the screen has shown its SnackBar.
  void clearLinkFeedback() {
    emit(state.copyWith(linkSuccess: false, linkError: null));
  }

  /// Updates the profile name/phone via `UserRepository.updateProfile` (API
  /// guide §5.2). The repository recaches the returned [User], which lands in
  /// [ProfileState.user] so the header re-renders immediately. Errors surface
  /// as [ProfileState.updateError]; success sets [ProfileState.updateSuccess]
  /// (both consumed as SnackBars, like [linkGoogle]).
  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    if (state.isUpdating) return;
    emit(state.copyWith(
      isUpdating: true,
      updateSuccess: false,
      updateError: null,
    ));
    try {
      final User user = await _repository.updateProfile(
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        phone: phone,
      );
      emit(state.copyWith(isUpdating: false, updateSuccess: true, user: user));
    } on Failure catch (failure) {
      emit(state.copyWith(
        isUpdating: false,
        updateError: failureMessage(_l10n, failure),
      ));
    } catch (_) {
      emit(state.copyWith(isUpdating: false, updateError: _l10n.errorServer));
    }
  }

  /// Clears the transient update feedback ([ProfileState.updateSuccess] /
  /// [ProfileState.updateError]) after the screen has shown its SnackBar.
  void clearUpdateFeedback() {
    emit(state.copyWith(updateSuccess: false, updateError: null));
  }
}
