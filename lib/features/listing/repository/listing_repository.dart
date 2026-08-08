import 'package:image_picker/image_picker.dart' show XFile;

import '../data/listing_datasource.dart' show UploadProgress;
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
import '../data/models/update_listing_request.dart';

/// Application use-case surface for landlord listing management (contract
/// `contracts/listings-api.md`). A repository interface method IS the use case
/// (constitution §Architecture). Methods surface only typed failures — never
/// raw exceptions (guaranteed by [ListingDataSource]).
abstract class ListingRepository {
  Future<ListingMeta> fetchMeta();

  /// Browse/search the public marketplace (`GET /listings`). Delegates the
  /// query straight to the datasource — no orchestration (the caller owns
  /// filtering/pagination).
  Future<BrowsePage> browse(BrowseQuery query);

  Future<List<ListingSummary>> getMyListings();

  Future<ShopListing> getListing(String id);

  /// Creates a PENDING listing (FR-006) and returns its id. The multi-call
  /// create → photo-upload orchestration lands in US1 (T046); photos are
  /// accepted now so the signature is stable.
  Future<String> createListing(
    CreateListingRequest request,
    List<XFile> photos, {
    UploadProgress? onProgress,
  });

  Future<ShopListing> updateListing(String id, UpdateListingRequest request);

  /// Strict all-or-nothing edit save (D6): field update + staged media adds /
  /// deletes / reorder commit together; any failure reports "nothing was
  /// saved". The protocol is implemented in US3 (T053). [pendingOrder] is the
  /// full desired final media order (existing ids + adds in position,
  /// data-model.md §3.2).
  Future<ShopListing> saveEdit({
    required String id,
    required UpdateListingRequest request,
    List<PendingMedia> pendingAdds = const [],
    Set<String> pendingDeletes = const {},
    List<StagedMediaEntry> pendingOrder = const [],
    UploadProgress? onProgress,
  });

  Future<void> changeStatus(String id, ListingStatus status);

  Future<void> deleteListing(String id);

  Future<List<ListingMedia>> uploadMedia(
    String id,
    List<XFile> files, {
    UploadProgress? onProgress,
  });

  Future<List<ListingMedia>> reorderMedia(String id, MediaOrderRequest request);

  Future<List<ListingMedia>> deleteMedia(String id, String mediaId);
}
