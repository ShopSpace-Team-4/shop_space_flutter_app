# Data Model — Phase 3 (Shop Search & Discovery, Tenant Side)

Feature `004-shop-search-discovery` · Branch `004-shop-search-discovery` · Spec `spec.md` · Plan `plan.md`

Source of truth for wire shapes: `docs/FRONTEND_PHASE2_LISTINGS_API_GUIDE.md` (finalized
listings/saved contract; the tenant contact flow reads the listing's own `whatsappLink` —
no additional endpoints). Models marked *(reuse)* already exist in
`lib/features/listing/data/models/` and flow unchanged (constitution §2 — no DTO mapping).

---

## 1. Entities

### 1.1 `SearchFilters` — NEW, `features/search/data/models/search_filters.dart` (freezed)

The user-facing filter state on the Search screen (spec key entity "Search filters").
Converts 1:1 into `BrowseQuery` via `SearchFilterBuilder` (contract `search-browse.md`).

| Field | Type | Notes / validation |
|---|---|---|
| `city` | `String?` | Single-select from `LocalityOptions.cities`; sent as `city=` (D12). |
| `district` | `String?` | Single-select from `LocalityOptions.districtsFor(city)`; sent as `district=` (D12). |
| `category` | `String?` | Single-select from meta categories; sent as `category=`. |
| `priceMin` | `double?` | ≥ 0; sent as `priceMin=`. |
| `priceMax` | `double?` | > `priceMin` when both set (validated in the filter sheet); sent as `priceMax=`. |
| `areaMin` | `double?` | ≥ 0; sent as `areaMin=`. |
| `areaMax` | `double?` | > `areaMin` when both set; sent as `areaMax=`. |
| `amenities` | `List<String>` | Multi-select of meta amenity enum values; comma-joined `amenities=PARKING,AC`. |
| `sort` | `String?` | Small selectable set (newest / price asc / price desc); `sort=field:direction` (D11). |
| `page` | `int` | Starts at 1; owned by the cubit, not the sheet. |
| `limit` | `int` | Fixed at 10 (matches the browse default). |

Validation: a range where `min > max` is a sheet-level validation error (localized);
the empty `SearchFilters()` default means "all available shops, newest first".

### 1.2 `SearchFilterOptions` — NEW, `features/search/data/models/search_filter_options.dart` (freezed)

Bundles the option sources for the filter UI (contract `search-browse.md`):
`categories: List<String>`, `amenities: List<String>` (both from `GET /listings/meta`
via `ListingRepository.fetchMeta`), `cities` / `districtsFor(city)` (from the local
curated `LocalityOptions` — flagged gap). Loaded once when the Search screen first
opens; a fetch failure is a retryable error state, never a hardcoded fallback list.

### 1.3 `BrowseListing` — REUSE, `features/listing/data/models/browse_listing.dart`

One result item from `GET /listings` (§5.2): `id, title, category, areaSqm, city,
district, annualRent, annualRentWithVat, currency, thumbnailUrl?, isSaved?`. Rendered
by the search result card (photo, title, location, VAT-inclusive price, heart). `isSaved`
is authoritative when the signed-in token is sent (always in this app, spec Assumptions).

### 1.4 `BrowsePage` / `BrowseMeta` — REUSE, `features/listing/data/models/browse_page.dart`

Paginated browse response: `BrowsePage { items: List<BrowseListing>, meta: BrowseMeta }`;
`BrowseMeta { page, limit, total, pages }`. Drives `hasMore = meta.page < meta.pages`
and the end-of-list state (FR-005, D7).

### 1.5 `ShopListing` — REUSE, `features/listing/data/models/shop_listing.dart`

Full listing detail from `GET /listings/:id` (§5.3): `id, landlordId?, title, category,
areaSqm, city, district, address?, description?, amenities, numberOfFloors?, floorNumber,
availableFrom?, minimumLeaseTerm?, annualRent, annualRentWithVat, currency,
securityDepositMonths?, status, media: List<ListingMedia>, thumbnailUrl?, isSaved?,
whatsappLink?, createdAt?, updatedAt?`. `whatsappLink` is the landlord's full
`https://wa.me/<phone>` deep link returned by the backend — the contact flow launches it
directly with a localized `?text=` appended when the link has none (the old
`GET /users/:id` profile lookup was removed from scope, 2026-08-09).
`createdAt`/`updatedAt` are optional ISO-8601 datetimes kept for parity; not rendered.
`status` AVAILABLE is asserted; a listing that was deleted/unavailable surfaces
`ListingNotFound` → friendly localized message + return to results (US2 scenario 4).

### 1.6 `ListingMedia` — REUSE, `features/listing/data/models/listing_media.dart`

`{ id, mediaType, url, sortOrder }` (API guide §6). The tenant detail photo gallery
renders `media` sorted by `sortOrder` (FR-008); the card thumbnail uses `thumbnailUrl`.

### 1.7 `SavedListing` — NEW, `features/saved/data/models/saved_listing.dart` (freezed)

The exact `GET /users/me/saved-listings` item (§7.3, D3) — **not** `BrowseListing`:

| Field | Type | Notes |
|---|---|---|
| `id` | `String` | The listing id (used for unsave + navigation to detail). |
| `title` | `String` | |
| `location` | `String` | Combined `"New Cairo, Cairo"` — rendered as-is (FR-013 "key details"). |
| `annualRent` | `double` | Display-only baseline (not shown to tenant per FR-003). |
| `annualRentWithVat` | `double` | The tenant-facing price (FR-003). |
| `currency` | `String` | `"EGP"` display. |
| `areaSqm` | `double` | |
| `thumbnailUrl` | `String?` | Cloudinary CDN URL, rendered as-is. |
| `isSaved` | `bool` | Always `true` here; present for shape parity. |

Validation: none beyond the payload. The saved screen reads this model independently of
search (spec Q1).

---

## 2. Relationships

```text
BrowsePage 1─* BrowseListing            (search results page)
ShopListing 1─* ListingMedia            (tenant detail gallery, ordered by sortOrder)
SavedListing   (projection of a listing for the saved screen; no FK — server-side)
```

No local persistence or on-device storage — every entity is a wire-projected value
object; saved-state consistency is a server-authoritative read + optimistic mutation
through the one `SavedListingsRepository` (D8).

---

## 3. State machines

### 3.1 `SearchState` (SearchCubit)

```
idle/initial
  │ load() / first filter apply
  ▼
loadingSkeleton (FR-006 placeholders)
  │ success
  ▼
loaded(items: page 1, hasMore) ──filter change──▶ debouncing → loadingSkeleton (page 1 reset)
  │ scroll near end & hasMore                     │
  ▼                                               ▼
loadingMore ──success──▶ loaded(append page N)   (generation guard drops stale responses, D7)
  │                                                  
  ▼ no matches                                     
empty (filters don't match → reset-filters CTA)    
  │ any failure                                    
  ▼                                               
error(failure, retry → load())                   
```

### 3.2 WhatsApp contact (self-contained button on `ShopDetailPane`)

```
tenant taps "Contact via WhatsApp" (single in-flight flag set)
  ├─ whatsappLink absent ─▶ localized snackbar (FR-014, never silent)
  ├─ wa.me link (localized ?text= appended when missing) ──▶ opens ──▶ done (no in-app navigation)
  ├─ wa.me can't open ─▶ sms: (same body) ──▶ tel: (phone from link path)  (D6)
  └─ every channel failed ─▶ localized launch-failure snackbar
```

Nothing is recorded and no profile lookup happens — the app reads the listing's own
`whatsappLink` directly (trimmed US3, 2026-08-09).

### 3.3 Saved-state transitions (per listing)

```
isSaved=false ──heart──▶ optimistically true → save(id) ──success──▶ true (persisted)
                                                   └─failure──▶ revert false + localized retry
isSaved=true  ──heart──▶ optimistically false → unsave(id) ──success──▶ false (persisted)
                                                   └─failure──▶ revert true + localized retry
```

Save/unsave are idempotent server-side (§7.1/7.2) so a re-tap after a transient failure
converges; the single in-flight flag prevents concurrent duplicate calls (edge cases).

### 3.4 Listing lifecycle visibility (tenant side)

Only `AVAILABLE` listings are discoverable (FR-001/FR-003). Browse always sends
`status=AVAILABLE`; the app never renders rented/pending/expired shops and never
re-implements visibility rules (backend authoritative). A listing deleted/unavailable
mid-view → `ListingNotFound` from `GET /listings/:id` → localized "no longer available"
message + return to results (US2 scenario 4).

---

## 4. Validation rules

| Rule | Source |
|---|---|
| `priceMax > priceMin` and `areaMax > areaMin` when both set (sheet-level, localized) | FR-002 quality of filters |
| Category/amenity filter values come from `fetchMeta` (never hardcoded) | spec Assumptions |
| City/district filter values come from `LocalityOptions` (flagged gap) | spec Assumptions, Phase 2 gap |
| Contact: launch the listing's `whatsappLink`; append localized `?text=` when missing; `sms:`→`tel:` fallback (D6) | FR-009, D6 |
| Duplicate tap prevention on save/unsave/contact via single in-flight flags | FR-014, edge cases |
| `annualRentWithVat` is display-only — never submitted or stored | FR-003, §8.4 |
| Debounce ≥ the human double-tap window; generation guard drops stale responses | FR-004, SC-002, D7 |

---

## 5. Wire-shape references

- Finalized: `GET /listings` §5.2 · `GET /listings/:id` §5.3 · `GET /listings/meta` §4.1 ·
  `POST /listings/:id/save` §7.1 · `DELETE /listings/:id/save` §7.2 ·
  `GET /users/me/saved-listings` §7.3 — all in `docs/FRONTEND_PHASE2_LISTINGS_API_GUIDE.md`.
  The tenant contact flow reads the listing's own `whatsappLink` from `GET /listings/:id`
  (§5.3) — no additional endpoints (the expected `POST /inquiries` / `GET /inquiries/mine`
  and the `GET /users/:id` landlord-profile lookup were removed from scope, 2026-08-09).
