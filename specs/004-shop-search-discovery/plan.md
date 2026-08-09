# Implementation Plan: Shop Search & Discovery (Tenant Side)

**Branch**: `004-shop-search-discovery` | **Date**: 2026-08-09 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/004-shop-search-discovery/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command; its definition describes the execution workflow.

## Summary

Deliver Phase 3 of ShopSpace: tenant-side shop search & discovery in two feature
boundaries — `search/` and `saved/` — on the Phase 0/1/2 foundations.
A signed-in tenant opens the Search tab (`/search`, replacing the placeholder) and
immediately sees a paginated list of **AVAILABLE** shops (`GET /listings` via the
Phase 2 `ListingRepository.browse` — the finalized browse contract, D2), each card
showing photo, title, location, and the backend-computed VAT-inclusive price
(`annualRentWithVat`, display-only). Filters (city/district, price range, size
range, shop type, amenities) map 1:1 onto `BrowseQuery` params, are **debounced** so
rapid changes settle on the latest criteria (D7), and open from a bottom sheet on
compact/medium vs a persistent sidebar on expanded; results load progressively with
an end-of-list state (D7). Tapping a card opens the tenant-facing detail
(`ShopListing` via `ListingRepository.getListing`) — in-pane on expanded, pushed
route `/search/:listingId` on compact/medium (D10). "Contact via WhatsApp" is a
**self-contained widget in `listing/`** (`WhatsAppContactButton`): it launches the
listing's own `whatsappLink` (`https://wa.me/<phone>`, guide §5.3 — finalized) with a
localized prefilled message via `url_launcher`, falls back `sms:` → `tel:` (phone from
the link path, D6), and surfaces a localized snackbar when the link is missing or
every channel fails (FR-009). **Nothing is recorded** — no Inquiry entity, no
confirmation screen, no history (removed 2026-08-09). Saved listings are a
self-contained feature area per spec Q1: `saved/` has its own
data/repository/presentation against the **finalized** save/unsave/my-saved
contract (`POST|DELETE /listings/:id/save`, `GET /users/me/saved-listings`, D3);
the shared `SavedListingsRepository` is injected into search, detail, home (heart
wiring — the Phase 2 visual-only hearts become interactive), and the Saved screen
so the saved state stays consistent everywhere (D8). No new packages; responsive at
all three breakpoints × EN/AR (RTL); Arabic-Indic price/number formatting added as a
`core/utils` formatter (D9).

## Technical Context

**Language/Version**: Dart 3.9.2 / Flutter 3.35.7 stable (`C:\flutter`; the bare
`C:\dart-sdk` on PATH is a different SDK and is only used by opencode's LSP — use
`flutter` for all tooling).

**Primary Dependencies** (locked stack, no substitutions; **nothing new added** —
`url_launcher` and `cached_network_image` were already locked in Phase 0):
- `flutter_bloc` 9.1.1 (+ `equatable`) — Cubit-first; `SearchCubit`,
  `ListingDetailCubit` (tenant), `SavedListingsCubit` (no full BLoC needed — discrete
  user actions, not event streams; the contact button is a self-contained widget, no
  cubit).
- `go_router` **17.2.3** (pin) — replace the `/search` placeholder; add
  `/search/:listingId` (tenant detail); `/saved` re-pointed at the real saved
  screen. All behind the existing `AuthGuard`.
- `dio` 5.11.0 — new datasource (`SavedListingsDataSource`) reuses the Phase 0
  pipeline unchanged (envelope unwrap, auth header, 401 single-refresh).
- `get_it` 9.2.1 + `injectable` 3.0.0 — register the new repositories/datasources
  against interfaces.
- `freezed` 3.2.5 + `json_serializable` — new models (`SearchFilters`,
  `SavedListing`).
- `url_launcher` — `wa.me` deep link + `sms:`/`tel:` fallback (locked Phase 0).
- `cached_network_image` — render absolute Cloudinary `thumbnailUrl`/media URLs.
- `flutter_screenutil` 5.9.3 — scales values; Material 3 window size classes
  (compact <600dp / medium 600–839dp / expanded ≥840dp) decide layout structure only.
- `intl` 0.20.3 + `flutter_localizations` — locale-aware number/price formatting
  (Arabic-Indic digits) via a new `core/utils/formatters.dart` (D9).
- Debounce/pagination use `dart:async` `Timer` + a request-generation counter — no
  third-party reactive-extensions package (D7).
- Tests: `bloc_test` + `mocktail` (existing), `integration_test` (existing).
  **No new tests ship this phase** (approved 2026-08-06); existing tests stay green.

**Storage**: No new storage. Tokens stay in `flutter_secure_storage`, prefs in
`shared_preferences` (Phase 0/1, untouched). No local cache of search results or
saved listings — every surface reads server state; saved consistency is achieved by
mutating through the one `SavedListingsRepository` (D8), not by a local cache.

**Testing**: `dart run tool/quality.dart` runs `flutter analyze` **only** (analyze-only
gate — the test suite was removed 2026-08-06) and exits non-zero on any failure. Per
constitution §7 (amended 2026-08-06), new Phase 3 code ships **without new tests**.
Verification = the analyze gate + manual smoke at 3 breakpoints × EN/AR. Refactors
(e.g. moving `SavedScreen`, re-pointing home card taps) must not break existing suites.

**Target Platform**: iOS + Android (mobile-first Flutter app). `AppAdaptiveShell`
stays the app shell (NavigationBar compact, NavigationRail medium/expanded); the
Search screen is three-region (filter sidebar + results list + detail pane) on
expanded only, and pushed-detail + bottom-sheet filters on compact/medium (D10, FR-015).

**Project Type**: mobile-app (Flutter).

**Performance Goals**: initial results within the spec's <2s on a normal connection
with skeleton placeholders from the first moment (SC-001); every filter change
refreshes without a full reload and rapid changes settle on the latest criteria with
no stale/racing results — 100% (SC-002, D7); progressive scroll pagination with no
duplicated items and a clear end-of-list state (FR-005); every destructive/cross-network
action (save/unsave, contact, retries) guarded by a single in-flight flag so duplicate
taps are impossible (FR-014, edge cases).

**Constraints**:
- Envelope `{ message, status, data }` unwrapped exactly once, in the dio layer —
  features never parse it. All endpoints used this phase are finalized (browse,
  detail, save/unsave, my-saved, and the `whatsappLink` field on `GET /listings/:id`,
  guide §5.3); the earlier expected contracts (`POST /inquiries`, `GET /inquiries/mine`,
  `GET /users/:id` public profile) were **removed from scope** (2026-08-09) — no mock
  datasource is needed.
- Non-2xx → typed `Failure` (`core/errors/`), never raw exceptions to the UI. New
  failures (`SaveListingFailed`, `UnsaveListingFailed`, `SavedListingsLoadFailed`)
  get l10n keys + `ErrorMapper` entries; the contact button surfaces localized
  snackbars directly (it throws nothing through the pipeline).
- Exactly ONE silent 401 refresh, retry once, then force logout (reuse
  `SessionController`). A 401 mid-search behaves the same (edge case).
- Only `AVAILABLE` shops are discoverable (FR-001, FR-003): the browse default
  `status=AVAILABLE` is kept and the app never surfaces rented/pending/expired shops.
  The backend is authoritative on visibility; the app never re-implements it.
- `annualRentWithVat` is backend-owned (`annualRent × 1.15`), **display-only**, never
  submitted or stored (FR-003, §8.4). Prices/numbers render with locale-aware
  Arabic-Indic digits + EGP formatting in AR (D9, gap-log #7).
- Save/unsave endpoints are **idempotent** (§7.1/7.2) — a re-tap is a no-op, never a
  duplicate entry; the app's single in-flight flag makes double-taps impossible anyway.
- The saved-listings item shape is the slim §7.3 payload (combined `location`
  string, no `city`/`district`/`category`/`status`/`landlordId`) → a dedicated
  `SavedListing` model in `saved/`, not a reuse of `BrowseListing` (D3).
- Filters: single-select city/district/category and multi-select amenities map 1:1
  to `BrowseQuery` params; category/amenity options come from `GET /listings/meta`
  (via `ListingRepository.fetchMeta`, retryable, never hardcoded); city/district
  options reuse the local curated `LocalityOptions` list (flagged gap — meta does
  not publish them). Sort defaults to newest-first (assumption D11; `sort=createdAt:desc`
  flagged to backend — falls back to server default if unsupported).
- WhatsApp contact: the button reads the listing's own `whatsappLink`
  (`https://wa.me/<phone>`, finalized, guide §5.3); `wa.me` takes the phone with the
  leading `+` stripped (already handled by the backend link). The prefilled message is
  localized (EN/AR) and URL-encoded, appended as `?text=` only when the link has none.
  If the listing carries no `whatsappLink` or every channel fails, the button shows a
  clear localized snackbar — never fails silently (FR-009, FR-014). Fallback chain:
  `sms:` → `tel:`, phone derived from the link path (D6).
- Base URL: `app_env.dart` points all envs at the single deployed Railway base
  (`https://shopspace-backend-production.up.railway.app`); port-agnostic.
- No hardcoded user-facing strings; full Arabic RTL. Design tokens from Figma only
  (`shop-space-ui`, pulled at the start of this phase — expected empty scaffolds per
  the Phase 2 experience; missing error/empty/loading frames built consistently with
  existing tokens and flagged, spec Q3).

**Scale/Scope**: New/changed endpoints — reuse `GET /listings` (browse) and
`GET /listings/:id` (detail) already on `ListingDataSource` (the detail payload now
carries `whatsappLink`, `createdAt`, `updatedAt` — guide §5.3); add `POST|DELETE
/listings/:id/save`, `GET /users/me/saved-listings` (finalized). Screens:
Search/Browse (three-region on expanded), tenant Listing Detail, filter bottom
sheet/sidebar, Saved Shops (real screen replacing the placeholder). Features:
`search/` and `saved/` — each with `data/` + `presentation/`, plus `saved/` with its
own `repository/` (search reuses `ListingRepository`, D2); the WhatsApp contact
button lives in `listing/` (no feature-level data/repository); ~3 Cubits.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| # | Constitution rule | Status |
|---|---|---|
| 1 | Feature-first: `features/<feature>/{data,repository,presentation}`; **no `domain/`, no entities, no standalone use-case classes** (repository method = use case) | PASS — `saved/` has the exact three-folder shape. `search/` has `data/` (SearchFilters, filter-option sources) + `presentation/` and **deliberately no `repository/`**: its data contract is the existing `ListingRepository.browse`/`getListing`, injected per the cross-feature reuse rule (see row 4) rather than duplicated as a second repository — documented, not a violation. The WhatsApp contact is a self-contained widget in `listing/`, not a feature |
| 2 | Same freezed models flow unchanged data → repository → presentation (no DTO mapping) | PASS — `SearchFilters`, `SavedListing` are freezed and flow unchanged; `BrowseListing`/`ShopListing`/`ListingMedia` reused as-is from `listing/` |
| 3 | Cubits depend on repository **interfaces** via get_it; never impl/datasource/dio directly | PASS — all new Cubits inject `ListingRepository` or `SavedListingsRepository` interfaces; the only datasource is `SavedListingsDataSource` |
| 4 | Cross-feature reuse (inject the same repository into multiple Cubits — never duplicate logic) | PASS — the same `SavedListingsRepository` is injected into `SearchCubit`, tenant `ListingDetailCubit`, home card heart, and `SavedListingsCubit`; the same `ListingRepository` serves search + home + detail |
| 5 | Envelope unwrapped once in dio; typed `Failure` only to UI; raw exceptions never reach UI | PASS — new datasources reuse the Phase 0 pipeline; the expected-contract endpoints (mock-first) still throw typed `Failure`s from the stub |
| 6 | 401 → exactly one silent refresh, retry once, force logout | PASS — reused `SessionController.sessionExpired`; search 401 edge case handled |
| 7 | Dual-role: default `tenant`; `landlord` via one shared `UserRepository.addRole`; `activeRole` persisted and only picks the dashboard; permission UI reads `roles[]` | PASS — search is available to any signed-in user (a landlord is also a tenant, spec Assumptions); no new role logic introduced |
| 8 | `addRole` returns fresh tokens → replace stored pair immediately | N/A Phase 3 — no role-mutation surfaces |
| 9 | Password change → clear session, go to login immediately | N/A Phase 3 — no session-mutation surfaces |
| 10 | Signup always routes to OTP, never login; Google sign-in uses ID token for `/auth/google` | N/A Phase 3 — auth flows untouched |
| 11 | Landlord contact = WhatsApp deep link (not in-app chat); no contact is recorded | PASS — the `WhatsAppContactButton` IS exactly this: launches the listing's own `whatsappLink` with a localized prefilled message and `sms:`/`tel:` fallback; no Inquiry entity, nothing recorded (removed 2026-08-09) |
| 12 | No package/pattern/folder beyond the locked list without approval | PASS — no new dependencies or folders; `url_launcher`/`cached_network_image` were locked in Phase 0; Arabic formatting is a new file inside the existing `core/utils/` |
| 13 | Design tokens only from Figma; missing frames built consistently + flagged | PASS — `shop-space-ui` pulled at phase start (expected empty scaffolds per Phase 2 gap-log #2); gaps flagged, never invented styles |
| 14 | Localization: EN + AR full RTL; no hardcoded strings, ever | PASS — by design; new l10n keys in `app_en.arb`/`app_ar.arb` |
| 15 | Testing & quality: new code ships **without new tests** (2026-08-06); existing suites stay green; checked at 3 breakpoints × 2 languages; `flutter analyze` clean | PASS (adjusted) — new Phase 3 code ships without test files; refactors (moving `SavedScreen`, re-pointing home card taps) must not break existing suites; manual smoke at 3 breakpoints × EN/AR |

No violations → Complexity Tracking below is intentionally empty.

**Re-check after Phase 1 design (2026-08-09):** re-verified against `data-model.md`,
`contracts/*`, and `quickstart.md` — all 15 gates still hold (feature shapes D1;
shared freezed models D2/D3; repository-interface Cubits; shared-injection
consistency D8; envelope handled once; 401 pipeline reused; `roles[]` untouched; no
new packages/folders; Figma tokens deferred to implementation with gaps flagged;
EN/AR externalized; tests adjusted per 2026-08-06 approval). The contact-flow gate
(constitution row 11) was re-scoped 2026-08-09 to the finalized `whatsappLink` — no
recorded Inquiry, no expected contracts. No violations introduced.

## Project Structure

### Documentation (this feature)

```text
specs/004-shop-search-discovery/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command) — D1–D12 decisions
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
│   ├── search-browse.md           # filters → BrowseQuery mapping, debounce/pagination/consistency
│   ├── saved-listings.md          # save/unsave/my-saved contract + SavedListing model + consistency
│   ├── whatsapp-contact-flow.md   # wa.me deep link from listing.whatsappLink + sms/tel fallback + snackbars
│   ├── responsive-search-layout.md# 3-region expanded / sheet+pushed compact/medium
│   └── arabic-number-formatting.md# core/utils formatters contract (Arabic-Indic, EGP)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

Single Flutter project (matches Phase 0–2 layout; actual tree):

```text
lib/
├── main.dart                      # bootstrap: DI, router (unchanged)
├── app.dart                       # AppAdaptiveShell host (unchanged)
├── core/                          # Phase 0–2 — mostly unchanged
│   ├── network/                   # dio_client, interceptors, session_controller (unchanged)
│   ├── router/                    # app_router: /search, /search/:listingId, /saved
│   │                              #   (AuthGuard)
│   ├── errors/                    # failures (+ Phase 3 save variants), error_mapper, failure_messages
│   ├── utils/                     # formatters.dart (NEW: locale-aware price/number, D9)
│   ├── localization/              # ARB + generated AppLocalizations (+ Phase 3 keys)
│   ├── theme/ · responsive/ · widgets/ · storage/   # unchanged (AppLoading/Error/Empty reused)
└── features/
    ├── auth/ · user/              # Phase 1 — untouched
    ├── listing/                   # Phase 2 — reused (browse/getListing via ListingRepository)
    │   ├── presentation/widgets/whatsapp_contact_button.dart  # NEW: self-contained contact (US3)
    │   └── presentation/screens/saved_screen.dart   # REMOVED placeholder → moved to saved/
    ├── home/                      # Phase 2 — card taps re-pointed to tenant detail
    │   └── .../home_listing_card.dart               # heart becomes interactive (D8)
    ├── search/                    # Phase 3 — tenant search & discovery
    │   ├── data/
    │   │   ├── models/            # SearchFilters, SearchFilterOptions (freezed)
    │   │   └── search_filter_builder.dart          # filters → BrowseQuery (search-browse.md)
    │   └── presentation/
    │       ├── cubits/            # search (debounce+pagination+generation guard),
    │       │                      #   listing_detail (tenant, reuses getListing)
    │       ├── widgets/           # search_result_card, filter_sheet, filter_sidebar,
    │       │                      #   filter_chips, shop_detail_pane, gallery_viewer
    │       └── screens/           # search_screen (3-region expanded), shop_detail_screen
    └── saved/                     # Phase 3 — self-contained saved-listings area (spec Q1)
        ├── data/
        │   ├── models/            # SavedListing (freezed, §7.3 slim payload, D3)
        │   └── saved_listings_datasource.dart     # save/unsave/my-saved (finalized contract)
        ├── repository/
        │   ├── saved_listings_repository.dart     # abstract interface
        │   └── saved_listings_repository_impl.dart
        └── presentation/
            ├── cubits/            # saved_listings
            ├── widgets/           # saved_listing_card, saved_heart_button
            └── screens/           # saved_screen (replaces the listing/ placeholder)

test/                              # UNCHANGED this phase — constitution §7 (2026-08-06):
                                   # new code ships WITHOUT new tests; existing suites must stay
                                   # green. No new Phase 3 test files are created.
```

**Structure Decision**: Single Flutter project (as established in Phase 0 — no new
packages or monorepo). Two new feature boundaries:
- `search/` reuses the finalized browse contract (`ListingRepository.browse` +
  `getListing`) per the cross-feature reuse rule — no duplicate repository (D2);
  its `data/` holds only the search-specific filter value types.
- `saved/` is fully self-contained per spec Q1 — its own `SavedListingsDataSource`
  (finalized save/unsave/my-saved endpoints), `SavedListingsRepository`
  interface + impl, and presentation. The shared repository is injected into
  search, detail, home, and the saved screen so `isSaved` stays consistent (D8).
- The WhatsApp contact lives as a self-contained `WhatsAppContactButton` widget in
  `listing/` (no feature-level data/repository): it launches the listing's own
  `whatsappLink` with a localized prefilled message and `sms:`/`tel:` fallback,
  surfaced on `ShopDetailPane` for both the expanded and pushed layouts (2026-08-09).
No new top-level directories or dependencies are introduced.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

No violations recorded; table intentionally left empty.
