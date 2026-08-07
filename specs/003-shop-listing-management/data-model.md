# Data Model — Phase 2 (Shop Listing Management)

Branch `003-shop-listing-management` · Date 2026-08-07 · Spec `spec.md` · Plan `plan.md` · Research `research.md`

Covers the request/response models for the Phase 2 listings API (per
`docs/FRONTEND_PHASE2_LISTINGS_API_GUIDE.md`) and the listing status/form/media state machines. All
models are freezed Dart under `lib/features/listing/data/models/` and flow unchanged into
`repository/` and `presentation/` (constitution §2 — same models everywhere, no DTO mapping).

> Transport rules inherited from Phase 0: the envelope `{ message, status, data }` is unwrapped once
> in `core/network/`; every model below is the **unwrapped `data` payload**. The single exception,
> `GET /listings/meta` (`{ success, data }`), is also unwrapped by the existing interceptor with no
> pipeline change (D2). Non-2xx → typed `Failure` (Phase 0 set + new listing failures below), never
> raw exceptions.

## 1. Listing models — `lib/features/listing/data/models/`

### 1.1 `ListingStatus` enum

```dart
enum ListingStatus {
  pending,
  available,
  rented,
  expired;

  static ListingStatus fromApi(String value) => // maps "PENDING"|"AVAILABLE"|"RENTED"|"EXPIRED"
  String get apiValue => // "PENDING" etc.
}
```

Source of truth: the backend enum, surfaced by `GET /listings/meta` (`statuses`) and used verbatim in
`PATCH /listings/:id/status`. The enum is the model's single status representation; unknown values
fall back to `pending` with a data-integrity log (never crash on forward-compatible statuses).
Visibility rules (AVAILABLE offered, RENTED tagged, PENDING/EXPIRED hidden) are **backend-driven** and
not encoded here (D4).

### 1.2 `ListingMedia` (response item, `POST/GET/DELETE media`, reorder responses)

```dart
@freezed
abstract class ListingMedia with _$ListingMedia {
  const factory ListingMedia({
    required String id,        // maps JSON "_id" — this is the mediaId for reorder/delete
    required String mediaType, // "image"
    required String url,       // absolute Cloudinary CDN URL — render as-is (D3, §8.6)
    required int sortOrder,
  }) = _ListingMedia;
  factory ListingMedia.fromJson(Map<String, dynamic> json) => _$ListingMediaFromJson(json);
}
```

JSON key `_id` → Dart `id` via a `@JsonKey(name: '_id')`. The returned `_id` is the `mediaId` passed
to `PUT /listings/:id/media/reorder` and `DELETE /listings/:id/media/:mediaId`.

### 1.3 `ShopListing` (full response, `GET /listings/:id`)

```dart
@freezed
abstract class ShopListing with _$ShopListing {
  const factory ShopListing({
    required String id,
    String? landlordId,
    required String title,
    required String category,
    required double areaSqm,
    required String city,
    required String district,
    String? address,
    String? description,
    required List<String> amenities,        // ["PARKING", "SECURITY", "AC"]
    int? numberOfFloors,
    required int floorNumber,               // 0 = ground floor
    DateTime? availableFrom,                // ISO-8601 datetime from API; date part used in the form
    String? minimumLeaseTerm,               // free text (assumption; §5.1)
    required double annualRent,
    required double annualRentWithVat,      // backend-computed (annualRent × 1.15) — display only, never submitted
    required String currency,               // "EGP", fixed read-only this phase; kept for forward compat
    int? securityDepositMonths,
    required ListingStatus status,
    required List<ListingMedia> media,      // ordered by sortOrder
    String? thumbnailUrl,                   // absolute Cloudinary URL
    bool? isSaved,                          // meaningful only with a valid token (Phase 3 uses this; present on detail)
  }) = _ShopListing;
  factory ShopListing.fromJson(Map<String, dynamic> json) => _$ShopListingFromJson(json);
}
```

**Rules**:
- `annualRentWithVat` and `currency` are **never submitted** (FR-008, §8.4); the create/update request
  models do not carry them.
- `availableFrom` is submitted as `YYYY-MM-DD` (date only) but returned as ISO-8601 datetime; the form
  parses the date part back out when editing (API guide §5.3 note).
- `floorNumber: 0` means ground floor; keep the int, render `0` as ground floor in EN/AR.
- `isSaved` is read-only and only relevant when a token is sent (Phase 3's saved-listing UI); it is
  tolerated here but unused in Phase 2.

### 1.4 `ListingSummary` (list item, `GET /listings/my-listings`)

```dart
@freezed
abstract class ListingSummary with _$ListingSummary {
  const factory ListingSummary({
    required String id,
    required String title,
    required String category,
    required double areaSqm,
    required double annualRent,
    required String currency,
    required ListingStatus status,
    String? thumbnailUrl,
  }) = _ListingSummary;
  factory ListingSummary.fromJson(Map<String, dynamic> json) => _$ListingSummaryFromJson(json);
}
```

`data` here is a **bare array** with no pagination `meta` (API guide §5.4 note) — the My Listings
datasource returns `List<ListingSummary>` directly. List rendering is lazy (`ListView.builder`).

### 1.5 `ListingMeta` (response, `GET /listings/meta` — the `{ success, data }` exception)

```dart
@freezed
abstract class ListingMeta with _$ListingMeta {
  const factory ListingMeta({
    required List<String> categories,     // ["Retail","Showroom","Office","Warehouse","Kiosk","Restaurant","Other"]
    required List<String> amenities,      // ["PARKING","SECURITY","AC"]
    required List<String> statuses,       // ["PENDING","AVAILABLE","RENTED","EXPIRED"]
  }) = _ListingMeta;
  factory ListingMeta.fromJson(Map<String, dynamic> json) => _$ListingMetaFromJson(json);
}
```

Fetched once when the form opens (retryable — FR-004, D2). Does **not** include city/district options;
the app uses a local curated EN/AR list (assumption, flagged).

## 2. Request payloads (bodies sent to `/listings*`)

| Model | Endpoint | Fields | Notes |
|---|---|---|---|
| `CreateListingRequest` | `POST /listings` | `title`, `category`, `areaSqm`, `city`, `district`, `address`, `description`, `amenities`, `numberOfFloors`, `floorNumber`, `availableFrom` (`YYYY-MM-DD`), `minimumLeaseTerm`, `annualRent`, `currency` (`"EGP"`), `securityDepositMonths` | New listing starts PENDING server-side (FR-006). No `annualRentWithVat`, no `status`. |
| `UpdateListingRequest` | `PUT /listings/:id` | any subset of the create fields (same field set) | Status NEVER included — an edit never changes status (FR-010). |
| `StatusUpdateRequest` | `PATCH /listings/:id/status` | `status` (`ListingStatus.apiValue`) | Backend validates transitions (D4). |
| `MediaOrderRequest` | `PUT /listings/:id/media/reorder` | `media: [{ mediaId, sortOrder }]` | `mediaId` = `ListingMedia.id`; send full desired order. |

All are freezed with `toJson` only (requests are never parsed from the server). The media upload uses
dio `FormData` (repeated `photos` file fields), not a JSON body — see contract `media-upload.md`.

## 3. Media state machines

### 3.1 Create flow (D5) — create then auto-upload

- `POST /listings` succeeds → listing id known, status PENDING.
- Photos uploaded as `FormData` (`photos` × N) via `POST /listings/:id/media`; the response's `media`
  array (with real ids) becomes the listing's media.
- Failure at the upload step → listing **stays pending**, localized message with retry path via edit
  (intentionally NOT all-or-nothing, D5).
- Photos selected in the create flow are held as `XFile`s in the Cubit state (D3); no local persistence.

### 3.2 Edit flow (D6) — staged, strict all-or-nothing

The edit form stages photo operations without persisting:
- `pendingAdds: List<XFile>` — files picked but not yet uploaded.
- `pendingDeletes: Set<String>` — `ListingMedia.id`s to remove.
- `pendingOrder: List<...>` — the desired final media order (existing ids + pending adds in position).

On Save the repository re-fetches the fresh `ShopListing` (snapshot), then applies in order
`PUT /listings/:id` → media adds (`POST`) → media deletes (`DELETE`) → reorder (`PUT reorder` with the
final order). Any failure → "nothing was saved", full re-Save required; the next attempt re-fetches the
snapshot so retries converge (D6; US3 edge cases 404 → "listing no longer exists").

### 3.3 `PendingMedia` (form-level staging type, not a transport model)

```dart
class PendingMedia {
  final XFile file;   // picked but not yet uploaded
  final int clientId; // local identity for reorder while unpersisted
}
```

Lives in the form Cubit state only; never serialized, never sent to the backend directly.

## 4. Listing-form domain state (Cubit-level, not transport)

Owned by `ListingFormCubit` (shared by create and edit):

```dart
class ListingFormState {
  // step: 0 details, 1 photos, 2 price/lease, 3 review (create only shows all 4; edit too)
  final int step;
  final ListingMeta? meta;               // null until loaded; load failure → retryable state (FR-004)
  final Map<String, dynamic> fields;     // typed by the form layer, mirrored here for review step
  final List<ListingMedia> existingMedia; // edit mode only
  final List<PendingMedia> pendingAdds;  // create: all photos; edit: staged adds
  final Set<String> pendingDeletes;      // edit only
  final List<...> pendingOrder;          // edit only (final order)
  final bool isSubmitting;
  final Failure? failure;
  final bool isEditMode;
}
```

Semantics (contract `listing-form.md`): the review step renders `fields` + (edit) the staged photo
outcome; `isSubmitting` guards the single Submit (FR-014 duplicate prevention); validation lives in the
form layer, not the model.

## 5. My Listings state machine

- `MyListingsCubit` loads `GET /listings/my-listings` → `List<ListingSummary>`.
- Failure → typed `Failure` with a retry action (US2 scenario 4); empty → empty state inviting the
  first listing (edge case).
- After create/edit/status/delete success the list reloads (or the local item updates) so the view
  stays current (FR-009, SC-003).

## 6. Anti-patterns to avoid (extended)

- No envelope parsing, no DTO→entity mapping, no raw `DioException` (Phase 0 rules).
- No `setState` business logic; Cubits own all state transitions.
- No local photo persistence; `XFile`s live in the form state for the flow's duration (D3).
- `annualRentWithVat` / `currency` never submitted; never stored locally as editable (FR-008).
- Status transitions never validated client-side (D4); the backend is the authority.
- `activeRole` never gates listing permissions; `roles[]` (landlord) is the gate (FR-013).
- Edit save never partial: no "saved fields but not photos" intermediate state surfaces (D6).
