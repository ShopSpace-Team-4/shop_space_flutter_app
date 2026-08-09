---

description: "Task list for Phase 3 — Shop Search & Discovery (Tenant Side)"
---

# Tasks: Phase 3 — Shop Search & Discovery (Tenant Side)

**Input**: Design documents from `/specs/004-shop-search-discovery/` (plan.md, spec.md, research.md, data-model.md, quickstart.md, contracts/).

**Prerequisites**: Phase 0–2 foundations (browse/detail on `ListingRepository`, `AppAdaptiveShell`, dio pipeline, DI via `get_it` + `injectable`, EN/AR localization). Constitution v2.1.0 governs HOW everything is built.

**Tests**: **NO new tests ship this phase** (approved 2026-08-06, constitution §8). Do not create test files. Verification = `dart run tool/quality.dart` (flutter analyze only) + manual smoke at 3 breakpoints × EN/AR. Existing tests must stay green; refactors (moving `saved_screen`, re-pointing home taps) must not break them.

**Organization**: Tasks are grouped by user story (spec.md priorities) so each story is an independently implementable and testable increment.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies).
- **[Story]**: Which user story this task belongs to (US1–US5). Setup / Foundational / Polish tasks carry no story label.
- Include exact file paths. Every user-facing string is externalized into **both** `app_en.arb` and `app_ar.arb` — never hardcoded.

## Non-negotiable rules for every task

- **Responsive**: every size/spacing/radius/icon/font scales with `flutter_screenutil` (`.h/.w/.sp/.r`); layout uses flex widgets (`Expanded`/`Flexible`/`Row`/`Column`/`Wrap`). Raw pixel literals in `build` are a lint failure (constitution §5).
- **Screenutil never picks layout; breakpoints never scale values** — use `core/responsive/window_size.dart` size classes for structure only.
- **Cubits call only repository interfaces via `get_it`** — never a datasource or dio directly.
- **Envelope is unwrapped once in the dio layer** — features never parse it. Non-2xx → typed `Failure` in `core/errors/`; raw exceptions never reach the UI.
- New datasources/repositories are annotated `@Injectable(as: X)` in their own file; `dart run build_runner build -d` regenerates `injectable.config.dart`. Cubits are constructed in screens (`_cubit = XCubit(repository: getIt<XRepository>())` in `didChangeDependencies`, disposed in `dispose`) — matching the existing pattern.
- `annualRentWithVat` is **display-only** (backend-computed) — never submitted or stored.
- Only `status=AVAILABLE` shops are discoverable (browse default) — never re-implement visibility rules.
- New typed `Failure`s need a `messageKey`, l10n keys in both ARB files, and an `ErrorMapper` entry where a real endpoint maps through the pipeline.

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Pull the design source, confirm the foundation is green, and orient on the exact reuse points before any code is written.

- [X] T001 Pull `shop-space-ui` Figma frames (file_key `pvU6vSwQkWqwT27HVS4Jcp`, via Composio Figma MCP) for the 3 Phase 3 screens — Search/Browse, Tenant Listing Detail, Saved Shops (Contact Confirmation and My Inquiries were removed from scope 2026-08-09). Record the concrete node IDs and per-screen pull results in the "Figma frame index (Phase 3)" section of `specs/004-shop-search-discovery/research.md` (mirroring the Phase 2 recording style). Flag any missing error/empty/loading frames; build them later from existing `core/theme` tokens (never invented styles, constitution §4). Expected result per research.md: frames are likely empty scaffolds — note that as a flag, don't block.
- [X] T002 Baseline the quality gate: run `flutter pub get` then `dart run tool/quality.dart` from the repo root. Confirm `flutter analyze` is clean BEFORE any Phase 3 work starts. If it is not clean, stop and report before proceeding.
- [X] T003 Orient on the reuse points (read-only, no code changes): `BrowseQuery` (`lib/features/listing/data/models/browse_query.dart` — note `priceMin/priceMax/areaMin/areaMax` are `int?`, default `status=AVAILABLE`, `limit=10`), `LocalityOptions` (`lib/features/listing/data/locality_options.dart`), `ListingRepository.browse/getListing/fetchMeta` (`lib/features/listing/repository/listing_repository.dart`), the router placeholders for `/search`, `/saved` (`lib/core/router/app_router.dart`), and the placeholder `lib/features/listing/presentation/screens/saved_screen.dart`. Record nothing; this is orientation only.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure ALL four user stories depend on. **No user-story work may start until this phase is complete.** Includes the shared `saved/` data + repository layers (per approved decision: hearts in US1/US2 are interactive from the start), the locale-aware formatters, and the new failure/l10n/error-mapping surface.

**⚠️ CRITICAL**: Do not start Phase 3 (US1) until the Phase 2 checkpoint below is green.

- [X] T004 Add the Phase 3 typed failures to `lib/core/errors/failures.dart`: `SaveListingFailed`, `UnsaveListingFailed`, `SavedListingsLoadFailed` — each a `class X extends Failure` with a `super(messageKey)` constructor (mirror the existing pattern). **Do NOT add a duplicate of `ListingNotFound`** — the existing `ListingNotFound` already covers the "no longer available" detail state (data-model §1.5). (US3 removed 2026-08-09: no `LandlordProfileUnavailable`/`ContactLaunchFailed` failure classes — the contact button is a self-contained `listing/` widget that launches the listing's own `whatsappLink` and surfaces localized snackbars directly.)
- [X] T005 Add `ErrorMapper` path mappings in `lib/core/errors/error_mapper.dart` for the finalized saved endpoints (mirror the `_mapListingBadResponse` structure with a new `_mapSavedBadResponse`): `POST /listings/:id/save` → `SaveListingFailed`, `DELETE /listings/:id/save` → `UnsaveListingFailed`, `GET /users/me/saved-listings` → `SavedListingsLoadFailed`. No mapper entries are needed for the contact flow — the button throws nothing through the pipeline. Add new message-key constants matching the keys you create in T006.
- [X] T006 Add the new failure message keys plus the Phase 3 shared strings to **both** `lib/core/localization/app_en.arb` and `lib/core/localization/app_ar.arb`: `errorSaveListingFailed`, `errorUnsaveListingFailed`, `errorSavedListingsLoadFailed` — friendly, localized messages with a clear retry path (FR-014), mirroring the existing `errorListing*` tone. Arabic keys render RTL. (`errorContactLaunchFailed` stays for the contact button's launch-failure snackbar; no `errorLandlordProfileUnavailable` — the profile lookup is gone.)
- [X] T007 Create `lib/core/utils/formatters.dart` (D9, contract `arabic-number-formatting.md`): `formatPrice(double, AppLocalizations, {bool compact})`, `formatPriceCompact`, `formatArea`, `formatDate`, `formatDeposit`, `formatLease`. Use `intl` `NumberFormat` with the active locale so Arabic renders Arabic-Indic digits (`٦٩٠٬٠٠٠ ج.م`) and English renders `EGP 690,000`; compact form localized (`٦٩٠ ألف` / `690K`); formatters return plain strings, never layout. This is the ONLY number/price formatting surface — every Phase 3 screen uses it.
- [X] T008 Create the `SavedListing` freezed model in `lib/features/saved/data/models/saved_listing.dart` (D3, contract `saved-listings.md`, API guide §7.3 slim payload): `id, title, location` (combined `"New Cairo, Cairo"` string), `annualRent, annualRentWithVat, currency, areaSqm, thumbnailUrl?, isSaved`. Do NOT reuse `BrowseListing` — the shapes differ.
- [X] T009 Create `SavedListingsDataSource` in `lib/features/saved/data/saved_listings_datasource.dart` annotated `@Injectable(as: SavedListingsDataSource)`: `save(id)` → `POST /listings/:id/save`, `unsave(id)` → `DELETE /listings/:id/save` (both return bare `{}`), `getSavedListings()` → `GET /users/me/saved-listings` (bare `List<SavedListing>` array, no pagination meta). Reuse the Phase 0 dio pipeline untouched; throw typed failures via the pipeline (idempotent endpoints, contract §7.1/7.2).
- [X] T010 Create the `SavedListingsRepository` abstract interface in `lib/features/saved/repository/saved_listings_repository.dart`: `Future<void> save(String listingId)`, `Future<void> unsave(String listingId)`, `Future<List<SavedListing>> getSavedListings()`.
- [X] T011 Create `SavedListingsRepositoryImpl` in `lib/features/saved/repository/saved_listings_repository_impl.dart` annotated `@Injectable(as: SavedListingsRepository)` delegating straight to `SavedListingsDataSource`. This ONE repository instance is later injected into every heart surface (search, detail, home, saved screen) — D8.
- [X] T012 Run `dart run build_runner build -d` to regenerate freezed + injectable config, then `dart run tool/quality.dart`. Both must succeed.

**Checkpoint**: Foundation ready — `SavedListing` flows unchanged data→repository→presentation; formatters exist; failures/l10n/mapping are wired; `SavedListingsRepository` is resolvable via `getIt`. User-story implementation can now begin.

---

## Phase 3: User Story 1 — A tenant searches and filters shops (Priority: P1) 🎯 MVP

**Goal**: Signed-in tenant opens the Search tab and sees the newest AVAILABLE shops as cards (photo, title, location, VAT-inclusive price); narrows with filters (city/district, price, size, category, amenities) that refresh quickly with no list jump; sorts (newest default / price asc / price desc); loads pages on scroll with an end-of-list state; sees a skeleton on first load and localized empty/error states with reset/retry actions.

**Independent Test**: Sign in, open Search, confirm the initial list of available shops appears; apply each filter individually and confirm the list narrows; change sort and confirm reordering; scroll and confirm more results load then an end-of-list marker appears; set filters that match nothing and confirm the empty state's reset action. Works standalone on compact (expanded layout renders list + sidebar + a placeholder detail region until US2).

> **Note on the expanded detail region**: the right-pane detail view is completed in US2 (Phase 4). For US1, render a localized "select a shop" placeholder in the expanded third region (T023); US2's T032 replaces it with the real `shop_detail_pane`.

### Implementation for User Story 1

- [X] T013 [US1] Create the `SearchFilters` freezed model in `lib/features/search/data/models/search_filters.dart` (data-model §1.1, D12): `city, district, category` (`String?`, single-select), `priceMin, priceMax, areaMin, areaMax` (`double?`), `amenities` (`List<String>`, multi-select), `sort` (`String?`), `page` (`int`, default 1), `limit` (`int`, fixed 10). Empty default = all available shops, newest first. No validation here — the filter panel owns range validation.
- [X] T014 [P] [US1] Create the `SearchFilterOptions` freezed model in `lib/features/search/data/models/search_filter_options.dart` (data-model §1.2): `categories: List<String>`, `amenities: List<String>` (both from `GET /listings/meta` via `ListingRepository.fetchMeta`), `cities` and a `districtsFor(city)` helper backed by the local `LocalityOptions` (`lib/features/listing/data/locality_options.dart`) — never a hardcoded fallback list.
- [X] T015 [US1] Create `SearchFilterBuilder` in `lib/features/search/data/search_filter_builder.dart` (contract `search-browse.md`): converts `SearchFilters` → `BrowseQuery` 1:1 (`city/district/category` as-is, `double?` ranges converted to `int` for `BrowseQuery`, `amenities` comma-joined, `sort` as `field:direction`, `page`/`limit` — matching the backend wire params `page=…` / `limit=10` per API guide §5.2 and FR-005); `status=AVAILABLE` stays fixed; unset filters are omitted (`BrowseQuery.toQueryParameters()` handles it). Sort expressions (D11): newest → `sort=createdAt:desc` with graceful fallback to no sort on backend rejection; price asc/desc → `sort=annualRent:asc`/`sort=annualRent:desc`.
- [X] T016 [US1] Implement `SearchCubit` in `lib/features/search/presentation/cubits/search_cubit.dart` with a freezed `SearchState` (contract `search-browse.md`, D7). Injects `ListingRepository` + `SavedListingsRepository` via constructor. Responsibilities: (1) load `SearchFilterOptions` once on first open via `fetchMeta()` + `LocalityOptions` (retryable error state); (2) `load()` first page with skeleton state (FR-006); (3) `applyFilters(SearchFilters)` commits → resets page to 1 → **debounced ~400 ms** `dart:async` `Timer` (cancel the previous timer) → fetch; (4) **generation guard**: each fetch captures a monotonically increasing generation int, responses apply only if still latest (stale responses dropped); (5) pagination: `page/hasMore/isLoadingMore` in state, `loadMore()` guarded by an in-flight flag, `hasMore = meta.page < meta.pages`, pages append never replace; (6) `toggleSaved(String listingId, bool currentIsSaved)` → optimistic `isSaved` flip on the item, call `SavedListingsRepository.save/unsave`, revert + emit a localized message on failure (D8).
- [X] T017 [US1] Create `search_result_card.dart` in `lib/features/search/presentation/widgets/search_result_card.dart` (FR-007): thumbnail via `cached_network_image`, title, location (city/district), price via `formatPrice(annualRentWithVat)` (never the raw `annualRent`), and a heart button that reads `BrowseListing.isSaved` and calls `SearchCubit.toggleSaved` (optimistic, reverted on failure). Card tap behavior: expanded → select card (callback); compact/medium → push `/search/:listingId` (go_router).
- [X] T018 [US1] Create the shared filter panel `filter_panel.dart` in `lib/features/search/presentation/widgets/filter_panel.dart` (D10, contract `responsive-search-layout.md`): the ONE filter widget tree reused by both `filter_sheet.dart` and `filter_sidebar.dart`. It edits a **local draft** `SearchFilters` (city/district from `SearchFilterOptions`, category/amenities from meta options, price/size ranges, sort) and validates ranges (priceMax > priceMin, areaMax > areaMin) with localized errors. "Apply" commits the draft to `SearchCubit.applyFilters`; "Reset" restores the empty default + newest-first sort. All controls use screenutil scaling and flex layout.
- [X] T019 [P] [US1] Create `filter_sheet.dart` in `lib/features/search/presentation/widgets/filter_sheet.dart`: a bottom sheet (compact/medium only) that hosts the shared `filter_panel` widget. No filter logic lives here.
- [X] T020 [P] [US1] Create `filter_sidebar.dart` in `lib/features/search/presentation/widgets/filter_sidebar.dart`: a persistent sidebar (expanded only) that hosts the same shared `filter_panel` widget. No filter logic lives here.
- [X] T021 [P] [US1] Create `filter_chips.dart` in `lib/features/search/presentation/widgets/filter_chips.dart`: a horizontal, horizontally-scrollable row of active-filter chips with a remove/clear affordance per active filter; falls back to a "reset all" action. Renders nothing when no filters are active.
- [X] T022 [US1] Create `sort_control.dart` in `lib/features/search/presentation/widgets/sort_control.dart` (FR-016): newest (default) / price low-to-high / price high-to-low; selecting it commits the sort to `SearchCubit` so it applies to subsequent filter changes; resetting filters restores newest-first. Compact control (e.g. popup menu) that stays usable at every breakpoint.
- [X] T023 [US1] Create `search_screen.dart` in `lib/features/search/presentation/screens/search_screen.dart` (D10, FR-015): uses `core/responsive/window_size.dart` size classes — **expanded (≥840dp)**: three-region row = `filter_sidebar` + results list + a placeholder "select a shop to view details" right pane (replaced in US2 T032); **compact/medium (<840dp)**: full-screen list with a filter button opening `filter_sheet` and cards pushing `/search/:listingId`. Renders every `SearchState`: skeleton cards (FR-006), loaded list with `filter_chips` + `sort_control` + scroll pagination (loads next page near the end), `loadingMore` bottom indicator, end-of-list marker, localized empty state with a one-tap reset (US1 scenario 3), and localized error + retry (US1 scenario 5). No list jump on filter change (scroll position kept unless page 1 resets).
- [X] T024 [US1] Replace the `/search` placeholder branch in `lib/core/router/app_router.dart` (inside the `StatefulShellRoute.indexedStack` branch, so the `AppAdaptiveShell` nav bar stays) with the real `SearchScreen`. Remove the `AppPlaceholderScreen` usage and its import if no longer referenced.
- [X] T025 [US1] Add US1 l10n keys to **both** `lib/core/localization/app_en.arb` and `app_ar.arb`: search title, filter labels (city, district, price range, size range, category, amenities), sort labels, empty state ("No shops match your filters") + reset-filters action, end-of-list label, "select a shop" placeholder, filter-apply/reset buttons, range validation messages.
- [X] T026 [US1] Run `dart run build_runner build -d` then `dart run tool/quality.dart`. Both must pass.

**Checkpoint**: US1 fully functional and testable independently — search loads, filters + sort work with debounce and no stale results, pagination + end-of-list work, empty/error states with actions work, hearts are interactive via the shared `SavedListingsRepository`, and all three breakpoints × EN/AR render without overflow.

---

## Phase 4: User Story 2 — A tenant views a shop's full details (Priority: P1)

**Goal**: Tapping a card shows the complete listing: ordered photo gallery, title, description, location, size, shop type, amenities, floor details, availability date, minimum lease term, security-deposit months, status, and the VAT-inclusive annual rent — plus the consistent saved state. On expanded it renders beside the results; on compact/medium it is a pushed screen. A deleted/unavailable shop shows a friendly "no longer available" message and returns to results.

**Independent Test**: Open a shop card and confirm every field the landlord entered renders, the gallery shows photos in order, the saved state matches the list, and the layout matches the current screen size. Standalone slice (does not need US3/US5).

### Implementation for User Story 2

- [X] T027 [US2] Implement the tenant `ListingDetailCubit` in `lib/features/search/presentation/cubits/listing_detail_cubit.dart` with a freezed state. Injects `ListingRepository` + `SavedListingsRepository`. `load(String listingId)` → `getListing(id)`; renders full `ShopListing` on success; maps `ListingNotFound` to a dedicated unavailable state ("no longer available" + return to results, US2 scenario 4); other failures → localized error + retry. `toggleSaved()` mirrors the optimistic flip + revert protocol (D8). Reuses `ListingRepository` — do NOT create a new browse/detail repository.
- [X] T028 [P] [US2] Create `gallery_viewer.dart` in `lib/features/search/presentation/widgets/gallery_viewer.dart` (FR-008): renders `ShopListing.media` **ordered by `sortOrder`** via `cached_network_image`, with a pager/indicator that scales with screenutil. Empty media → a neutral placeholder consistent with theme tokens.
- [X] T029 [US2] Create `shop_detail_pane.dart` in `lib/features/search/presentation/widgets/shop_detail_pane.dart`: renders every field (title, description, location, size via `formatArea`, category, amenities, floor details, `availableFrom` via `formatDate`, minimum lease via `formatLease`, deposit via `formatDeposit`, status, `annualRentWithVat` via `formatPrice` — FR-003 display-only), the `gallery_viewer`, and the saved heart wired to `ListingDetailCubit.toggleSaved`. Renders the localized "no longer available" state with a return-to-results action when the cubit is in the unavailable state. **This is the ONE pane used both as the expanded right region and as the body of the pushed screen** (D10). Reserve the "Contact via WhatsApp" action slot (wired in US3, T037). All responsive (screenutil + flex).
- [X] T030 [US2] Create `shop_detail_screen.dart` in `lib/features/search/presentation/screens/shop_detail_screen.dart`: a `Scaffold` wrapper (AppBar with back) hosting the `ListingDetailCubit` + `shop_detail_pane` for the pushed compact/medium route. Construct the cubit with `getIt<ListingRepository>()` / `getIt<SavedListingsRepository>()` in `didChangeDependencies`, dispose in `dispose` (existing pattern).
- [X] T031 [US2] Add the `/search/:listingId` route to `lib/core/router/app_router.dart` with `redirect: guard?.call` (AuthGuard) → `ShopDetailScreen(listingId: pathParameters['listingId'])`. Only reachable from compact/medium; expanded uses the in-pane selection instead (no navigation).
- [X] T032 [US2] Wire the expanded in-pane selection in `search_screen.dart` (`lib/features/search/presentation/screens/search_screen.dart`): replace the US1 placeholder right region with the real `shop_detail_pane`; selecting a card updates the pane in place (no navigation). Reuse the same pane widget as the pushed screen for consistency.
- [X] T033 [US2] Re-point the Phase 2 home card taps to the tenant detail: in `lib/features/home/presentation/widgets/home_listing_card.dart` (and the surrounding tap handler in `home_screen.dart`), navigate to `/search/:listingId` with the card's listing id instead of the current destination. This refactor must not break the existing home cubit behavior; the analyze gate stays clean.
- [X] T034 [US2] Add US2 l10n keys to **both** `lib/core/localization/app_en.arb` and `app_ar.arb` (gallery indicator, "no longer available" message + return action, and any detail labels not already present in the `detail*` key set).
- [X] T035 [US2] Run `dart run build_runner build -d` then `dart run tool/quality.dart`. Both must pass.

**Checkpoint**: US1 + US2 both work independently — detail renders every field, gallery in order, saved state consistent with the list, expanded in-pane and pushed-route layouts both correct, home taps land on the tenant detail, unavailable listings show the friendly message + return.

---

## Phase 5: User Story 3 — A tenant contacts the landlord via WhatsApp (Priority: P2)

**Goal**: On detail, "Contact via WhatsApp" launches the listing's own `whatsappLink` (`https://wa.me/<phone>`, from `GET /listings/:id`, guide §5.3) directly with a localized prefilled message — no profile lookup, no feature-level data/repository. **Nothing is recorded** — no Inquiry entity, no confirmation screen/navigation (removed 2026-08-09). Fallbacks: `sms:` → `tel:` (phone from the link path) when WhatsApp isn't available; localized snackbar when the link is missing or every channel fails (FR-009, never silent). Double-tap = one action. The button is a self-contained `listing/` widget so BOTH surfaces that render `ShopDetailPane` get the wiring for free (constitution §2 reuse).

**Independent Test**: Open a shop's detail, tap "Contact via WhatsApp", confirm WhatsApp opens with a prefilled message about the shop (or the sms/tel fallback launches with the localized notice; a link-less listing shows the snackbar). Standalone slice.

### Implementation for User Story 3

- [X] T036 [US3] Create `WhatsAppContactButton` in `lib/features/listing/presentation/widgets/whatsapp_contact_button.dart` (contract `whatsapp-contact-flow.md`): a self-contained StatefulWidget (no cubit, no DI). Reads `listing.whatsappLink` directly — no profile lookup. Builds the localized prefilled message (`l10n.whatsappContactMessage`) and appends it as `?text=` ONLY when the link has none. Launches via `url_launcher` (`canLaunchUrl`/`launchUrl`, `LaunchMode.externalApplication`). Fallback chain `sms:` → `tel:` (phone derived from the wa.me path) when WhatsApp can't launch (D6). Single in-flight flag (FR-014). No `whatsappLink`, or all channels fail → localized snackbar (`whatsappContactUnavailable` / `errorContactLaunchFailed`), never a silent dead button. Responsive (screenutil + flex) and disabled while launching.
- [X] T037 [US3] Wire the button on `shop_detail_pane.dart` (`lib/features/search/presentation/widgets/shop_detail_pane.dart`): replace the reserved slot with `WhatsAppContactButton(listing: listing)`. No contact logic lives in `search/`.
- [X] T038 [US3] Add US3 l10n keys to **both** `lib/core/localization/app_en.arb` and `app_ar.arb`: `whatsappContactMessage` prefilled-message template with placeholders for EN and AR (e.g. "Hello, I'm interested in the shop '{title}' in {city}, {district}."), `whatsappContactUnavailable` (missing-link snackbar). Reuse the existing `shopDetailContactLandlord` label and `errorContactLaunchFailed`. **Remove the old record/confirmation keys** (`contactConfirmationTitle`, `contactHandoffTitle`, `contactHandoffMessage`, `contactRecordFailed`, `contactRetryRecord`, `contactViewMyInquiries`, `channelWhatsapp`, `channelSms`, `channelPhone`, `contactMessageTemplate`, `contactFallbackNotice`, `navInquiries`, `errorInquiryRecordFailed`, `errorInquiriesLoadFailed`).
- [X] T039 [US3] Delete `lib/features/inquiries/` (the whole feature area — models, mock datasources, launcher, repository, cubit, button). Remove the `/inquiries` placeholder route from `lib/core/router/app_router.dart`, the "My Inquiries" tile from `lib/features/user/presentation/screens/profile_screen.dart`, and the dead `LandlordProfileUnavailable` failure class (with its `messageKey` + `ErrorMapper` entries) from `lib/core/errors/`. Re-run `dart run build_runner build -d` so `injectable.config.dart` no longer registers any inquiries wiring.
- [X] T040 [US3] Run `dart run build_runner build -d`, `flutter gen-l10n`, then `dart run tool/quality.dart`. All must pass.

**Checkpoint**: US3 works standalone — contact opens WhatsApp (or sms/tel fallback) with the prefilled message; the missing-link/fallback snackbar surfaces when WhatsApp wasn't reached; double-taps produce one launch; nothing is recorded.

---

## Phase 6: User Story 5 — A tenant saves shops to revisit later (Priority: P2)

**Goal**: A self-contained saved-shops area (`saved/`, already has its data + repository from Phase 2): the Saved tab shows every saved shop with key details; saves/unsaves from search, detail, and home stay consistent everywhere via the ONE shared `SavedListingsRepository`; unsaves disappear on refresh; a saved list load failure shows a friendly error + retry. The Phase 2 home hearts become interactive.

**Independent Test**: Save a shop from the results list, open its detail and confirm the saved state, save a second from detail, open the Saved list and confirm both appear, then unsave one and confirm it disappears everywhere. Standalone slice.

### Implementation for User Story 5

- [X] T054 [US5] Implement `SavedListingsCubit` in `lib/features/saved/presentation/cubits/saved_listings_cubit.dart` with a freezed state: `loading / loaded(list) / empty / error`. `load()` calls `SavedListingsRepository.getSavedListings()` on open/refresh so unsaves from anywhere disappear and saves from anywhere appear (FR-013, SC-006); failure → localized error + retry (US5 scenario 4). `unsave(listingId)` removes from the loaded list (optimistic) and calls the repository, reverting + messaging on failure.
- [X] T055 [P] [US5] Create `saved_listing_card.dart` and `saved_heart_button.dart` in `lib/features/saved/presentation/widgets/`: card shows thumbnail (`cached_network_image`), title, the combined `location` string (rendered as-is), price via `formatPrice(annualRentWithVat)`, and area via `formatArea`; heart button toggles via `SavedListingsCubit`. Tapping the card opens the shop detail (`/search/:listingId`, US2). Responsive card + button.
- [X] T056 [US5] Create the real `saved_screen.dart` in `lib/features/saved/presentation/screens/saved_screen.dart`: AppBar "Saved", `BlocBuilder` over `SavedListingsCubit` rendering the card list, localized empty state, and error + retry. **Then DELETE the placeholder** `lib/features/listing/presentation/screens/saved_screen.dart` and remove its now-unused import from `lib/core/router/app_router.dart`. This move is forward-only — do not leave a dangling reference.
- [X] T057 [US5] Repoint the `/saved` shell-branch route in `lib/core/router/app_router.dart` (the `StatefulShellRoute` branch that currently builds the old `SavedScreen`) to the new `lib/features/saved/presentation/screens/saved_screen.dart`.
- [X] T058 [US5] Make the Phase 2 home hearts interactive (D8): in `lib/features/home/presentation/widgets/home_listing_card.dart`, replace the visual-only heart with a heart that injects the shared `SavedListingsRepository` (via `getIt<SavedListingsRepository>()`) and toggles save/unsave with the optimistic flip + revert + a localized failure message (contract `saved-listings.md` consistency protocol). **Do not add per-screen save logic anywhere** — every heart goes through this one repository.
- [X] T059 [US5] Add US5 l10n keys to **both** `lib/core/localization/app_en.arb` and `app_ar.arb`: "Saved" screen title, saved empty-state copy, save/unsave accessibility labels.
- [X] T060 [US5] Run `dart run build_runner build -d` then `dart run tool/quality.dart`. Both must pass.

**Checkpoint**: All four stories work — saved state is consistent across results, detail, home, and the saved list; unsaves disappear everywhere on refresh; the saved screen reads independently of search.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Final quality pass across all stories (constitution §8: analyze clean + manual smoke at 3 breakpoints × EN/AR).

- [X] T061 Run a final `dart run build_runner build -d` and `dart run tool/quality.dart`; fix any analyzer findings in the Phase 3 code. The gate must be clean.
- [ ] T062 Manual smoke test at all three breakpoints (compact <600dp / medium 600–839dp / expanded ≥840dp) × both languages (EN / AR RTL): search load + skeleton, each filter, sort, pagination + end-of-list, empty + error + retry, tenant detail (all fields, gallery, unavailable state), contact flow + fallback notice, saved list consistency, home hearts. Confirm Arabic prices/numbers render in Arabic-Indic digits (`formatPrice`/`formatArea`/`formatDate`) with no layout overflow and no unusable controls (SC-007, FR-015). Record the outcome against the story checkpoints.
- [X] T063 Record the backend hand-off flags in the "Open items" section of `specs/004-shop-search-discovery/research.md` (one note, clearly scoped): the `createdAt:desc` sort key assumption with fallback (D11); city/district options not published by `GET /listings/meta` (D12); Figma scaffolds expected empty (Q3). The contact flow needs NO backend flag — it consumes the finalized `whatsappLink` field on `GET /listings/:id` (guide §5.3) and the `sms:`/`tel:` fallback; the earlier `GET /users/:id` profile and `POST /inquiries` / `GET /inquiries/mine` dependencies were removed from scope (2026-08-09). Keep it factual for the backend team.
- [X] T064 Consistency sweep over every Phase 3 file: no duplicate save logic (all hearts through the one `SavedListingsRepository`), no hardcoded user-facing strings (all in ARB), no raw pixel literals in `build` (screenutil everywhere), no DTO→entity mapping (freezed models flow unchanged), no `domain/`/entity/use-case classes, Cubits depend only on repository interfaces (constitution §2/§5).

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — start immediately.
- **Foundational (Phase 2)**: Depends on Setup; **BLOCKS all user stories** (shared `saved/` layers, formatters, failures/l10n, mapper).
- **US1 (Phase 3, P1)**: Depends on Phase 2 only. Expanded right-pane detail region is a placeholder until US2.
- **US2 (Phase 4, P1)**: Depends on Phase 2 + US1 (the tenant `shop_detail_pane` completes the US1 expanded region; home taps re-point to the US2 route).
- **US3 (Phase 5, P2)**: Depends on US2 (button lives on the tenant detail pane). Self-contained `listing/` widget launching the listing's own `whatsappLink` — no feature-level data/repository (removed 2026-08-09).
- **US5 (Phase 6, P2)**: Depends on Phase 2 only (its data + repository are already foundational) + US2 for card navigation to `/search/:listingId`.
- **Polish (Phase 7)**: Depends on all desired stories being complete.

### User Story Dependencies

- **US1 (P1)**: After Foundational. Independent of other stories.
- **US2 (P1)**: After Foundational; completes US1's expanded region; re-points home taps. Independently testable.
- **US3 (P2)**: After US2. Independently testable.
- **US5 (P2)**: After Foundational (+ US2 for navigation). Independently testable.
- US3/US5 can proceed in any order after their dependencies; US5's own data+repository already shipped in Foundational.

### Within Each User Story

- Models → datasources/repositories → cubits → widgets/screens → router/l10n → regenerate + analyze.
- Story complete (checkpoint met) before moving to the next priority.

### Parallel Opportunities

- **Phase 1**: T001 and T002 are independent; T003 can run alongside.
- **Phase 2**: T004/T005/T006 (failures+mapper+l10n) and T007 (formatters) and T008 (SavedListing model) are independent; T009→T010→T011 are sequential (datasource → interface → impl); T012 closes the phase.
- **Within US1**: T013/T014 (models) are parallel; T015 (builder) after them; T017/T018/T019/T020/T021/T022 (widgets) are parallel after the cubit; T023 (screen) then T024/T025; T026 closes.
- **Within US2**: T028 (gallery) is parallel to T027 (cubit); T029→T030 then T031; T032/T033 parallel; T035 closes.
- **Within US3**: T036 (button) → T037 (wire) / T038 (l10n) parallel; T039 (delete `inquiries/`) parallel after T036; T040 closes.
- **Within US5**: T054 (cubit) then T055 (widgets) parallel; T056/T057/T058 parallel after T055; T059 parallel; T060 closes.
- **Phase 7**: T061 must precede T062; T063/T064 parallel.

### Parallel Example: US1 widgets

```bash
Task: "Create search_result_card.dart in lib/features/search/presentation/widgets/"
Task: "Create filter_panel.dart in lib/features/search/presentation/widgets/"
Task: "Create filter_sheet.dart in lib/features/search/presentation/widgets/"
Task: "Create filter_sidebar.dart in lib/features/search/presentation/widgets/"
Task: "Create filter_chips.dart in lib/features/search/presentation/widgets/"
Task: "Create sort_control.dart in lib/features/search/presentation/widgets/"
```

---

## Implementation Strategy

### MVP First (US1 Only)

1. Complete Phase 1 (Setup).
2. Complete Phase 2 (Foundational) — critical, blocks everything.
3. Complete Phase 3 (US1: search & filter).
4. **STOP and VALIDATE** US1 independently (compact flow fully; expanded list + sidebar with placeholder pane).
5. Deploy/demo if ready.

### Incremental Delivery

1. Setup + Foundational → foundation ready.
2. US1 → test independently → demo (MVP).
3. US2 → test independently → demo (full browse + detail + home re-point).
4. US3 → test independently → demo (contact conversion moment).
5. US5 → test independently → demo (saved shortlist).
6. Phase 7 polish + smoke → final.

### Parallel Team Strategy

- Team completes Setup + Foundational together.
- Once Foundational is done: Developer A → US1; Developer B → US5 (needs only Foundational + US2's route for card taps). US3 follows US2 by one developer.
- Every story is independently testable at its checkpoint.

---

## Notes

- **[P] tasks** = different files, no dependencies.
- **[Story] label** maps each task to its user story for traceability.
- **No new tests** this phase (constitution §8, approved 2026-08-06) — verification is the analyze gate + manual smoke at 3 breakpoints × EN/AR.
- Run `dart run build_runner build -d` every time freezed/injectable files change, or `flutter analyze` fails on stale generated code.
- Every user-facing string is externalized to `app_en.arb` + `app_ar.arb` from the first line of code.
- Reuse `ListingRepository` (`browse`/`getListing`/`fetchMeta`) — never duplicate browse/detail logic in `search/`.
- Every heart surface uses the ONE `SavedListingsRepository` — never per-screen save logic.
- The tenant contact flow is a self-contained `listing/` widget consuming the finalized `whatsappLink` on the listing (guide §5.3) — nothing is recorded, no inquiry endpoints, no mock datasource (2026-08-09).
- Commit after each task or logical group; stop at any checkpoint to validate the story independently.
- Avoid: vague tasks, same-file conflicts, cross-story dependencies that break independence, hardcoded strings/values, raw pixel literals.
