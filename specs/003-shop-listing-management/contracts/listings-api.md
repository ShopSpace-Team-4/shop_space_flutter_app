# Contract: Listings API

Branch `003-shop-listing-management` · Spec `spec.md` · Plan `plan.md` · Model `data-model.md`

## Purpose

Defines the exact `features/listing/` → backend surface for Phase 2 (landlord-side management).
Pairs each endpoint with its payload, its unwrapped `data` shape, and the typed `Failure` that must
reach the UI. Source of truth: `docs/FRONTEND_PHASE2_LISTINGS_API_GUIDE.md`. Marketplace
browse/search/saved endpoints (Phase 3) are listed only for scope boundaries.

## Rules (inherited, non-negotiable)

1. Envelope is unwrapped exactly once in the dio layer. These contracts describe the `data` field.
2. Bearer token attached via interceptor; 401 → one silent refresh, retry once, then force logout
   (`SessionController.sessionExpired`).
3. Every non-2xx maps to a typed `Failure` (`core/errors/failures.dart`). New listing-specific
   variants extend the sealed hierarchy: `ListingMetaUnavailable`, `ListingCreateFailed`,
   `ListingUpdateFailed`, `ListingStatusFailed`, `ListingDeleteFailed`, `ListingNotFound`,
   `MediaUploadFailed`, `MediaReorderFailed`, `MediaDeleteFailed`, `ListingNotOwned`,
   `InvalidMediaFile` — each with l10n keys + `ErrorMapper` entries.
4. Authorization for create/update/delete/media keys off the account's `roles[]` (`landlord`),
   never `activeRole` (FR-013, §8.2). The datasource does not enforce this — the router/Cubit gate
   on `roles[]` and the backend rejects non-landlords.

## Envelope exception — `GET /listings/meta`

`GET /listings/meta` returns `{ "success": true, "data": {...} }` instead of
`{ message, status, data }`. The existing Phase 0 `EnvelopeInterceptor` unwraps it transparently
(keys on presence of `data`; `ApiEnvelope.fromJson` defaults missing fields). **No pipeline change**
(D2). `ListingDataSource.fetchMeta()` returns `ListingMeta` like any other unwrapped model.

## Endpoints — `ListingDataSource` (`features/listing/data/`)

| Method & Path | Auth | Request | Success `data` | Error → `Failure` |
|---|---|---|---|---|
| `GET /listings/meta` | Public | — | `ListingMeta{categories, amenities, statuses}` | `ListingMetaUnavailable` |
| `POST /listings` | Bearer + landlord | `CreateListingRequest` | minimal `data` (`id`, status PENDING, `annualRent`, `annualRentWithVat`, `currency`, `media`, `isSaved`) — NOT a full `ShopListing`; repo re-fetches `GET /listings/:id` for the detail model | `ListingCreateFailed`, `ValidationFailure`, per pipeline |
| `GET /listings/my-listings` | Bearer + landlord | — | `List<ListingSummary>` (bare array, no pagination) | `ListingMetaUnavailable` N/A; `ListingNotOwned` N/A; `NetworkFailure`/`ServerFailure` etc. via pipeline |
| `GET /listings/:id` | Optional | — | `ShopListing` (full detail, media ordered) | `ListingNotFound` (404), per pipeline |
| `PUT /listings/:id` | Bearer + owner | `UpdateListingRequest` (fields only, NO status) | `ShopListing` (updated fields; `annualRentWithVat` recomputed) | `ListingNotFound` (404), `ListingNotOwned` (403), `ListingUpdateFailed`, per pipeline |
| `PATCH /listings/:id/status` | Bearer + owner | `StatusUpdateRequest{status}` | `{ id, status }` | `ListingNotFound`, `ListingNotOwned`, `ListingStatusFailed` (incl. backend-rejected transition), per pipeline |
| `DELETE /listings/:id` | Bearer + owner | — | `{}` (listing + its photos removed) | `ListingNotFound`, `ListingNotOwned`, `ListingDeleteFailed`, per pipeline |
| `POST /listings/:id/media` | Bearer + owner | multipart `FormData` (repeated `photos`) | `{ id, media: [ListingMedia] }` | `InvalidMediaFile` (type/size — normally caught client-side, D3), `MediaUploadFailed`, `ListingNotFound`, `ListingNotOwned`, per pipeline |
| `PUT /listings/:id/media/reorder` | Bearer + owner | `MediaOrderRequest{media:[{mediaId, sortOrder}]}` | `{ id, media: [ListingMedia] }` | `MediaReorderFailed`, `ListingNotFound`, `ListingNotOwned`, per pipeline |
| `DELETE /listings/:id/media/:mediaId` | Bearer + owner | — | `{ id, media: [ListingMedia] }` | `MediaDeleteFailed`, `ListingNotFound`, `ListingNotOwned`, per pipeline |

## Out of scope (Phase 3 — do NOT build)

`GET /listings` (browse/search, paginated `{items, meta}`), `GET /listings/:id` marketplace detail
is reused only to prefill the edit form (assumption), `POST /listings/:id/save`,
`DELETE /listings/:id/save`, `GET /users/me/saved-listings`. The `isSaved` field is tolerated on the
models but unused this phase.

## Field semantics (shared)

- `availableFrom`: submit as `YYYY-MM-DD` (date only); parse the date part back out of the returned
  ISO-8601 datetime when editing (§5.3).
- `floorNumber: 0` = ground floor; keep int.
- `minimumLeaseTerm`: free text (assumption, §5.1).
- `annualRentWithVat`: backend-owned, **never submitted**, display only (§8.4).
- `currency`: fixed `"EGP"` this phase (spec Session 2026-08-07); it IS included in the
  `POST /listings` body as `"EGP"` (API guide §5.1) but is never user-editable and is not
  re-submitted on update.
- City/district: required dropdowns (FR-005). `meta` does not publish options → local curated EN/AR
  list; gap flagged for backend.
- Media URLs (`url`, `thumbnailUrl`): absolute Cloudinary CDN URLs — render as-is, never prepend a
  base address (§8.6).

## State-transition guarantees

- **Create**: `POST /listings` always yields status PENDING (FR-006); publish is a later explicit
  `PATCH /listings/:id/status` with `AVAILABLE`.
- **Edit**: `PUT /listings/:id` never changes status (FR-010); status is only changed via the
  status endpoint.
- **Status**: backend is authoritative on transitions (it may reject an invalid one — surfaced as a
  localized error, D4); the app never re-implements the transition graph.
- **Delete**: removes listing and its photos; confirmed by the user first (FR-012).
