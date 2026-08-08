import 'package:image_picker/image_picker.dart' show XFile;
import 'package:injectable/injectable.dart';

import '../../../core/errors/failures.dart';
import '../data/listing_datasource.dart';
import '../data/models/browse_page.dart';
import '../data/models/browse_query.dart';
import '../data/models/create_listing_request.dart';
import '../data/models/listing_media.dart';
import '../data/models/listing_meta.dart';
import '../data/models/listing_status.dart';
import '../data/models/listing_summary.dart';
import '../data/models/media_order_request.dart';
import '../data/models/pending_media.dart';
import '../data/models/shop_listing.dart';
import '../data/models/staged_media_entry.dart';
import '../data/models/status_update_request.dart';
import '../data/models/update_listing_request.dart';
import 'listing_repository.dart';

@Injectable(as: ListingRepository)
class ListingRepositoryImpl implements ListingRepository {
  ListingRepositoryImpl(this._dataSource);

  final ListingDataSource _dataSource;

  @override
  Future<ListingMeta> fetchMeta() => _dataSource.fetchMeta();

  @override
  Future<BrowsePage> browse(BrowseQuery query) => _dataSource.browse(query);

  @override
  Future<List<ListingSummary>> getMyListings() => _dataSource.getMyListings();

  @override
  Future<ShopListing> getListing(String id) => _dataSource.getListing(id);

  @override
  Future<String> createListing(
    CreateListingRequest request,
    List<XFile> photos, {
    UploadProgress? onProgress,
  }) async {
    final String id = await _dataSource.createListing(request);
    if (photos.isEmpty) return id;
    try {
      await _dataSource.uploadMedia(id, photos, onProgress: onProgress);
      return id;
    } on Failure catch (failure) {
      if (failure is MediaUploadFailed) rethrow;
      throw const MediaUploadFailed('');
    } catch (_) {
      throw const MediaUploadFailed('');
    }
  }

  @override
  Future<ShopListing> updateListing(
    String id,
    UpdateListingRequest request,
  ) =>
      _dataSource.updateListing(id, request);

  @override
  Future<ShopListing> saveEdit({
    required String id,
    required UpdateListingRequest request,
    List<PendingMedia> pendingAdds = const [],
    Set<String> pendingDeletes = const {},
    List<StagedMediaEntry> pendingOrder = const [],
    UploadProgress? onProgress,
  }) async {
    // 1. Fresh server snapshot at the start of EVERY attempt so retries
    //    converge (D6). A 404 here → `ListingNotFound` ("listing no longer
    //    exists") + the UI returns to My Listings.
    final ShopListing fresh = await _dataSource.getListing(id);

    // 2. Fields only — status is NEVER part of an edit (FR-010).
    await _dataSource.updateListing(id, request);

    // 3. Staged photo adds — one batched multipart upload (media-upload.md).
    //    The real `ListingMedia`s come back in the same order as [pendingAdds].
    final List<ListingMedia> uploaded = pendingAdds.isEmpty
        ? const []
        : await _dataSource.uploadMedia(
            id,
            pendingAdds.map((PendingMedia media) => media.file).toList(),
            onProgress: onProgress,
          );

    // 4. Staged photo deletes.
    for (final String mediaId in pendingDeletes) {
      await _dataSource.deleteMedia(id, mediaId);
    }

    // 5. Final media order — walk [pendingOrder] mapping existing slots to
    //    their server ids and add slots to the freshly uploaded ids; append
    //    any server media that was not part of the staging (e.g. added by
    //    another actor since the snapshot) so reorder is never lossy.
    final Map<int, ListingMedia> uploadedByClientId = {
      for (int i = 0; i < pendingAdds.length && i < uploaded.length; i++)
        pendingAdds[i].clientId: uploaded[i],
    };
    final List<ListingMedia> freshOrdered = [...fresh.media]
      ..sort((ListingMedia a, ListingMedia b) =>
          a.sortOrder.compareTo(b.sortOrder));
    final Set<String> survivingIds = {
      for (final ListingMedia media in freshOrdered)
        if (!pendingDeletes.contains(media.id)) media.id,
    };

    final List<String> finalOrder = [];
    for (final StagedMediaEntry entry in pendingOrder) {
      if (entry.isAdd) {
        final ListingMedia? uploadedMedia = uploadedByClientId[entry.clientId];
        if (uploadedMedia != null && !finalOrder.contains(uploadedMedia.id)) {
          finalOrder.add(uploadedMedia.id);
        }
      } else {
        final String? mediaId = entry.mediaId;
        if (mediaId != null && survivingIds.contains(mediaId)) {
          finalOrder.add(mediaId);
        }
      }
    }
    for (final ListingMedia media in freshOrdered) {
      if (survivingIds.contains(media.id) && !finalOrder.contains(media.id)) {
        finalOrder.add(media.id);
      }
    }

    // Only commit a reorder when the order is not already the fresh one.
    final bool orderChanged =
        finalOrder.join(',') != survivingIds.join(',');
    if (orderChanged && finalOrder.isNotEmpty) {
      await _dataSource.reorderMedia(
        id,
        MediaOrderRequest(
          media: [
            for (final (int i, String mediaId) in finalOrder.indexed)
              MediaOrderEntry(mediaId: mediaId, sortOrder: i),
          ],
        ),
      );
    }

    // 6. Return the saved listing (fresh re-fetch so the detail/local list
    //    converge, FR-009).
    return _dataSource.getListing(id);
  }

  @override
  Future<void> changeStatus(String id, ListingStatus status) =>
      _dataSource.updateStatus(id, StatusUpdateRequest(status: status));

  @override
  Future<void> deleteListing(String id) => _dataSource.deleteListing(id);

  @override
  Future<List<ListingMedia>> uploadMedia(
    String id,
    List<XFile> files, {
    UploadProgress? onProgress,
  }) =>
      _dataSource.uploadMedia(id, files, onProgress: onProgress);

  @override
  Future<List<ListingMedia>> reorderMedia(
    String id,
    MediaOrderRequest request,
  ) =>
      _dataSource.reorderMedia(id, request);

  @override
  Future<List<ListingMedia>> deleteMedia(String id, String mediaId) =>
      _dataSource.deleteMedia(id, mediaId);
}
