# Contract: Search & Browse (Phase 3)

Feature `004-shop-search-discovery` · Spec `spec.md` · Plan `plan.md` · Model `data-model.md` · Decisions D2, D7, D11, D12

## Purpose

Defines how the `search/` feature turns the tenant's filter state into browse requests and
how the UI reacts. Search **reuses** the finalized Phase 2 browse contract — there is no new
backend endpoint and no new repository; `SearchCubit` injects `ListingRepository`.

## Inherited rules (non-negotiable)

1. Envelope `{ message, status, data }` unwrapped once in the dio layer; these contracts
   describe the `data` field.
2. Bearer token attached via interceptor; the app always sends the signed-in token so
   `isSaved` flags are accurate (spec Assumptions). 401 → one silent refresh, retry once,
   force logout.
3. Non-2xx → typed `Failure`; new variants live in `core/errors/failures.dart` with l10n
   keys + `ErrorMapper` entries. Raw exceptions never reach the UI (FR-014).

## Filter → query mapping (`SearchFilterBuilder`)

`SearchFilters` (data-model §1.1) → `BrowseQuery` (existing `browse_query.dart`):

| `SearchFilters` | `BrowseQuery` | Wire param |
|---|---|---|
| `city` | `city` | `city=<city>` |
| `district` | `district` | `district=<district>` |
| `category` | `category` | `category=<category>` |
| `priceMin` / `priceMax` | `priceMin` / `priceMax` | `priceMin=…` / `priceMax=…` |
| `areaMin` / `areaMax` | `areaMin` / `areaMax` | `areaMin=…` / `areaMax=…` |
| `amenities` | `amenities` (comma-joined) | `amenities=PARKING,AC` |
| `sort` | `sort` | `sort=field:direction` (D11) |
| `page` / `limit=10` | `page` / `limit` | `page=…` / `limit=10` |
| — (fixed) | `status = AVAILABLE` | `status=AVAILABLE` (FR-001) |

Unset filters are omitted (existing `BrowseQuery.toQueryParameters()`). The empty default
`SearchFilters()` = first page of available shops, newest-first (D11).

## Request discipline (`SearchCubit`)

- **Debounce**: filter commit starts a ~400 ms `Timer`; any earlier timer is cancelled, so
  rapid changes produce one request for the latest criteria (FR-004, SC-002). Pagination
  (`loadMore`) and the very first `load()` are not debounced.
- **Generation guard**: each browse future captures a generation int; the state applies a
  response only when its generation is still the latest — stale responses are dropped.
- **Pagination**: `page`/`hasMore`/`isLoadingMore` in state. A scroll notifier triggers
  `loadMore` when near the end; an in-flight flag blocks duplicate `loadMore`. `hasMore =
  meta.page < meta.pages`. End-of-list state renders when the last page is reached
  (FR-005). Pages append, never replace, and items are never duplicated.
- **Initial load**: skeleton/placeholder state renders from the first frame (FR-006).

## UI states

| State | Rendered when | Content |
|---|---|---|
| loading skeleton | first load / filter change | placeholder cards (FR-006) |
| loaded | results present | result cards, pagination, end-of-list marker |
| empty | 0 matches | localized "no shops matched" + one-tap reset-filters CTA (US1 scenario 3) |
| loadingMore | near-end fetch | bottom progress indicator (no list jump) |
| error | any fetch failure | friendly localized error + retry (US1 scenario 5, FR-014) |

The list keeps its scroll position on filter change unless the filters reset it (page 1) —
no jumping (US1).

## Saved-state surface

Result cards read `BrowseListing.isSaved` (authoritative from the browse response) and
toggle through the shared `SavedListingsRepository` (D8, contract `saved-listings.md`);
the optimistic update + revert keeps the card consistent with detail and the saved screen.
