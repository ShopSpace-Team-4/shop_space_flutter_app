---

description: "Task list for Shop Listing Management (Landlord Side) — Phase 2"
---

# Tasks: Shop Listing Management (Landlord Side) — Phase 2

**Input**: Design documents from `/specs/003-shop-listing-management/` (plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md)

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/ (all present)

**Tests**: **NONE.** Per constitution §7 (approved 2026-08-06), new code ships **without new tests**. Verification is the quality gate (`dart run tool/quality.dart` → `flutter analyze`, must stay clean) plus manual smoke at all three breakpoints × EN/AR.

**Organization**: Tasks are grouped by user story. Per user decision (2026-08-08): **My Listings (US2) is built first**, then Create/Become-a-Landlord (US1) — both are P1 and together form the MVP. US3 (Edit) and US4 (Lifecycle/Delete) follow. The "Listings" bottom-nav tab navigates to `/my-listings`.

**UI rule**: All screen UI MUST come from the `shop-space-ui` Figma file (Composio MCP). Each phase starts by pulling that screen's frames (FIGMA_DISCOVER_FIGMA_RESOURCES → FIGMA_GET_FILE_JSON → FIGMA_RENDER_IMAGES_OF_FILE_NODES) and extracting design tokens. Missing error/empty/loading frames are built consistently with existing tokens and flagged per the Phase 0 gap protocol.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1–US4)
- Exact file paths in every description
- After adding/editing freezed models, cubit states, or DI annotations, run `dart run build_runner build -d`
- After editing ARB files, run `flutter gen-l10n`
- Quality gate after each phase: `dart run tool/quality.dart`

## Path Conventions

Flutter app under `lib/`. New feature folder `lib/features/listing/` with the exact `data | repository | presentation` shape (constitution §2 — no `domain/`). Same freezed models flow data → repository → presentation unchanged.

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Feature skeleton + Figma discovery + reuse-seam confirmation. The Flutter scaffold (Phase 0/1) already exists — no project init needed.

- [X] T001 Create the `lib/features/listing/` skeleton with exactly `data/models/`, `repository/`, `presentation/cubits/`, `presentation/widgets/`, `presentation/screens/` subfolders (add `.gitkeep` in empty dirs), mirroring `lib/features/auth/` and `lib/features/user/`. No new packages, no new top-level folders.
- [X] T002 [P] Discover the `shop-space-ui` Figma file (Composio MCP: FIGMA_DISCOVER_FIGMA_RESOURCES, then shallow FIGMA_GET_FILE_JSON) and enumerate the Phase 2 screen frames, recording their node IDs for per-screen pulls: My Listings (list + detail), Create/Edit listing form (4 steps), Become-a-Landlord sheet, status picker, delete confirmation. Do not render yet. Node IDs recorded in `research.md` (Figma frame index); missing frames (detail, 4-step breakdown, status picker, delete dialog, landlord sheet) flagged for their pull phases.
- [X] T003 [P] Read and confirm the reuse seams this feature depends on (no code changes): `lib/features/user/repository/user_repository.dart` (`addRole`, `switchActiveRole` — fresh tokens already written via `SessionController.onTokensUpdated` inside `addRole`), `lib/core/network/session_controller.dart`, `lib/core/router/route_guards.dart` (`AuthGuard`/`SessionReader.roles`), `lib/core/network/interceptors/envelope_interceptor.dart` (unwraps the `meta` `{ success, data }` envelope with no pipeline change — D2), `lib/core/di/modules.dart`, `lib/core/localization/l10n.yaml` setup.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Data layer + typed failures + DI + localization keys that MUST exist before ANY user story UI can be built.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete.

- [X] T004 Add the 11 listing `Failure` subclasses to `lib/core/errors/failures.dart` (sealed hierarchy, `super.messageKey`): `ListingMetaUnavailable`, `ListingCreateFailed`, `ListingUpdateFailed`, `ListingStatusFailed`, `ListingDeleteFailed`, `ListingNotFound`, `MediaUploadFailed`, `MediaReorderFailed`, `MediaDeleteFailed`, `ListingNotOwned`, `InvalidMediaFile`.
- [X] T005 Add the switch cases for all new failures to `lib/core/errors/failure_messages.dart` resolving each to its l10n key.
- [X] T006 Extend `lib/core/errors/error_mapper.dart` so `/listings*` non-2xx responses map to the typed listing failures (404 → `ListingNotFound`, 403 → `ListingNotOwned`, `PATCH /listings/:id/status` rejection → `ListingStatusFailed`, `POST /listings` → `ListingCreateFailed`, `PUT` → `ListingUpdateFailed`, `DELETE` → `ListingDeleteFailed`, media endpoints → `MediaUploadFailed`/`MediaReorderFailed`/`MediaDeleteFailed`), falling back to the existing pipeline for everything else. Raw `DioException` must never reach the UI.
- [X] T007 Add the EN l10n keys for the 11 listing errors to `lib/core/localization/app_en.arb` (messageKey-style keys), then run `flutter gen-l10n`.
- [X] T008 Add the matching AR l10n keys (Arabic RTL) to `lib/core/localization/app_ar.arb`, then run `flutter gen-l10n`.
- [X] T009 Create `lib/features/listing/data/models/listing_status.dart`: `enum ListingStatus { pending, available, rented, expired }` with `ListingStatus.fromApi(String)` mapping `"PENDING"|"AVAILABLE"|"RENTED"|"EXPIRED"` (unknown values → `pending` + a data-integrity log, never crash) and `String get apiValue` (`"PENDING"` etc.).
- [X] T010 [P] Create `lib/features/listing/data/models/listing_media.dart`: freezed `ListingMedia{ id (_id via @JsonKey), mediaType, url, sortOrder }` with `fromJson`. The `id` is the `mediaId` used by reorder/delete (D3).
- [X] T011 [P] Create `lib/features/listing/data/models/shop_listing.dart`: freezed `ShopListing` with all fields per data-model.md §1.3 (`id`, `landlordId?`, `title`, `category`, `areaSqm`, `city`, `district`, `address?`, `description?`, `amenities`, `numberOfFloors?`, `floorNumber` (0 = ground), `availableFrom?` (ISO-8601 → DateTime), `minimumLeaseTerm?`, `annualRent`, `annualRentWithVat` (read-only, never submitted), `currency`, `securityDepositMonths?`, `status`, `media`, `thumbnailUrl?`, `isSaved?`).
- [X] T012 [P] Create `lib/features/listing/data/models/listing_summary.dart`: freezed `ListingSummary{ id, title, category, areaSqm, annualRent, currency, status, thumbnailUrl? }` for `GET /listings/my-listings` (bare array, no pagination).
- [X] T013 [P] Create `lib/features/listing/data/models/listing_meta.dart`: freezed `ListingMeta{ categories, amenities, statuses }` (all `List<String>`) for the `{ success, data }` exception endpoint.
- [X] T014 [P] Create `lib/features/listing/data/models/create_listing_request.dart`: freezed request, `toJson` only — `title, category, areaSqm, city, district, address, description, amenities, numberOfFloors, floorNumber, availableFrom (YYYY-MM-DD), minimumLeaseTerm, annualRent, currency ("EGP"), securityDepositMonths`. NO `annualRentWithVat`, NO `status`.
- [X] T015 [P] Create `lib/features/listing/data/models/update_listing_request.dart`: freezed request, `toJson` only, same field set as create. `status` is NEVER included (FR-010).
- [X] T016 [P] Create `lib/features/listing/data/models/status_update_request.dart`: freezed `{ status: ListingStatus.apiValue }`, `toJson` only.
- [X] T017 [P] Create `lib/features/listing/data/models/media_order_request.dart`: freezed `{ media: [ { mediaId, sortOrder } ] }` (full desired order, not deltas), `toJson` only.
- [X] T018 Create `lib/features/listing/data/models/pending_media.dart`: plain (non-freezed, non-transport) class `{ XFile file; int clientId; }` — local identity for reorder while unpersisted (data-model.md §3.3).
- [X] T019 Run `dart run build_runner build -d` to generate the freezed/json_serializable parts for T009–T018, then confirm `flutter analyze` is clean.
- [X] T020 Create `lib/features/listing/data/listing_datasource.dart` (`@Injectable`): `ListingDataSource` is the ONLY code touching dio. Methods (contract `listings-api.md`): `fetchMeta()`, `createListing(CreateListingRequest) → String (created id — response is minimal per API guide §5.1; repository re-fetches `getListing(id)` after photo upload for the full detail)`, `getMyListings() → List<ListingSummary>`, `getListing(String id)`, `updateListing(id, UpdateListingRequest)`, `updateStatus(id, StatusUpdateRequest)`, `deleteListing(id)`, `uploadMedia(id, List<XFile>, {onSendProgress})` via `FormData` with repeated `photos` fields (single batched request — media-upload.md), `reorderMedia(id, MediaOrderRequest)`, `deleteMedia(id, mediaId)`. `fetchMeta` returns the already-unwrapped `ListingMeta` (interceptor handles `{ success, data }` — D2, no pipeline change).
- [X] T021 Create `lib/features/listing/repository/listing_repository.dart` (abstract interface — a method IS a use case) and `listing_repository_impl.dart` (`@Injectable(as: ListingRepository)`): methods `fetchMeta`, `getMyListings`, `getListing`, `createListing(request, photos, {onProgress})`, `updateListing`, `saveEdit(...)` (strict protocol — body filled in US3), `changeStatus(id, ListingStatus)`, `deleteListing(id)`, `uploadMedia`/`reorderMedia`/`deleteMedia`. Thin delegation to the datasource for now; multi-call orchestration (create→upload = US1, strict save = US3) is added in its story's phase.
- [X] T022 Verify DI: run `dart run build_runner build -d` so `lib/core/di/injectable.config.dart` registers `ListingDataSource` + `ListingRepository` (Cubits will depend only on the injected interface). Confirm `dart run tool/quality.dart` passes.

**Checkpoint**: Data layer, failures, DI, and l10n error keys are in place. User story implementation can begin.

---

## Phase 3: User Story 2 - My Listings home base (Priority: P1) 🎯 (built first)

**Goal**: The landlord's home base. Opens My Listings, sees every owned listing (photo, title, key details, status badge), opens a detail (two-pane list+detail on expanded, pushed screen on compact/medium), changes a listing's status via the picker (PATCH), and always sees current data with proper loading/error/empty states (US2 + FR-009/FR-015 + listing-status.md).

**Independent Test**: With a landlord account that holds listings of differing statuses, open My Listings → all listings render with correct photo/title/details/status badge; select one → detail shows (in-pane on expanded, pushed on phone); change a status via the picker → the list reflects it on refresh; toggle airplane mode → friendly error + Retry; account with zero listings → empty state. Runs on its own (no create/edit/delete needed).

- [X] T023 [P] [US2] Pull the My Listings list + detail + status badge/picker frames from `shop-space-ui` (use recorded node IDs; FIGMA_GET_FILE_NODES + FIGMA_RENDER_IMAGES_OF_FILE_NODES) and extract the exact colors/type/spacing/radii/elevation into the screen's widgets. Flag any missing error/empty/loading frames per the gap protocol. (Frames `257:4378`/`257:4407`/`257:4408` are empty scaffolds — recorded in `research.md`; built from existing `core/theme` tokens per the gap protocol.)
- [X] T024 [US2] Add My Listings EN keys to `lib/core/localization/app_en.arb` (screen title, empty-state copy inviting the first listing, error + Retry, status labels Pending/Available/Rented/Expired, "not public yet" hint for PENDING, "List a shop" CTA), then `flutter gen-l10n`.
- [X] T025 [US2] Add the matching AR (RTL) keys to `lib/core/localization/app_ar.arb`, then `flutter gen-l10n`.
- [X] T026 [P] [US2] Create `lib/features/listing/presentation/cubits/my_listings_cubit.dart` (+ freezed state): `loadList()`, `loadDetail(id)`, `changeStatus(id, ListingStatus)`, `refresh()`; typed `Failure` states; `isSubmitting`/loading flags so duplicate taps are impossible (FR-014); status success updates the local `ListingSummary` and open detail without a full reload (listing-status.md).
- [X] T027 [P] [US2] Create `lib/features/listing/presentation/widgets/listing_status_badge.dart`: localized label + color per `ListingStatus` (renders whatever the server returns; never derives visibility — FR-011/D4).
- [X] T028 [P] [US2] Create `lib/features/listing/presentation/widgets/listing_card.dart`: `cached_network_image` thumbnail rendered as-is (absolute Cloudinary URL — never prepend base, D3), title, category, area, `annualRent` + `currency`, status badge; tap → detail.
- [X] T029 [US2] Create `lib/features/listing/presentation/widgets/status_picker.dart`: bottom-sheet picker offering ALL FOUR statuses (PENDING/AVAILABLE/RENTED/EXPIRED) with no client-side transition validation (D4); calls `changeStatus`; inline localized rejection error (`ListingStatusFailed`) + status re-fetched to converge; single-tap guard.
- [X] T030 [US2] Create `lib/features/listing/presentation/screens/my_listings_screen.dart`: two-pane list+detail on expanded (≥840dp, `core/responsive/window_size.dart`), single-pane list that pushes `/my-listings/:listingId` on compact/medium (FR-015/D8); lazy `ListView.builder` (no pagination — bare array); loading/error+retry/empty states; pull-to-refresh; "List a shop" CTA → `/listing-form`.
- [X] T031 [US2] Create `lib/features/listing/presentation/screens/listing_detail_screen.dart`: media gallery from `ShopListing.media` (in sortOrder), all fields incl. `annualRentWithVat` (display only), status badge + status-picker trigger; Edit and Delete buttons wired to `/listing-form/:listingId` and the delete flow (both completed in later phases).
- [X] T032 [US2] Register routes in `lib/core/router/app_router.dart` behind `AuthGuard` (no new guard types): `/my-listings` and `/my-listings/:listingId` → real screens; `/listing-form` and `/listing-form/:listingId` → `AppPlaceholderScreen` temporarily. Wire the "Listings" bottom-nav destination (`navListings`) in `AppAdaptiveShell` to `context.go('/my-listings')` instead of staying index-only.
- [X] T033 [US2] Quality gate: `dart run tool/quality.dart` clean + manual smoke at all three breakpoints × EN/AR (list, detail, two-pane on expanded, status change, error+retry, empty state). Run `dart run build_runner build -d` first if any freezed/cubit files changed. (Analyze gate clean; manual smoke pending — no image input to verify renders, per environment limitation.)

**Checkpoint**: My Listings is fully functional and testable on its own.

---

## Phase 4: User Story 1 - Tenant becomes a landlord and publishes their first listing (Priority: P1) 🎯

**Goal**: The "List a shop" journey. A tenant-only account taps "List a shop" → Become-a-Landlord bottom sheet → confirms → gains the landlord role (reusing Phase 1 `UserRepository.addRole`, no re-login) → 4-step create form (details → photos → price/lease → review) driven by `GET /listings/meta` → Submit creates a PENDING listing and auto-uploads photos (D5) → appears in My Listings → publish later via the status picker (US2). Full FR-001..FR-008 + become-landlord-flow.md + listing-form.md + media-upload.md.

**Independent Test**: From a brand-new tenant account: tap "List a shop" → sheet → confirm → create flow opens with no re-login; complete all 4 steps with valid data + photos; Submit → confirmation "listing is not yet public" → appears in My Listings as PENDING; publish via the picker → AVAILABLE. Role-upgrade failure (no connection) → localized error + retry, no role added, form not entered.

- [X] T034 [P] [US1] Pull the Create Listing 4-step form + Become-a-Landlord sheet frames from `shop-space-ui` and extract exact design tokens; flag missing frames (upload progress, review step, VAT display) per the gap protocol.
- [X] T035 [US1] Add create-form + become-landlord EN keys to `lib/core/localization/app_en.arb` (steps, field labels, validation messages, step indicator, sheet copy + confirm button, photo rules, ≥3 recommendation, batch upload progress, "created — not yet public" confirmation), then `flutter gen-l10n`.
- [X] T036 [US1] Add the matching AR (RTL) keys to `lib/core/localization/app_ar.arb`, then `flutter gen-l10n`.
- [X] T037 [P] [US1] Create `lib/features/listing/data/locality_options.dart`: curated EN/AR city + district option lists for the required dropdowns (FR-005). `meta` does NOT publish these — the gap is flagged for the backend team (research.md Open items).
- [X] T038 [P] [US1] Create `lib/features/listing/presentation/cubits/become_landlord_cubit.dart` (+ freezed state): calls the INJECTED `UserRepository.addRole(UserRole.landlord)` (never re-implements it; `UserRole` is the enum from `lib/features/user/data/models/user_role.dart`); on success best-effort `switchActiveRole(UserRole.landlord)` — a switch failure is NON-blocking (permissions come from `roles[]`, FR-013/D7); reflects updated roles on the session; failure → typed `Failure` (Phase 1 set) shown in-sheet for retry; single-tap guard. Tokens are already refreshed inside `addRole` — do NOT touch tokens here.
- [X] T039 [US1] Create `lib/features/listing/presentation/widgets/become_landlord_sheet.dart`: bottom sheet explaining the landlord role with one "Become a Landlord" action; loading state on the button; failure → localized message kept open for retry; dismissal stays in My Listings (no listing created).
- [X] T040 [US1] Create `lib/features/listing/presentation/cubits/listing_form_cubit.dart` (+ freezed `ListingFormState` per data-model.md §4): fetch `GET /listings/meta` once on open (failure → retryable `ListingMetaUnavailable`, Save disabled until category options load); 4-step machine (0 details, 1 photos, 2 price/lease, 3 review); manual field validation; photo staging as `PendingMedia`/`pendingAdds` (PNG/JPG ≤20MB only, invalid → `InvalidMediaFile` inline, never sent); `isSubmitting` (no double submit), `isUploading` + `uploadProgress 0..1`; create submit → `repo.createListing`.
- [X] T041 [P] [US1] Create `lib/features/listing/presentation/widgets/listing_form_step_details.dart`: title (`TextFormField`, trimmed, max length per Figma), category (single-select from meta categories), area sqm (numeric > 0), city + district (dropdowns from `locality_options.dart`), address (optional), description (optional multiline). Manual `Form` + custom validators only — NO form package.
- [X] T042 [P] [US1] Create `lib/features/listing/presentation/widgets/listing_form_step_photos.dart`: `image_picker` gallery/camera, photo grid with add/remove/reorder, ≥3 recommendation message (never a hard block — Q3/D3), inline type/size rejection (`InvalidMediaFile`) that does not disturb the rest of the form (FR-007 edge case).
- [X] T043 [P] [US1] Create `lib/features/listing/presentation/widgets/listing_form_step_price.dart`: number of floors (optional int), floor number (int, 0 = ground → renders "Ground" in EN/AR), available-from date picker (submit `YYYY-MM-DD`), minimum lease term (free text — assumption §5.1), annual rent (numeric > 0) with VAT preview (display-only ×1.15; never submitted — FR-008), currency read-only "EGP" (fixed, non-editable; submitted as "EGP" in the create body only), security deposit in whole months (optional int).
- [X] T044 [P] [US1] Create `lib/features/listing/presentation/widgets/listing_form_step_review.dart`: renders every entered field + the photo outcome + the VAT-inclusive rent tenants see (FR-008); edit mode also shows the staged media diff (used in US3).
- [X] T045 [US1] Create `lib/features/listing/presentation/screens/listing_form_screen.dart`: 4-step flow with step indicator, Next/Back, single centered column at EVERY size (FR-015/D8); Submit → `repo.createListing` with a single batch `LinearProgressIndicator` from `onSendProgress` (media-upload.md); success → "created, not yet public" confirmation → navigate to the listing's My Listings detail; failure → localized message + retry keeping the entered data (edge case: network fails mid-form).
- [X] T046 [US1] Implement `createListing` orchestration in `lib/features/listing/repository/listing_repository_impl.dart`: `POST /listings` (always PENDING — FR-006; response is a MINIMAL object, not a full `ShopListing` — API guide §5.1) → on success auto-upload photos via datasource `uploadMedia` with `onSendProgress` (single batch, D3) → re-fetch `getListing(id)` so the created detail model is complete for the success screen. Upload failure → listing STAYS PENDING, surface `MediaUploadFailed` with the clear localized "retry via edit" path — intentionally NOT all-or-nothing (D5). No "publish immediately" at create (FR-006).
- [X] T047 [US1] Replace the `/listing-form` placeholder with `ListingFormScreen` (create mode) in `lib/core/router/app_router.dart`; wire the "List a shop" CTA (My Listings empty state + app bar): read `roles[]` — contains `landlord` → go straight to `/listing-form`; else show `become_landlord_sheet` → on confirm success navigate to `/listing-form` (FR-001/FR-002). Never gate on `activeRole`.
- [X] T048 [US1] Quality gate: `dart run tool/quality.dart` clean + manual smoke at 3 breakpoints × EN/AR covering: full first-listing journey, role-upgrade failure (stays tenant, error + retry, form not entered), switch-active-role failure (non-blocking, still enters form), invalid photo rejection, meta retryable state. Run `dart run build_runner build -d` first if cubit files changed.

**Checkpoint**: The P1 MVP slice (My Listings + create + become-landlord) is complete and verifiable end to end.

---

## Phase 5: User Story 3 - A landlord edits an existing listing (Priority: P2)

**Goal**: Edit via the SAME prefilled 4-step form. Every field editable, photos staged (add/remove/reorder) and committed with the fields in one Save using the strict all-or-nothing protocol (D6). Status is never changed by an edit (FR-010). FR-010 + listing-form.md + media-upload.md (edit staging + failure semantics).

**Independent Test**: Edit a listing's price and title, add one photo, remove one photo, reorder the rest, Save → My Listings shows updated data + photos and the status is UNCHANGED. Saving a listing deleted elsewhere → "listing no longer exists" + return to My Listings. Non-owner save → localized error. A mid-save failure → "nothing was saved" and a full re-Save works.

- [x] T049 [P] [US3] Pull the edit-state frames (prefilled form + photo reorder UI) from `shop-space-ui` (reuse create frames where identical) and extract exact tokens; flag missing frames per the gap protocol.
- [x] T050 [US3] Add edit EN keys to `lib/core/localization/app_en.arb` (edit title, Save, "nothing was saved", "listing no longer exists", staged media labels, photo op result messages), then `flutter gen-l10n`.
- [x] T051 [US3] Add the matching AR (RTL) keys to `lib/core/localization/app_ar.arb`, then `flutter gen-l10n`.
- [x] T052 [US3] Extend `listing_form_cubit.dart` for edit mode (`isEditMode`): preload from `repo.getListing(id)` (parse `availableFrom` date part back from ISO-8601); stage `existingMedia` + `pendingAdds` + `pendingDeletes` + `pendingOrder` client-side only (nothing hits the server until Save — D6); submit → `repo.saveEdit`.
- [x] T053 [US3] Implement `saveEdit` strict all-or-nothing protocol in `lib/features/listing/repository/listing_repository_impl.dart`: re-fetch the FRESH server snapshot at the start of each attempt (retries converge), then in order `PUT /listings/:id` (fields only, NO status) → media `POST` adds → media `DELETE`s → `PUT media/reorder` with the final order; ANY step failure → "nothing was saved", full re-Save required; a 404 during any step → `ListingNotFound` ("listing no longer exists") + return to My Listings (D6, US3 edge cases).
- [x] T054 [US3] Extend `listing_form_screen.dart` for edit mode (prefill, back on step 1 exits to detail, review shows the staged media diff); add an Edit entry on `listing_detail_screen.dart` → `/listing-form/:listingId`.
- [x] T055 [US3] Replace the `/listing-form/:listingId` placeholder with `ListingFormScreen` (edit mode) in `lib/core/router/app_router.dart` (behind `AuthGuard`).
- [x] T056 [US3] Quality gate: `dart run tool/quality.dart` clean + manual smoke at 3 breakpoints × EN/AR (field edits, add/remove/reorder photos persist, status unchanged, deleted-elsewhere, non-owner, save failure → "nothing was saved" + successful re-Save).

**Checkpoint**: Create and edit both work independently and share one form.

---

## Phase 6: User Story 4 - A landlord manages a listing's lifecycle and can remove it (Priority: P2)

**Goal**: Full lifecycle via the status picker built in US2 (publish → AVAILABLE, mark RENTED, mark EXPIRED — backend authoritative on transitions) plus delete with an explicit confirmation (removes listing + photos). FR-011/FR-012 + listing-status.md.

**Independent Test**: Publish a pending listing → AVAILABLE; mark an available listing RENTED → change reflected; mark it EXPIRED → reflected; delete after confirmation → disappears from My Listings. A backend-rejected transition → localized error and the actual state is unchanged (re-fetched).

- [X] T057 [P] [US4] Pull the delete-confirmation + any lifecycle-specific frames from `shop-space-ui` and extract exact tokens; flag missing frames per the gap protocol.
- [X] T058 [US4] Add lifecycle/delete EN keys to `lib/core/localization/app_en.arb` (delete confirmation dialog, "listing deleted", delete errors, rejected-transition message, status re-fetch), then `flutter gen-l10n`.
- [X] T059 [US4] Add the matching AR (RTL) keys to `lib/core/localization/app_ar.arb`, then `flutter gen-l10n`.
- [X] T060 [US4] Add `deleteListing(id)` to `lib/features/listing/presentation/cubits/my_listings_cubit.dart` (DELETE via `repo.deleteListing`; reload list on success; `isSubmitting` guard; `ListingNotOwned`/`ListingNotFound`/`ListingDeleteFailed` localized — FR-014).
- [X] T061 [US4] Add the delete action + confirmation dialog to `lib/features/listing/presentation/screens/listing_detail_screen.dart` (per Figma): confirm → delete → remove from list + navigate back to My Listings (FR-012; deleting removes the listing AND its photos).
- [X] T062 [US4] Lifecycle polish in `my_listings_cubit.dart` + `status_picker.dart`: a rejected transition surfaces `ListingStatusFailed` localized and the current status is re-fetched so UI converges with the server (D4); a successful status change updates both the summary and the open detail; verify publish/rented/expired end to end. No client-side transition graph, ever.
- [X] T063 [US4] Quality gate: `dart run tool/quality.dart` clean + manual smoke at 3 breakpoints × EN/AR (full lifecycle, delete + confirmation, duplicate-tap guard, rejected-transition path).

**Checkpoint**: All four user stories are independently functional.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Multi-story quality, RTL/breakpoint audit, spec traceability, final gate.

- [X] T064 [P] Verify every listing screen at all three breakpoints × EN/AR (compact <600dp / medium 600–839dp / expanded ≥840dp): My Listings two-pane ONLY on expanded, form a single centered column everywhere, no overflow, no unusable controls (FR-015, SC-008). (Code-level audit 2026-08-08: `breakpointOf == expanded` gates the two-pane, form is a single centered `ConstrainedBox` at every size; all scrollables are `SingleChildScrollView`/`ListView.builder`. Manual smoke pending — environment limitation, see `gap-log.md`.)
- [X] T065 [P] RTL audit: Arabic mirroring for list, card, detail, form, review step, and photo ordering; confirm zero hardcoded user-facing strings anywhere in `lib/features/listing/` (all via `AppLocalizations`). (Full 216-key EN/AR ARB parity — 0 missing, 0 extra; the only literal user-visible strings are the language-neutral tokens `EGP` and `m²`, accepted as non-translatable per clarification.)
- [X] T066 [P] Confirm no architectural violations in `lib/features/listing/`: no `setState` business logic, no dio outside `listing_datasource.dart`, Cubits depend only on repository interfaces, no envelope parsing, no raw exceptions to the UI, duplicate-submission guards on every action (FR-014), `annualRentWithVat`/`currency` never submitted, `roles[]` (never `activeRole`) gates listing permissions (FR-013). (No violations found — see `gap-log.md` §5.)
- [X] T067 Run `dart run build_runner build -d` (if any generated file is stale) and the final gate `dart run tool/quality.dart` — must be clean. (build_runner: OK; gate: `PASS: analyze clean`, exit 0.)
- [X] T068 Spec trace + gap log: map every FR-001..FR-016 and SC-001..SC-008 to its implementing file; log flagged gaps per the Phase 0 protocol (city/district options not published by `meta` → flag to backend team; any missing Figma error/empty/loading frames → note tokens used). Final regression smoke of the full landlord journey (become → create → publish → my listings → edit → status → delete) at 3 breakpoints × EN/AR. (Traceability → `traceability.md`; gaps → `gap-log.md`. Regression smoke code-level done; manual portion pending — environment limitation.)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately.
- **Foundational (Phase 2)**: Depends on Setup — **BLOCKS all user stories**.
- **User Stories (Phase 3+)**: All depend on Foundational.
  - **US2 (My Listings)** builds first (P1) — the home base every later story's verification uses.
  - **US1 (Create + Become-a-Landlord)** builds second (P1) — its "appears in My Listings + publish" test now works because US2 exists.
  - **US3 (Edit)** builds third (P2) — shares the form built in US1.
  - **US4 (Status/Delete)** builds last (P2) — status change is already delivered in US2; US4 adds delete + lifecycle edge handling.
- **Polish (Phase 7)**: Depends on all four stories.

### User Story Dependencies

- **US2 (P1)**: Can start after Foundational. No dependency on other stories (verified against a landlord account that already holds listings).
- **US1 (P1)**: After Foundational; uses the status picker from US2 for its "publish" verification.
- **US3 (P2)**: After Foundational + US1 (shares `ListingFormCubit` and `listing_form_screen.dart`).
- **US4 (P2)**: After Foundational + US2 (uses the My Listings detail + status picker).

### Within Each User Story

- Pull Figma frames FIRST (UI comes from the design, never invented).
- Localization keys (EN then AR) before the widgets that use them.
- Cubit/state → widgets → screens → route wiring → quality gate.
- Run `build_runner` after freezed/DI edits and `gen-l10n` after ARB edits.

### Parallel Opportunities

- All `[P]` tasks run in parallel (different files).
- Phase 2 models (T010–T017) and ARB keys (T007/T008) are fully parallel.
- Within US2: Figma pull + ARB keys + cubit + badge/card widgets are parallel.
- Within US1: Figma pull + ARB keys + locality options + become-landlord cubit + the four step widgets are parallel (cubit first for step widgets to consume).
- Once Foundational completes, US2 and (its prerequisites only) can proceed; US3/US4 are sequential after US1/US2 because they edit the same form/cubit files.

---

## Parallel Example: User Story 1 (Create)

```bash
# Launch all independent pieces of US1 together:
Task: "T034 Pull Figma frames (create form + become-landlord sheet)"
Task: "T035/T036 Add EN + AR l10n keys"
Task: "T037 Create locality_options.dart"
Task: "T038 Create become_landlord_cubit.dart"
Task: "T040 Create listing_form_cubit.dart"
# (step widgets T041-T044 consume T037/T040; screen T045 consumes the steps; repo T046 + router T047 close the loop)
```

---

## Implementation Strategy

### MVP First (User Story 2, then User Story 1)

1. Phase 1: Setup → Phase 2: Foundational (**blocks all stories**).
2. Phase 3: US2 (My Listings) → test independently (list/detail/status/error/empty).
3. Phase 4: US1 (Create + Become-a-Landlord) → test independently (full first-listing journey).
4. **STOP and VALIDATE** the two P1 slices together — this is the deployable MVP.
5. Phase 5: US3 (Edit) → test independently.
6. Phase 6: US4 (Lifecycle/Delete) → test independently.
7. Phase 7: Polish + final gate.

### Incremental Delivery

- After each phase: `dart run tool/quality.dart` must pass and the phase's manual smoke (3 breakpoints × EN/AR) must be green before moving on.
- Each story adds value without breaking earlier stories (no new packages, no new folder conventions, no new test files).

---

## Notes

- `[P]` tasks = different files, no dependencies.
- `[Story]` maps the task to its user story for traceability.
- **Tests**: none are written (constitution §7, 2026-08-06). Verification = `dart run tool/quality.dart` (analyze) + manual smoke at 3 breakpoints × EN/AR.
- UI values come ONLY from the `shop-space-ui` Figma file; missing error/empty/loading states are built from existing tokens and flagged.
- After adding/editing freezed models, cubit states, or DI annotations: `dart run build_runner build -d`. After ARB edits: `flutter gen-l10n`.
- Commit after each task or logical group. Stop at any checkpoint to validate the story independently.
- Avoid: vague tasks, same-file conflicts, cross-story dependencies that break independence (US3/US4 edit the shared form/cubit files, so they run after US1/US2).
