import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/dio_failure.dart';
import 'models/saved_listing.dart';

/// Raw network surface for the save/unsave/saved-list endpoints (contract
/// `contracts/saved-listings.md` §7). This is the ONLY code that touches dio
/// for the saved feature. Methods throw typed [Failure]s only — never raw
/// [DioException]s.
///
/// All endpoints are Bearer-required (the token is attached by the Phase 0
/// dio interceptor) and the envelope `{ message, status, data }` is unwrapped
/// once by the dio layer — `save`/`unsave` return a bare `{}`, and
/// `getSavedListings` returns a bare `List<SavedListing>` array with no
/// pagination meta.
abstract class SavedListingsDataSource {
  /// `POST /listings/:id/save` — idempotent (§7.1): a re-tap after a transient
  /// failure converges.
  Future<void> save(String listingId);

  /// `DELETE /listings/:id/save` — idempotent (§7.2).
  Future<void> unsave(String listingId);

  /// `GET /users/me/saved-listings` — bare array of [SavedListing], no
  /// pagination meta.
  Future<List<SavedListing>> getSavedListings();
}

@Injectable(as: SavedListingsDataSource)
class SavedListingsDataSourceImpl implements SavedListingsDataSource {
  SavedListingsDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<void> save(String listingId) =>
      _request<void>(() => _dio.post<dynamic>('/listings/$listingId/save'));

  @override
  Future<void> unsave(String listingId) =>
      _request<void>(() => _dio.delete<dynamic>('/listings/$listingId/save'));

  @override
  Future<List<SavedListing>> getSavedListings() async {
    final Response<dynamic> response = await _request<Response<dynamic>>(
      () => _dio.get<dynamic>('/users/me/saved-listings'),
    );
    final List<dynamic> rawListings = response.data as List<dynamic>;
    return rawListings
        .map((dynamic e) => SavedListing.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Runs [call] and rethrows the typed [Failure] the pipeline attached to any
  /// [DioException] (see `lib/core/errors/dio_failure.dart`).
  Future<T> _request<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (error) {
      throw error.failure;
    }
  }
}
