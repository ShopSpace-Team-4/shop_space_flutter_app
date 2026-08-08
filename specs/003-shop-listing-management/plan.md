# Implementation Plan: Shop Listing Management (Landlord Side)

**Branch**: `003-shop-listing-management` | **Date**: 2026-08-07 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/003-shop-listing-management/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command; its definition describes the execution workflow.

## Summary

Deliver Phase 2 of ShopSpace: landlord-side listing management in `lib/features/listing/`, built on
the Phase 0/1 foundations. A tenant taps "List a shop" → if `roles[]` lacks `landlord`, a
"Become a Landlord" bottom sheet confirms the upgrade (reusing Phase 1 `UserRepository.addRole`
+ `switchActiveRole`, D7), then they enter a 4-step create form (details → photos → price/lease →
review) whose category/amenity options come from `GET /listings/meta`. One Submit creates the
listing (`POST /listings`, starts PENDING) then auto-uploads the collected photos (multipart,
D3/D5). "My Listings" (`GET /listings/my-listings`) is the landlord home base — two-pane
list+detail on expanded, single-pane push on compact/medium (D8) — from which the landlord edits
via the same prefilled form (strict all-or-nothing save protocol D6), sets status freely via a
picker (D4), and deletes after confirmation. All requests reuse the Phase 0 dio pipeline
(envelope unwrapped once, single silent 401 refresh, typed `Failure`s only); the `meta` endpoint's
non-standard `{ success, data }` envelope is handled transparently by the existing interceptor
(D2). UI is responsive at all three breakpoints and localized English + Arabic (RTL), no
hardcoded strings. Marketplace browse/detail/search/saved-listings are Phase 3 and out of scope.

## Technical Context

**Language/Version**: Dart 3.9.2 / Flutter 3.35.7 stable (`C:\flutter`; the bare `C:\dart-sdk` on
PATH is a different SDK and is only used by opencode's LSP — use `flutter` for all tooling).

**Primary Dependencies** (locked stack, no substitutions; nothing new added — `image_picker`,
`cached_network_image`, and `url_launcher` were already locked in Phase 0):
- `flutter_bloc` 9.1.1 (+ `equatable`) — Cubit-first; `MyListingsCubit`, `ListingFormCubit`,
  `BecomeLandlordCubit` (no full BLoC needed — discrete user actions, not event streams).
- `go_router` **17.2.3** (pin) — `my-listings` and `listing-form` routes behind the existing
  `AuthGuard`; no new guard types required.
- `dio` 5.11.0 — JSON + **multipart** (`FormData`) for `POST /listings/:id/media`, with
  `onSendProgress` for upload progress. Phase 0 interceptors reused as-is.
- `get_it` 9.2.1 + `injectable` 3.0.0 — `ListingRepository` / `ListingDataSource` registered
  against interfaces.
- `freezed` 3.2.5 + `json_serializable` — listing/request/response models.
- `image_picker` — gallery/camera pickers (already in pubspec); picked files validated for
  PNG/JPG and ≤20MB before use (D3).
- `cached_network_image` — render absolute Cloudinary `thumbnailUrl`/`url` values as-is (D3).
- `flutter_screenutil` 5.9.3 — scales values; Material 3 window size classes (compact
  <600dp / medium 600–839dp / expanded ≥840dp) decide layout structure only.
- `intl` 0.20.3 + `flutter_localizations` (`generate: true`, ARB/JSON under `core/localization/`).
- Tests: `bloc_test` + `mocktail` (existing), `integration_test` (existing). **No new tests ship
  this phase** (approved 2026-08-06); existing tests must stay green.

**Storage**: No new storage. Tokens live in `flutter_secure_storage` and `activeRole` in
`shared_preferences` (Phase 0/1, untouched). Photo *picked files* are held in memory for the
duration of the form flow (`XFile`s) and buffered in the edit save protocol (D6); no local
database or on-device photo persistence.

**Testing**: `dart run tool/quality.dart` runs `flutter analyze` **only** (analyze-only gate — the
test suite was removed 2026-08-06) and exits non-zero on any failure. Per constitution §7 (amended
2026-08-06), new listing code ships **without new tests** — no unit/cubit/widget/integration test
files are written this phase. Verification = the analyze gate + manual smoke at 3 breakpoints ×
EN/AR. Refactors must not break any existing suite.

**Target Platform**: iOS + Android (mobile-first Flutter app). `AppAdaptiveShell` stays the app
shell (NavigationBar compact, NavigationRail medium/expanded); My Listings is two-pane on
expanded only, the create/edit form is a single centered column at every breakpoint (D8).

**Project Type**: mobile-app (Flutter).

**Performance Goals**: Form and My Listings render without jank (≤60 fps); multipart photo upload
reports progress via `onSendProgress` (single bar for the whole batch, not per-file); every
destructive/cross-network action (create, save, status change, delete) is guarded by a single
in-flight flag so duplicate taps are impossible (FR-014); metadata fetched once when the form
opens (retryable, never hardcoded lists). My Listings list is a bare array (no pagination) —
render with a lazy `ListView.builder` for long lists.

**Constraints**:
- Envelope `{ message, status, data }` unwrapped exactly once, in the dio layer — features never
  parse it. `GET /listings/meta` returns `{ success, data }`; the existing `EnvelopeInterceptor`
  unwraps it transparently because it keys on the presence of `data` and `ApiEnvelope.fromJson`
  tolerates missing `message`/`status` (defaults to `''`) — **no pipeline change** (D2).
- Non-2xx → typed `Failure` (`core/errors/`), never raw exceptions to the UI. New failures
  (`ListingMetaUnavailable`, `ListingCreateFailed`, `ListingUpdateFailed`, `ListingStatusFailed`,
  `ListingDeleteFailed`, `ListingNotFound`, `MediaUploadFailed`, `MediaReorderFailed`,
  `MediaDeleteFailed`, `ListingNotOwned`, `InvalidMediaFile`) get l10n keys + `ErrorMapper`
  entries.
- Exactly ONE silent 401 refresh, retry once, then force logout (reuse `SessionController`).
- Authorization keys off the account's `roles[]` (landlord), never `activeRole` (FR-013,
  §8.2 of the API guide). `activeRole` only picks the dashboard.
- `addRole` returns a fresh token pair written via `SessionController.onTokensUpdated` BEFORE the
  caller sees the updated `User` — the listing flow must not re-implement token replacement.
- Create flow photo upload: listing created first (PENDING), then photos auto-uploaded in the
  same submit; a failed upload leaves a PENDING listing with a clear localized message + retry
  via edit (spec Session 2026-08-07; D5). This is intentionally NOT strict-all-or-nothing.
- Edit save is strict all-or-nothing from the user's perspective: staged photo ops + field
  changes commit in one Save; any step failing reports "nothing was saved" and requires a full
  re-Save (user decision; D6). The save protocol re-fetches fresh server state at the start of
  each attempt so retries converge (no duplicate uploads, 404 → "listing no longer exists").
- Status changes are a **free-form picker** over PENDING/AVAILABLE/RENTED/EXPIRED (user decision;
  D4) calling `PATCH /listings/:id/status`; the backend is authoritative on transitions (it may
  reject an invalid one — surfaced as a localized error, free-form picker kept, user decision
  2026-08-08). Marketplace visibility is backend-driven (only AVAILABLE shows; PENDING/RENTED/
  EXPIRED hidden — resolved 2026-08-08); the app reflects status and never re-implements
  visibility rules.
- VAT: `annualRentWithVat` is computed by the backend (annualRent × 1.15); the app only displays
  it and never submits it (FR-008, §8.4).
- City and district are required dropdowns (FR-005, §8.1). The metadata endpoint does NOT publish
  city/district options → the app uses a local curated EN/AR list and the gap is flagged for the
  backend team (spec Assumptions).
- `minimumLeaseTerm` is free text (spec Assumptions, API guide §5.1); `floorNumber: 0` = ground
  floor; `availableFrom` submitted as `YYYY-MM-DD`, parsed back from ISO-8601 when editing.
- Photo rules: PNG/JPG only, ≤20MB/file, ≥3 is recommendation only (Q3). Reject others with a
  clear localized message without disturbing the rest of the form (FR-007).
- Currency is fixed read-only EGP in the price step; the `currency` field stays on the model for
  forward compatibility (spec Session 2026-08-07). `currency: "EGP"` is sent in the create request body
  (API guide §5.1) but never re-submitted on update; only `annualRentWithVat` is never submitted
  (FR-008, §8.4).
- Security deposit is entered as a whole number of months (`securityDepositMonths`, optional int),
  matching the API guide field (resolved 2026-08-08).
- Base URL: `app_env.dart` points all envs at the single deployed Railway base
  (`https://shopspace-backend-production.up.railway.app`); the spec is port-agnostic.
- No hardcoded user-facing strings; full Arabic RTL. Design tokens from Figma only (`shop-space-ui`
  file, pulled at the start of this phase); missing error/empty/loading frames built consistently
  with existing tokens and flagged.

**Scale/Scope**: 10 listing API endpoints (`GET /listings/meta`, `POST /listings`,
`GET /listings/my-listings`, `GET /listings/:id`, `PUT /listings/:id`,
`PATCH /listings/:id/status`, `DELETE /listings/:id`, `POST /listings/:id/media`,
`PUT /listings/:id/media/reorder`, `DELETE /listings/:id/media/:mediaId`); browse/search/
save endpoints are Phase 3. Screens: My Listings (list + detail pane), Create Listing (4-step
form), Edit Listing (shared form, prefilled), status picker, delete confirmation, Become-a-Landlord
bottom sheet. One feature (`listing/`) with `data/`, `repository/`, `presentation/`; one
`ListingRepository` (interface + impl) + `ListingDataSource`, ~3 Cubits.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| # | Constitution rule | Status |
|---|---|---|
| 1 | Feature-first: `features/<feature>/{data,repository,presentation}`; **no `domain/`, no entities, no standalone use-case classes** (repository method = use case) | PASS — `listing/` exactly this shape |
| 2 | Same freezed models flow unchanged data → repository → presentation (no DTO mapping) | PASS — one model set per feature |
| 3 | Cubits depend on repository **interfaces** via get_it; never impl/datasource/dio directly | PASS — `ListingRepository` interface registered in DI |
| 4 | Cross-feature reuse (both roles & listing upgrade) injects the same `UserRepository` | PASS — `BecomeLandlordCubit` calls injected `UserRepository.addRole`/`switchActiveRole`, no duplicated role logic |
| 5 | Envelope unwrapped once in dio; typed `Failure` only to UI; raw exceptions never reach UI | PASS — reuses Phase 0 pipeline; `meta` exception handled transparently (D2) |
| 6 | 401 → exactly one silent refresh, retry once, force logout | PASS — reuses `SessionController.sessionExpired` |
| 7 | Dual-role: default `tenant`; `landlord` via one shared `UserRepository.addRole(UserRole.landlord)`; `activeRole` persisted and only picks the dashboard; permission UI reads `roles[]` | PASS — by design (D7); listing actions gated on `roles[]` |
| 8 | `addRole` returns fresh tokens → replace stored pair immediately | PASS — reused Phase 1 `addRole` (already writes tokens via `onTokensUpdated`) |
| 9 | Password change → clear session, go to login immediately | N/A Phase 2 — no new session-mutation surfaces |
| 10 | Signup always routes to OTP, never login; Google sign-in uses ID token for `/auth/google` | N/A Phase 2 — auth flows untouched |
| 11 | Landlord contact = WhatsApp deep link + Inquiry (not in-app chat) | N/A Phase 2 — contact surfaces are Phase 3; no contact UI introduced |
| 12 | No package/pattern/folder beyond the locked list without approval | PASS — no new dependencies or folders; `image_picker`/`cached_network_image` already locked in Phase 0 |
| 13 | Design tokens only from Figma; missing frames built consistently + flagged | PASS — `shop-space-ui` pulled at phase start; gaps flagged |
| 14 | Localization: EN + AR full RTL; no hardcoded strings, ever | PASS — by design |
| 15 | Every Cubit `bloc_test`-covered; critical flow has `integration_test`; checked at 3 breakpoints × 2 languages; `flutter analyze` clean | PASS (adjusted) — new listing code ships **without new tests** (approved 2026-08-06); existing tests stay green and shared-widget tests still gate EN/AR × 3 breakpoints |

No violations → Complexity Tracking below is intentionally empty.

**Re-check after Phase 1 design (2026-08-07):** re-verified against `data-model.md`, `contracts/*`,
and `quickstart.md` — all 15 gates still hold (listing feature shape D1; shared freezed models;
repository-interface Cubits; `UserRepository` reuse incl. fresh-token replacement; envelope handled
once with the `meta` `{ success, data }` exception unwrapped transparently D2; 401 pipeline reused;
`roles[]` gating FR-013; no new packages/folders; Figma tokens deferred to implementation with gaps
flagged; EN/AR externalized; tests adjusted per 2026-08-06 approval). No violations introduced.

## Project Structure

### Documentation (this feature)

```text
specs/003-shop-listing-management/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command) — D1–D8 decisions
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
│   ├── listings-api.md          # endpoint × payload × typed failure contract (incl. meta envelope exception)
│   ├── listing-status.md        # status model + free-form picker semantics
│   ├── listing-form.md          # 4-step form state machine, validation, city/district, VAT display
│   ├── media-upload.md          # multipart upload/reorder/delete + create auto-upload + edit strict save
│   └── become-landlord-flow.md  # sheet + addRole reuse + token refresh + activeRole + failure paths
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

Single Flutter project (matches Phase 0/1 layout; actual tree):

```text
lib/
├── main.dart                      # bootstrap: DI, router (unchanged)
├── app.dart                       # AppAdaptiveShell host (unchanged)
├── core/                          # Phase 0/1 — unchanged
│   ├── network/                   # dio_client, interceptors, session_controller
│   ├── router/                    # app_router + route_guards (AuthGuard re-used)
│   ├── storage/                   # token_storage, preferences_service
│   ├── errors/                    # failures (+ new listing failures), error_mapper, failure_messages
│   ├── theme/                     # AppColors/Typography/Spacing/Radius/Elevation
│   ├── localization/              # ARB + generated AppLocalizations (+ listing keys)
│   ├── responsive/                # window-size-class helpers
│   └── widgets/                   # shared AppLoadingView/AppErrorView/AppEmptyView
└── features/
    ├── auth/                      # Phase 1 — untouched
    ├── user/                      # Phase 1 — untouched (UserRepository.addRole reused)
    └── listing/                   # Phase 2 — landlord listing management
        ├── data/
        │   ├── models/            # ShopListing, ListingStatus (enum), ListingMedia,
        │   │                      #   ListingMeta (categories/amenities/statuses),
        │   │                      #   CreateListingRequest, UpdateListingRequest,
        │   │                      #   StatusUpdateRequest, MediaUploadResult,
        │   │                      #   MediaOrderRequest, PendingMedia, ... (freezed)
        │   └── listing_datasource.dart        # dio calls to /listings* + multipart
        ├── repository/
        │   ├── listing_repository.dart        # abstract interface (methods = use cases)
        │   └── listing_repository_impl.dart   # orchestrates create→upload, strict save protocol
        └── presentation/
            ├── cubits/            # my_listings, listing_form (create/edit shared),
            │                      #   become_landlord (wraps UserRepository.addRole/switchActiveRole)
            ├── widgets/           # listing_card, listing_status_badge, status_picker,
            │                      #   photo_grid (add/remove/reorder), become_landlord_sheet,
            │                      #   listing_form_step_* (details/photos/price/review)
            └── screens/           # my_listings (list+detail panes), listing_form
                                   #   (4-step create; prefilled edit)

test/                              # UNCHANGED this phase — constitution §7 (2026-08-06):
                                   # new code ships WITHOUT new tests; existing suites must stay
                                   # green. No new listing test files are created.
```

**Structure Decision**: Single Flutter project (as established in Phase 0 — no new packages or
monorepo). New feature boundary `listing/` uses the exact `data|repository|presentation` shape.
`ListingRepository` is an abstract interface + one impl, injected via get_it against the
interface; Cubits never see datasources or dio. The repository orchestrates the multi-call
sequences (create→upload in D5, strict save protocol in D6) so Cubits stay thin and testable.
Role upgrade reuses `UserRepository` directly (no duplication of `addRole`). No new top-level
directories or dependencies are introduced.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

No violations recorded; table intentionally left empty.
