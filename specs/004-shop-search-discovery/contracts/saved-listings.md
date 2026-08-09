# Contract: Saved Listings (Phase 3)

Feature `004-shop-search-discovery` · Spec `spec.md` · Plan `plan.md` · Model `data-model.md` · Decisions D3, D8

## Purpose

Defines the self-contained `saved/` feature area (spec Q1): the finalized save/unsave/
my-saved contract, the `SavedListing` model, and how `isSaved` stays consistent across
every surface. Source of truth: `docs/FRONTEND_PHASE2_LISTINGS_API_GUIDE.md` §7.

## Endpoints — `SavedListingsDataSource` (`features/saved/data/`)

All Bearer-required. Envelope unwrapped once by the dio layer.

| Method & Path | Request | Success `data` | Error → `Failure` |
|---|---|---|---|
| `POST /listings/:id/save` | — | `{}` (message only) | `SaveListingFailed`, per pipeline |
| `DELETE /listings/:id/save` | — | `{}` (message only) | `UnsaveListingFailed`, per pipeline |
| `GET /users/me/saved-listings` | — | bare array of `SavedListing` (no pagination meta) | `SavedListingsLoadFailed`, per pipeline |

Idempotency: both save and unsave succeed on repeat calls (§7.1/7.2) — a re-tap after a
transient failure converges; the app's in-flight flag prevents concurrent duplicates anyway.

## `SavedListing` model

Slim §7.3 payload — `id, title, location` (combined `"New Cairo, Cairo"`),
`annualRent, annualRentWithVat, currency, areaSqm, thumbnailUrl, isSaved`. It is NOT a
reuse of `BrowseListing`/`ShopListing` (D3). The saved screen reads it independently of
search (spec Q1).

## Repository interface — `SavedListingsRepository`

```text
Future<void> save(String listingId)          // POST /listings/:id/save
Future<void> unsave(String listingId)        // DELETE /listings/:id/save
Future<List<SavedListing>> getSavedListings() // GET /users/me/saved-listings
```

One impl over `SavedListingsDataSource`, registered via get_it against the interface.
**This one repository is injected into every surface that shows a heart or saved state**
(D8): `SearchCubit`, tenant `ListingDetailCubit`, home card heart, `SavedListingsCubit`.

## Consistency protocol (D8)

1. `isSaved` is authoritative from the server (browse/detail responses carry it; the app
   always sends the token).
2. Tapping a heart mutates **only through `SavedListingsRepository`**, never a local copy.
3. The initiating surface optimistically flips its item's `isSaved`, then calls save/unsave.
4. Failure → revert the flip + localized message + retry (FR-014). Success → keep the flip.
5. The saved screen (`SavedListingsCubit`) refetches `getSavedListings()` on open/refresh so
   unsaves from anywhere disappear (FR-013) and saves from anywhere appear (SC-006).

Home hearts: Phase 2's visual-only hearts (gap-log) become interactive through this same
repository — the spec's Q1 relocation of any home-area save endpoints is forward-only
(verified: none exist today).

## Guarantees

- FR-012/FR-013: saved state consistent across results list, detail, and saved list.
- Edge cases: double-tap → one action (in-flight flag); already-saved tap → idempotent
  no-op; saved list load failure → friendly localized error + retry (US5 scenario 4).
- No local cache — every surface reads server state or the local optimistic flip.
