import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart' show XFile;
import 'package:injectable/injectable.dart';

import '../../../core/errors/dio_failure.dart';
import 'models/browse_page.dart';
import 'models/browse_query.dart';
import 'models/create_listing_request.dart';
import 'models/listing_media.dart';
import 'models/listing_meta.dart';
import 'models/listing_summary.dart';
import 'models/media_order_request.dart';
import 'models/shop_listing.dart';
import 'models/status_update_request.dart';
import 'models/update_listing_request.dart';

/// Upload progress callback, mirroring dio's `onSendProgress` shape without
/// leaking dio types into the repository/presentation layers.
typedef UploadProgress = void Function(int sent, int total);

/// Raw network surface for the `/listings*` endpoints (contract
/// `contracts/listings-api.md`). This is the ONLY code that touches dio for the
/// listing feature. Methods throw typed [Failure]s only — never raw
/// [DioException]s.
abstract class ListingDataSource {
  Future<ListingMeta> fetchMeta();

  /// Browse/search the public marketplace (`GET /listings`, API guide §5.2).
  /// Optional auth: `isSaved` is only populated when a valid token is sent.
  Future<BrowsePage> browse(BrowseQuery query);

  /// Creates a listing (starts PENDING server-side, FR-006) and returns the
  /// created id. The response is minimal (API guide §5.1) — the repository
  /// re-fetches `GET /listings/:id` for the full detail.
  Future<String> createListing(CreateListingRequest request);

  Future<List<ListingSummary>> getMyListings();

  Future<ShopListing> getListing(String id);

  Future<ShopListing> updateListing(String id, UpdateListingRequest request);

  Future<void> updateStatus(String id, StatusUpdateRequest request);

  Future<void> deleteListing(String id);

  /// Uploads [files] as one batched multipart request (repeated `photos`
  /// fields, media-upload.md) and returns the created media in `sortOrder`.
  Future<List<ListingMedia>> uploadMedia(
    String id,
    List<XFile> files, {
    UploadProgress? onProgress,
  });

  Future<List<ListingMedia>> reorderMedia(String id, MediaOrderRequest request);

  Future<List<ListingMedia>> deleteMedia(String id, String mediaId);
}

@Injectable(as: ListingDataSource)
class ListingDataSourceImpl implements ListingDataSource {
  ListingDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<ListingMeta> fetchMeta() async {
    final Response<dynamic> response = await _request<Response<dynamic>>(
      () => _dio.get<dynamic>('/listings/meta'),
    );
    return ListingMeta.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<BrowsePage> browse(BrowseQuery query) async {
    final Response<dynamic> response = await _request<Response<dynamic>>(
      () => _dio.get<dynamic>(
        '/listings',
        queryParameters: query.toQueryParameters(),
      ),
    );
    return BrowsePage.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<String> createListing(CreateListingRequest request) async {
    final Response<dynamic> response = await _request<Response<dynamic>>(
      () => _dio.post<dynamic>('/listings', data: request.toJson()),
    );
    return (response.data as Map<String, dynamic>)['id'] as String;
  }

  @override
  Future<List<ListingSummary>> getMyListings() async {
    final Response<dynamic> response = await _request<Response<dynamic>>(
      () => _dio.get<dynamic>('/listings/my-listings'),
    );
    final List<dynamic> rawListings = response.data as List<dynamic>;
    return rawListings
        .map((dynamic e) => ListingSummary.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ShopListing> getListing(String id) async {
    final Response<dynamic> response = await _request<Response<dynamic>>(
      () => _dio.get<dynamic>('/listings/$id'),
    );
    return ShopListing.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<ShopListing> updateListing(
    String id,
    UpdateListingRequest request,
  ) async {
    final Response<dynamic> response = await _request<Response<dynamic>>(
      () => _dio.put<dynamic>('/listings/$id', data: request.toJson()),
    );
    return ShopListing.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> updateStatus(String id, StatusUpdateRequest request) =>
      _request<void>(
        () => _dio.patch<dynamic>('/listings/$id/status', data: request.toJson()),
      );

  @override
  Future<void> deleteListing(String id) =>
      _request<void>(() => _dio.delete<dynamic>('/listings/$id'));

  @override
  Future<List<ListingMedia>> uploadMedia(
    String id,
    List<XFile> files, {
    UploadProgress? onProgress,
  }) async {
    final FormData form = FormData();
    for (final XFile file in files) {
      form.files.add(MapEntry<String, MultipartFile>(
        'photos',
        MultipartFile.fromFileSync(
          file.path,
          contentType: DioMediaType(
            'image',
            file.mimeType?.split('/').last ?? 'jpeg',
          ),
        ),
      ));
    }
    final Response<dynamic> response = await _request<Response<dynamic>>(
      () => _dio.post<dynamic>(
        '/listings/$id/media',
        data: form,
        onSendProgress: onProgress,
      ),
    );
    return _mediaFromData(response.data);
  }

  @override
  Future<List<ListingMedia>> reorderMedia(
    String id,
    MediaOrderRequest request,
  ) async {
    final Response<dynamic> response = await _request<Response<dynamic>>(
      () => _dio.put<dynamic>('/listings/$id/media/reorder', data: request.toJson()),
    );
    return _mediaFromData(response.data);
  }

  @override
  Future<List<ListingMedia>> deleteMedia(String id, String mediaId) async {
    final Response<dynamic> response = await _request<Response<dynamic>>(
      () => _dio.delete<dynamic>('/listings/$id/media/$mediaId'),
    );
    return _mediaFromData(response.data);
  }

  /// Parses the `{ id, media: [ListingMedia] }` success payload shared by the
  /// media upload/reorder/delete endpoints.
  List<ListingMedia> _mediaFromData(dynamic data) {
    final List<dynamic> rawMedia =
        (data as Map<String, dynamic>)['media'] as List<dynamic>;
    return rawMedia
        .map((dynamic e) => ListingMedia.fromJson(e as Map<String, dynamic>))
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
