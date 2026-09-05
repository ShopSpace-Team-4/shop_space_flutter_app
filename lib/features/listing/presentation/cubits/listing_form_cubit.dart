import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart' show XFile;

import '../../../../core/errors/failures.dart';
import '../../data/models/create_listing_request.dart';
import '../../data/models/listing_media.dart';
import '../../data/models/listing_meta.dart';
import '../../data/models/pending_media.dart';
import '../../data/models/shop_listing.dart';
import '../../data/models/staged_media_entry.dart';
import '../../data/models/update_listing_request.dart';
import '../../repository/listing_repository.dart';

part 'listing_form_cubit.freezed.dart';

/// Field keys used by the form layer (widgets) to read/write
/// [ListingFormState.fields]. Values mirror the [CreateListingRequest] body so
/// the review step renders from the same map the cubit submits.
abstract final class ListingFormFieldKeys {
  static const String title = 'title';
  static const String category = 'category';
  static const String areaSqm = 'areaSqm';
  static const String city = 'city';
  static const String district = 'district';
  static const String address = 'address';
  static const String description = 'description';
  static const String amenities = 'amenities';
  static const String numberOfFloors = 'numberOfFloors';
  static const String floorNumber = 'floorNumber';
  static const String availableFrom = 'availableFrom';
  static const String minimumLeaseTerm = 'minimumLeaseTerm';
  static const String annualRent = 'annualRent';
  static const String currency = 'currency';
  static const String securityDepositMonths = 'securityDepositMonths';
}

@freezed
abstract class ListingFormState with _$ListingFormState {
  const factory ListingFormState({
    /// 0 details, 1 photos, 2 price/lease, 3 review (data-model.md §4).
    @Default(0) int step,
    ListingMeta? meta,
    @Default(false) bool metaLoading,
    Failure? metaFailure,
    @Default(<String, dynamic>{}) Map<String, dynamic> fields,
    @Default(<ListingMedia>[]) List<ListingMedia> existingMedia,
    @Default(<PendingMedia>[]) List<PendingMedia> pendingAdds,
    @Default(<String>{}) Set<String> pendingDeletes,
    @Default(<StagedMediaEntry>[]) List<StagedMediaEntry> pendingOrder,
    @Default(false) bool preloading,
    Failure? preloadFailure,
    @Default(false) bool isSubmitting,
    @Default(false) bool isUploading,
    @Default(0.0) double uploadProgress,
    Failure? submitFailure,
    @Default(false) bool isEditMode,
    String? createdId,
    String? updatedId,
  }) = _ListingFormState;
}

/// Shared create/edit listing form (US1/T040, contract `listing-form.md`).
///
/// One cubit for both entry points (D1) — [isEditMode] is the only difference.
/// Owns the meta load (FR-004), the step index, the staged photo lists
/// (`pendingAdds` / `existingMedia` / `pendingDeletes` / `pendingOrder` per
/// data-model.md §4) and the create submit (D5: create → auto-upload,
/// non-all-or-nothing). Edit save (D6, strict all-or-nothing) is US3.
class ListingFormCubit extends Cubit<ListingFormState> {
  ListingFormCubit({
    required ListingRepository repository,
    bool isEditMode = false,
    String? listingId,
  })  : _repository = repository,
        _listingId = listingId,
        super(ListingFormState(isEditMode: isEditMode));

  final ListingRepository _repository;
  final String? _listingId;

  /// Maximum client-side photo size, 20MB (listing-form.md §Photo staging).
  static const int maxPhotoBytes = 20 * 1024 * 1024;

  /// Maximum photo count per listing (Figma `242:1713` — "Up to 10 photos").
  static const int maxPhotoCount = 10;

  /// Loads `GET /listings/meta` once (FR-004). Failure → retryable
  /// [ListingFormState.metaFailure]; Save stays disabled until meta is present.
  Future<void> fetchMeta() async {
    if (state.metaLoading || state.meta != null) return;
    emit(state.copyWith(metaLoading: true, metaFailure: null));
    try {
      final ListingMeta meta = await _repository.fetchMeta();
      emit(state.copyWith(metaLoading: false, meta: meta));
    } on Failure catch (failure) {
      emit(state.copyWith(metaLoading: false, metaFailure: failure));
    } catch (_) {
      emit(state.copyWith(
        metaLoading: false,
        metaFailure: const ListingMetaUnavailable(''),
      ));
    }
  }

  /// Mirrors a form-layer field into [ListingFormState.fields] so the review
  /// step renders from the same map the cubit submits (data-model.md §4).
  void updateField(String key, dynamic value) {
    emit(state.copyWith(fields: {...state.fields, key: value}));
  }

  void nextStep() {
    if (state.step >= 3) return;
    emit(state.copyWith(step: state.step + 1));
  }

  void previousStep() {
    if (state.step <= 0) return;
    emit(state.copyWith(step: state.step - 1));
  }

  /// Stages a picked photo (create: all photos live in `pendingAdds`; edit:
  /// they are staged adds in `pendingOrder` too, data-model.md §3.3). PNG/JPG
  /// only, ≤20MB, ≤[maxPhotoCount] photos (listing-form.md §Photo staging);
  /// a violation surfaces inline as [InvalidMediaFile] / [PhotoLimitReached]
  /// and the file is never sent.
  Future<void> addPhoto(XFile file) async {
    if (state.pendingOrder.length >= maxPhotoCount) {
      emit(state.copyWith(submitFailure: const PhotoLimitReached('')));
      return;
    }
    final String lowerName = file.name.toLowerCase();
    final bool isAllowedType = lowerName.endsWith('.png') ||
        lowerName.endsWith('.jpg') ||
        lowerName.endsWith('.jpeg');
    if (!isAllowedType) {
      emit(state.copyWith(submitFailure: const InvalidMediaFile('')));
      return;
    }
    try {
      final int length = await file.length();
      if (length > maxPhotoBytes) {
        emit(state.copyWith(submitFailure: const InvalidMediaFile('')));
        return;
      }
    } catch (_) {
      emit(state.copyWith(submitFailure: const InvalidMediaFile('')));
      return;
    }
    final int clientId = _nextClientId++;
    emit(state.copyWith(
      pendingAdds: [...state.pendingAdds, PendingMedia(file: file, clientId: clientId)],
      pendingOrder: [...state.pendingOrder, StagedMediaEntry.add(clientId)],
      submitFailure: null,
    ));
  }

  /// Stages multiple picked photos at once (gallery multi-select). Each file
  /// is validated individually (PNG/JPG, ≤20MB, ≤[maxPhotoCount] photos); all
  /// valid files up to the remaining count are staged and the first violation
  /// surfaces inline as [InvalidMediaFile] / [PhotoLimitReached] — rejected
  /// files are never staged (FR-007).
  Future<void> addPhotos(List<XFile> files) async {
    if (files.isEmpty) return;
    final List<XFile> accepted = <XFile>[];
    Failure? firstFailure;
    for (final XFile file in files) {
      if (state.pendingOrder.length + accepted.length >= maxPhotoCount) {
        firstFailure ??= const PhotoLimitReached('');
        break;
      }
      final String lowerName = file.name.toLowerCase();
      final bool isAllowedType = lowerName.endsWith('.png') ||
          lowerName.endsWith('.jpg') ||
          lowerName.endsWith('.jpeg');
      if (!isAllowedType) {
        firstFailure ??= const InvalidMediaFile('');
        continue;
      }
      int length;
      try {
        length = await file.length();
      } catch (_) {
        firstFailure ??= const InvalidMediaFile('');
        continue;
      }
      if (length > maxPhotoBytes) {
        firstFailure ??= const InvalidMediaFile('');
        continue;
      }
      accepted.add(file);
    }
    if (accepted.isEmpty) {
      emit(state.copyWith(
        submitFailure: firstFailure ?? const InvalidMediaFile(''),
      ));
      return;
    }
    final List<PendingMedia> adds = [...state.pendingAdds];
    final List<StagedMediaEntry> order = [...state.pendingOrder];
    for (final XFile file in accepted) {
      final int clientId = _nextClientId++;
      adds.add(PendingMedia(file: file, clientId: clientId));
      order.add(StagedMediaEntry.add(clientId));
    }
    emit(state.copyWith(
      pendingAdds: adds,
      pendingOrder: order,
      submitFailure: firstFailure,
    ));
  }

  void removePhoto(int clientId) {
    emit(state.copyWith(
      pendingAdds: state.pendingAdds
          .where((PendingMedia media) => media.clientId != clientId)
          .toList(),
      pendingOrder: state.pendingOrder
          .where((StagedMediaEntry entry) =>
              !(entry.isAdd && entry.clientId == clientId))
          .toList(),
    ));
  }

  /// Marks an existing server photo for deletion (edit mode, staged — nothing
  /// hits the server until Save, D6). Keeps it out of `pendingOrder` so the
  /// grid hides it while the id stays in `pendingDeletes`.
  void removeExistingMedia(String mediaId) {
    emit(state.copyWith(
      pendingDeletes: {...state.pendingDeletes, mediaId},
      pendingOrder: state.pendingOrder
          .where((StagedMediaEntry entry) => entry.mediaId != mediaId)
          .toList(),
    ));
  }

  /// Applies a full reorder of the staged photo grid (drag/drop). [order] is
  /// the reordered `pendingOrder` returned by the reorderable grid; existing
  /// media and adds keep their place in the final order.
  void setPendingOrder(List<StagedMediaEntry> order) {
    emit(state.copyWith(pendingOrder: order));
  }

  /// Resets the inline photo validation message after the user acts
  /// (invalid file, count limit reached).
  void clearPhotoError() {
    final Failure? failure = state.submitFailure;
    if (failure is InvalidMediaFile || failure is PhotoLimitReached) {
      emit(state.copyWith(submitFailure: null));
    }
  }

  /// Edit-mode preload (D6): fetches the FRESH `GET /listings/:id` snapshot
  /// and mirrors it into `fields` + `existingMedia` + `pendingOrder` so the
  /// form renders prefilled. `availableFrom` is parsed back to its date part
  /// (data-model.md §1.3). Failure → retryable [ListingFormState.preloadFailure].
  Future<void> loadForEdit(String id) async {
    emit(state.copyWith(preloading: true, preloadFailure: null));
    try {
      final ShopListing listing = await _repository.getListing(id);
      final List<ListingMedia> existing = [...listing.media]
        ..sort((ListingMedia a, ListingMedia b) =>
            a.sortOrder.compareTo(b.sortOrder));
      emit(state.copyWith(
        preloading: false,
        fields: _fieldsFromListing(listing),
        existingMedia: existing,
        pendingOrder: [
          for (final ListingMedia media in existing)
            StagedMediaEntry.existing(media.id),
        ],
      ));
    } on Failure catch (failure) {
      emit(state.copyWith(preloading: false, preloadFailure: failure));
    } catch (_) {
      emit(
        state.copyWith(
          preloading: false,
          preloadFailure: const ServerFailure(''),
        ),
      );
    }
  }

  /// Edit submit (D6, strict all-or-nothing): delegates the whole protocol to
  /// `repo.saveEdit` — fields (NO status) + staged media adds/deletes/reorder
  /// commit together; any failure → `submitFailure` ("nothing was saved") and
  /// a full re-Save is required. On success [ListingFormState.updatedId] is
  /// set so the screen navigates to the saved listing's detail.
  Future<void> submitEdit() async {
    if (state.isSubmitting) return;
    final UpdateListingRequest? request = _buildUpdateRequest();
    if (request == null) {
      emit(state.copyWith(submitFailure: const GenericFailure('')));
      return;
    }
    final String id = _listingId ?? '';
    if (id.isEmpty) {
      emit(state.copyWith(submitFailure: const ListingNotFound('')));
      return;
    }

    emit(state.copyWith(
      isSubmitting: true,
      submitFailure: null,
      isUploading: state.pendingAdds.isNotEmpty,
      uploadProgress: 0,
    ));
    try {
      await _repository.saveEdit(
        id: id,
        request: request,
        pendingAdds: state.pendingAdds,
        pendingDeletes: state.pendingDeletes,
        pendingOrder: state.pendingOrder,
        onProgress: (int sent, int total) {
          if (total <= 0) return;
          emit(state.copyWith(uploadProgress: sent / total));
        },
      );
      emit(state.copyWith(
        isSubmitting: false,
        isUploading: false,
        uploadProgress: 1,
        updatedId: id,
      ));
    } on Failure catch (failure) {
      emit(state.copyWith(
        isSubmitting: false,
        isUploading: false,
        submitFailure: failure,
      ));
    } catch (_) {
      emit(state.copyWith(
        isSubmitting: false,
        isUploading: false,
        submitFailure: const ServerFailure(''),
      ));
    }
  }

  /// Create submit (D5, non-all-or-nothing): `POST /listings` then auto-upload
  /// the staged photos in one batched multipart call (media-upload.md). An
  /// upload failure keeps the listing PENDING and surfaces a typed failure
  /// with the "retry via edit" path — never a rollback (D5).
  Future<void> submitCreate() async {
    if (state.isSubmitting) return;
    final CreateListingRequest? request = _buildRequest();
    if (request == null) {
      emit(state.copyWith(submitFailure: const GenericFailure('')));
      return;
    }
    final List<XFile> photos =
        state.pendingAdds.map((PendingMedia media) => media.file).toList();

    emit(state.copyWith(
      isSubmitting: true,
      submitFailure: null,
      isUploading: photos.isNotEmpty,
      uploadProgress: 0,
    ));
    try {
      final String id = await _repository.createListing(
        request,
        photos,
        onProgress: (int sent, int total) {
          if (total <= 0) return;
          emit(state.copyWith(uploadProgress: sent / total));
        },
      );
      emit(state.copyWith(
        isSubmitting: false,
        isUploading: false,
        uploadProgress: 1,
        createdId: id,
      ));
    } on Failure catch (failure) {
      emit(state.copyWith(
        isSubmitting: false,
        isUploading: false,
        submitFailure: failure,
      ));
    } catch (_) {
      emit(state.copyWith(
        isSubmitting: false,
        isUploading: false,
        submitFailure: const ServerFailure(''),
      ));
    }
  }

  /// Builds the create payload from [ListingFormState.fields]. Returns null when
  /// a required field is missing — the form layer validates before Submit is
  /// reachable; this is the cubit's safety net.
  CreateListingRequest? _buildRequest() {
    final Map<String, dynamic> f = state.fields;
    final double? areaSqm = _asDouble(f[ListingFormFieldKeys.areaSqm]);
    final int? floorNumber = _asInt(f[ListingFormFieldKeys.floorNumber]);
    final double? annualRent = _asDouble(f[ListingFormFieldKeys.annualRent]);
    final int? numberOfFloors =
        _asInt(f[ListingFormFieldKeys.numberOfFloors]);
    final int? securityDepositMonths =
        _asInt(f[ListingFormFieldKeys.securityDepositMonths]);
    final String? title = _asTrimmed(f[ListingFormFieldKeys.title]);
    final String? category = _asTrimmed(f[ListingFormFieldKeys.category]);
    final String? city = _asTrimmed(f[ListingFormFieldKeys.city]);
    final String? district = _asTrimmed(f[ListingFormFieldKeys.district]);
    final String? address = _asTrimmed(f[ListingFormFieldKeys.address]);
    final String? description =
        _asTrimmed(f[ListingFormFieldKeys.description]);
    final String? availableFrom =
        _asTrimmed(f[ListingFormFieldKeys.availableFrom]);
    final String? minimumLeaseTerm =
        _asTrimmed(f[ListingFormFieldKeys.minimumLeaseTerm]);
    if (title == null ||
        category == null ||
        city == null ||
        district == null ||
        areaSqm == null ||
        floorNumber == null ||
        annualRent == null ||
        numberOfFloors == null ||
        securityDepositMonths == null ||
        address == null ||
        description == null ||
        availableFrom == null ||
        minimumLeaseTerm == null) {
      return null;
    }
    return CreateListingRequest(
      title: title,
      category: category,
      areaSqm: areaSqm,
      city: city,
      district: district,
      address: address,
      description: description,
      amenities: List<String>.from(f[ListingFormFieldKeys.amenities] ?? const []),
      numberOfFloors: numberOfFloors,
      floorNumber: floorNumber,
      availableFrom: availableFrom,
      minimumLeaseTerm: minimumLeaseTerm,
      annualRent: annualRent,
      currency: _asTrimmed(f[ListingFormFieldKeys.currency]) ?? 'EGP',
      securityDepositMonths: securityDepositMonths,
    );
  }

  /// Builds the edit payload from [ListingFormState.fields]. Same field set as
  /// create — `status` is NEVER included (FR-010) and `currency` is not
  /// re-submitted on update (data-model.md §1.3). Returns null when a required
  /// field is missing.
  UpdateListingRequest? _buildUpdateRequest() {
    final Map<String, dynamic> f = state.fields;
    final double? areaSqm = _asDouble(f[ListingFormFieldKeys.areaSqm]);
    final int? floorNumber = _asInt(f[ListingFormFieldKeys.floorNumber]);
    final double? annualRent = _asDouble(f[ListingFormFieldKeys.annualRent]);
    final int? numberOfFloors =
        _asInt(f[ListingFormFieldKeys.numberOfFloors]);
    final int? securityDepositMonths =
        _asInt(f[ListingFormFieldKeys.securityDepositMonths]);
    final String? title = _asTrimmed(f[ListingFormFieldKeys.title]);
    final String? category = _asTrimmed(f[ListingFormFieldKeys.category]);
    final String? city = _asTrimmed(f[ListingFormFieldKeys.city]);
    final String? district = _asTrimmed(f[ListingFormFieldKeys.district]);
    final String? address = _asTrimmed(f[ListingFormFieldKeys.address]);
    final String? description =
        _asTrimmed(f[ListingFormFieldKeys.description]);
    final String? availableFrom =
        _asTrimmed(f[ListingFormFieldKeys.availableFrom]);
    final String? minimumLeaseTerm =
        _asTrimmed(f[ListingFormFieldKeys.minimumLeaseTerm]);
    if (title == null ||
        category == null ||
        city == null ||
        district == null ||
        areaSqm == null ||
        floorNumber == null ||
        annualRent == null ||
        numberOfFloors == null ||
        securityDepositMonths == null ||
        address == null ||
        description == null ||
        availableFrom == null ||
        minimumLeaseTerm == null) {
      return null;
    }
    return UpdateListingRequest(
      title: title,
      category: category,
      areaSqm: areaSqm,
      city: city,
      district: district,
      address: address,
      description: description,
      amenities: List<String>.from(f[ListingFormFieldKeys.amenities] ?? const []),
      numberOfFloors: numberOfFloors,
      floorNumber: floorNumber,
      availableFrom: availableFrom,
      minimumLeaseTerm: minimumLeaseTerm,
      annualRent: annualRent,
      securityDepositMonths: securityDepositMonths,
    );
  }

  /// Mirrors a [ShopListing] into the form's `fields` map for edit prefill
  /// (D6). `availableFrom` keeps only the date part (YYYY-MM-DD); numbers are
  /// kept as plain strings the same way the form widgets set them.
  Map<String, dynamic> _fieldsFromListing(ShopListing listing) {
    final String availableFrom =
        listing.availableFrom == null ? '' : _datePart(listing.availableFrom!);
    return <String, dynamic>{
      ListingFormFieldKeys.title: listing.title,
      ListingFormFieldKeys.category: listing.category,
      ListingFormFieldKeys.areaSqm: _formatNumber(listing.areaSqm),
      ListingFormFieldKeys.city: listing.city,
      ListingFormFieldKeys.district: listing.district,
      ListingFormFieldKeys.address: listing.address ?? '',
      ListingFormFieldKeys.description: listing.description ?? '',
      ListingFormFieldKeys.amenities: listing.amenities,
      ListingFormFieldKeys.numberOfFloors:
          listing.numberOfFloors?.toString() ?? '',
      ListingFormFieldKeys.floorNumber: listing.floorNumber.toString(),
      ListingFormFieldKeys.availableFrom: availableFrom,
      ListingFormFieldKeys.minimumLeaseTerm: listing.minimumLeaseTerm ?? '',
      ListingFormFieldKeys.annualRent: _formatNumber(listing.annualRent),
      ListingFormFieldKeys.currency: listing.currency,
      ListingFormFieldKeys.securityDepositMonths:
          listing.securityDepositMonths?.toString() ?? '',
    };
  }

  static String _formatNumber(double value) =>
      value == value.roundToDouble() ? value.toStringAsFixed(0) : value.toString();

  static String _datePart(DateTime date) {
    final String year = date.year.toString().padLeft(4, '0');
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  int _nextClientId = 0;

  static double? _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.trim());
    return null;
  }

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value.trim());
    return null;
  }

  static String? _asTrimmed(dynamic value) {
    if (value is String && value.trim().isNotEmpty) return value.trim();
    return null;
  }
}
