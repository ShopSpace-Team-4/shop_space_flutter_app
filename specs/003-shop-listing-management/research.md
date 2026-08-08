# Research: Shop Listing Management (Landlord Side) (Phase 2)

Feature `003-shop-listing-management` · Branch `003-shop-listing-management` · Plan `plan.md`

## Scope

Deliver landlord-side listing management in `lib/features/listing/` on top of the Phase 0/1
foundations: a "List a shop" entry point with an in-flow "Become a Landlord" sheet (reusing Phase 1
`UserRepository.addRole` + `switchActiveRole`), a 4-step create form (details → photos → price/lease
→ review) whose options come from `GET /listings/meta`, one Submit that creates the listing (PENDING)
then auto-uploads the photos, a My Listings home base (`GET /listings/my-listings`, two-pane on
expanded), the same form prefilled for edit with a strict all-or-nothing save, a free-form status
picker (`PATCH /listings/:id/status`), and delete with confirmation. Marketplace browse/search/detail
and saved listings are Phase 3 and out of scope.

## Resolved Decisions

### D1 — Feature boundary: `listing/` with the exact `data|repository|presentation` shape

**Decision**: One new feature folder `lib/features/listing/` with `data/` (datasource + freezed
models), `repository/` (abstract `ListingRepository` interface + one impl), and `presentation/`
(cubits, widgets, screens). The repository interface methods ARE the use cases; there is no
`domain/`, no entities, no standalone use-case classes. `ListingDataSource` is the only code that
touches dio. Cubits depend only on the injected `ListingRepository` interface (get_it + injectable).

**Rationale**:
- Matches the constitution §1/§2/§3 shape exactly and mirrors the Phase 0/1 features.
- The repository is where the multi-call sequences live (create→upload in D5, strict save protocol
  in D6), so Cubits stay thin, testable, and free of dio/FormData concerns.
- No new top-level directories or packages; `image_picker`, `cached_network_image`, and `url_launcher`
  were already locked in Phase 0 — nothing new is added.

**Alternatives rejected**:
- A `marketplace/` feature that also covers browse/detail/saved (those are Phase 3 with different
  session/visibility semantics; keep this phase scoped to landlord management).
- Splitting create and edit into two features (they share one form and one Cubit — FR-003/FR-010).

### D2 — Meta envelope exception: `{ success, data }` handled with zero pipeline change

**Decision**: `GET /listings/meta` is the single listing response that does not use the standard
`{ message, status, data }` envelope — it returns `{ success: true, data: ... }`. The existing Phase 0
`EnvelopeInterceptor` unwraps it transparently **as-is**: it keys on the presence of a `data` field,
and `ApiEnvelope.fromJson` defaults missing `message`/`status` to `''`. No interceptor change, no
feature-side parsing of the envelope.

**Rationale**:
- The `{ message, status, data }` envelope is unwrapped exactly once in the dio layer (constitution
  §5); a one-off envelope shape is a data-format nuance, not a reason to touch the pipeline.
- Keeps features ignorant of transport shape; the datasource simply receives the unwrapped
  `ListingMeta` from the interceptor.

**Alternatives rejected**:
- A special-case interceptor branch for `/listings/meta` (unnecessary — the generic path already
  tolerates it, verified against `ApiEnvelope.fromJson`).
- Letting the feature call dio directly for meta (violates the datasource-only rule).

**Verified**: `core/network/interceptors/envelope_interceptor.dart` unwraps on presence of `data`;
`ApiEnvelope.fromJson` tolerates absent `message`/`status` (defaults to `''`). Confirmed by reading
the Phase 0 sources.

### D3 — Photo rules & rendering (validation, upload, display)

**Decision**:
- Picked files are validated client-side: extension/type PNG or JPG only, file size ≤20MB (per API
  guide §6.1). Rejected files show a clear localized message and the rest of the form is unaffected
  (FR-007 edge case). ≥3 photos is recommendation only (Q3) — the app prompts but never blocks, and
  the backend accepts any count.
- Upload is multipart `POST /listings/:id/media` with repeated `photos` form fields; progress surfaced
  via dio `onSendProgress` as a single batch bar (not per-file).
- The backend returns absolute Cloudinary CDN URLs (`url`, `thumbnailUrl`); the app renders them
  directly as-is and never prepends a base address (§8.6). `cached_network_image` renders them.
- The `_id` returned per uploaded media item is the `mediaId` used by reorder and delete.
- Picked files during create are held in memory as `XFile`s for the duration of the form flow; no
  local database or on-device photo persistence.

**Rationale**: Mirrors the API guide and the Phase 0 locked stack (`image_picker`,
`cached_network_image`). Validation in the picker handler keeps invalid files out of the Cubit state
machines entirely.

**Alternatives rejected**:
- Enforcing a hard 3-photo minimum (backend accepts any count; Q3 says guidance only).
- Per-file progress bars (the guide exposes a single multipart response; one batch bar is simpler
  and unambiguous).

### D4 — Status is a free-form picker, not fixed action buttons

**Decision**: The landlord changes a listing's lifecycle through a **single status picker** offering
PENDING / AVAILABLE / RENTED / EXPIRED (the backend's enum, from `GET /listings/meta` or the model's
known set), calling `PATCH /listings/:id/status` with the chosen value. The backend is authoritative
on transitions (it may reject an invalid one — surfaced as a localized error); the app does not
re-implement a transition graph. Marketplace visibility (only AVAILABLE shows; PENDING/RENTED/
EXPIRED hidden — resolved 2026-08-08) is backend-driven and the app reflects the status value only —
it never re-implements visibility rules (FR-011).

**Rationale**:
- User decision 2026-08-07: free-form picker over fixed per-status action buttons.
- All four lifecycle actions in US4 (publish / mark rented / mark expired) map onto the same picker,
  so one widget + one PATCH covers the whole surface; the "Publish" quick-action is a convenience
  that preselects AVAILABLE in the picker.

**Alternatives rejected**:
- Fixed action buttons (Publish / Mark rented / Mark expired) that call status behind the scenes
  (user chose the picker; more widgets, more code paths for the same one endpoint).
- Client-side transition validation (backend owns the state machine; duplicating it invites drift).

### D5 — Create flow: listing first, photos auto-uploaded in the same Submit

**Decision**: One Submit performs `POST /listings` (listing starts PENDING) and, on success, uploads
all collected photos via the media endpoint as part of the same action. If an upload fails, the
listing remains pending (never silently lost) and the landlord sees a clear localized message with a
retry path through the edit flow (spec Session 2026-08-07, FR-007 edge case). This is intentionally
**NOT** strict all-or-nothing: a half-uploaded photo set is recoverable.

**Rationale**:
- The media API requires an existing listing id, so photo upload cannot precede creation.
- Losing a created listing because a photo failed would be worse than keeping a pending listing with
  a retry path; the spec explicitly prefers the pending-listing-with-retry behavior.
- Create-time "publish immediately" is not offered; the landlord publishes later via the status
  picker (D4), matching FR-006's explicit-publish requirement.

**Alternatives rejected**:
- Full rollback of the listing on photo failure (spec says keep the pending listing + retry).
- Blocking creation until all photos succeed (no endpoint for pre-created media; would dead-end).

### D6 — Edit save is strict all-or-nothing with a re-fetched snapshot

**Decision**: In the edit flow, all photo operations (add, remove, reorder) are **staged locally** and
committed together with the field changes in a single Save (user decision 2026-08-07). The save
protocol, orchestrated by the repository, is strict all-or-nothing from the user's perspective:
it re-fetches the fresh server listing at the start of each attempt, then applies in order
`PUT /listings/:id` (fields) → staged media ops (`POST` adds, `DELETE` removes, `PUT reorder` for a
final order) → on success emits the updated listing. If **any** step fails, the user is told "nothing
was saved" and must re-Save (a full re-attempt); the re-fetch at the start of the next attempt makes
retries converge (no duplicate uploads; a 404 → "listing no longer exists" and return to My Listings,
US3 edge case).

**Rationale**:
- The user explicitly chose all-or-nothing: a partially-saved edit that leaves the form and server
  out of sync is worse than a clean "nothing was saved, try again".
- Re-fetching the server snapshot at the start of each attempt prevents stale-base conflicts and
  satisfies the "deleted-elsewhere" edge case with a clean typed error instead of an opaque 404.
- The listing's status is never changed by an edit (FR-010); the PUT payload carries fields only.

**Alternatives rejected**:
- Per-operation persistence as the user taps (spec Session says buffer and commit on Save).
- Partial success surfacing (user rejected it; D6 is binary success/failure).
- Optimistic local mutation without the re-fetch (breaks the deleted-elsewhere and reorder-wins
  edge cases).

### D7 — "Become a Landlord" is an in-flow bottom sheet reusing Phase 1 seams

**Decision**: The single "List a shop" entry point (FR-001) checks the account's `roles[]`. If it
lacks `landlord`, a "Become a Landlord" confirmation bottom sheet explains what the role grants and
asks for confirmation (US1 scenario 1). On confirm, `BecomeLandlordCubit` calls the **injected
`UserRepository.addRole(UserRole.landlord)`** — the shared Phase 1 method, never a re-implementation. On
success it switches the active dashboard via `UserRepository.switchActiveRole` and routes straight
into the create flow with no re-login (FR-002). The fresh token pair returned by `addRole` is written
to storage by the Phase 1 implementation via `SessionController.onTokensUpdated` **before** the
caller sees the updated `User` — the listing flow must not re-implement token replacement.

**Rationale**:
- Constitution §4/§7/§8: cross-feature role logic lives in `user/`; duplicate `addRole` logic is
  forbidden; tokens must be replaced before the new role is used.
- Edge cases from the spec are handled by reusing the Phase 1 semantics: if `addRole` fails, no role
  is added, a localized error with retry is shown, and the create flow is not entered; if `addRole`
  succeeds but switching `activeRole` fails, the user still proceeds into the create flow because
  permissions come from `roles[]`, not `activeRole` (spec Edge Cases).

**Alternatives rejected**:
- Embedding a second copy of the role-upgrade request in `listing/` (constitution forbids it).
- Routing through the Phase 1 settings screen to add the role (FR-002 demands an in-flow, no-interruption
  upgrade).

### D8 — Responsive layout: two-pane My Listings on expanded, one form column everywhere

**Decision**: Material 3 window-size classes (established Phase 0: compact <600dp, medium 600–839dp,
expanded ≥840dp) decide layout structure; `flutter_screenutil` only scales values. My Listings is a
**two-pane list + detail** layout on expanded and a single-pane list with detail pushed as its own
screen on compact/medium (US2 scenario 3, FR-015). The create/edit multi-step form is a **single
centered column at every size** (FR-015), with a step indicator. `AppAdaptiveShell` remains the app
shell (NavigationBar compact / NavigationRail medium+expanded) — untouched.

**Rationale**:
- Mirrors US2 scenario 3 and the Phase 0 responsive rule (breakpoints pick structure, screenutil
  scales values — different jobs).
- The form as a fixed centered column keeps the 4-step flow usable at every size without a second
  layout.

**Alternatives rejected**:
- Two-pane My Listings on medium (spec ties two-pane to the widest class only).
- A multi-column form on expanded (FR-015 says single centered column at every size).

## Open items (non-blocking)

- **City/district options**: `GET /listings/meta` does not publish them (§4.1 only lists categories,
  amenities, statuses). The app uses a local curated EN/AR city/district list for the required
  dropdowns (FR-005, spec Assumptions) and this gap is flagged for the backend team.
- **Base URL**: `app_env.dart` points all envs at the single deployed Railway base
  (`https://shopspace-backend-production.up.railway.app`); there is no local dev base.
- **Figma fidelity**: `shop-space-ui` frames for My Listings / Create-Edit / status / Become-a-Landlord
  sheet are pulled at the START of implementation; missing error/empty/loading frames are built from
  existing tokens and flagged per the Phase 0 gap protocol.

## Figma frame index (Phase 2) — recorded during T002

File: **`shop space ui`** · file_key **`pvU6vSwQkWqwT27HVS4Jcp`** · accessed via Composio Figma MCP
(account `figma_crum-wecht`, ACTIVE). Frame tree: CANVAS `0:1` "Design System" → SECTION `104:262`
"Mobile App" → screen FRAMEs below. Used by per-screen pulls T023 (US2), T034 (US1), T049 (US3),
T057 (US4) via `FIGMA_GET_FILE_NODES` + `FIGMA_RENDER_IMAGES_OF_FILE_NODES`.

| Phase 2 screen | Frame node ID | Content holder(s) |
|---|---|---|
| My Listings (list) | `257:4378` | `257:4407` (Frame 60), `257:4408` (Frame 63) |
| Add Listing (form) | `242:1713` | `242:1811` (Frame 60) |
| Publish (form/publish step) | `242:1858` | `242:1887` (Frame 60), `242:2255` (Frame 63) |
| Verification (candidate for Become-a-Landlord) | `257:5164` | `257:5196`, `257:5197` |

**Gaps flagged (Phase 0 gap protocol — to confirm at the screen's pull time):**
- **My Listings detail pane**: no dedicated frame exists at top level; the detail is a sub-state of
  `257:4378` (or missing) — confirm when pulling T023.
- **4-step create form**: no explicit per-step frames; `242:1713` / `242:1858` are the form/publish
  surfaces — enumerate the actual steps during T034.
- **Status picker**: not found as a top-level frame — likely nested in a detail/My Listings child or
  missing; confirm during T023.
- **Delete confirmation dialog**: not found as a top-level frame — likely missing; build from tokens
  and flag during T057.
- **Become-a-Landlord sheet**: no frame named "Become a Landlord"; `257:5164` "Verification" is the
  closest candidate but unconfirmed — resolve during T034.
- Any missing error/empty/loading states are built from existing tokens and flagged (Plan §Constraints,
  spec Assumptions).

### T023 pull result (My Listings, 2026-08-08) — CONFIRMED EMPTY SCREEN FRAMES

Pulled `257:4378` (My Listings) at depth 3 via `FIGMA_GET_FILE_NODES` + rendered
`257:4378`, `257:4407` (Frame 60), `257:4408` (Frame 63) via `FIGMA_RENDER_IMAGES_OF_FILE_NODES`.
Also inspected `95:4028` (Home) and `97:5547` (Property) at depth 1.

**Finding**: all three My Listings frames are **empty scaffolds** — only the shared app shell
(status bar `92:*` instances, bottom-nav `Frame 51` with Home/Search/Saved/Profile buttons, and
*empty* content containers `257:4380`/`257:4407`/`257:4761`). **No list card, no status badge, no
status picker, no detail pane design exists anywhere in the file** (the same holds for Home/Property).
This matches the pre-flagged gaps above.

**Tokens extracted from the JSON that ARE present (all already in `lib/core/theme/app_colors.dart`)**:
- Active nav label `#2563EB` = `AppColors.primary`; inactive `#94A3B8` = `AppColors.textTertiary`.
- Content container `#F8FAFC` = `AppColors.background`; shell/bottom-nav fill `#FFFFFF` =
  `AppColors.surface`; bottom-nav top stroke `#E2E8F0` = `AppColors.outline`.
- Nav labels: Inter 10px (matches `AppTypography.caption`-scale usage; shell nav is `ThemeData`-styled).

**Action taken (user decision 2026-08-08: "Build from existing tokens")**: US2 list/card/badge/picker
widgets are built from the existing `core/theme` token set with **no invented values**; the absence of
design frames for these components is flagged here and tracked in the T067 gap log. Renders could not
be visually verified (model has no image input); JSON token extraction was used instead.

### T034 pull result (Create form + Become-a-Landlord, 2026-08-08) — CONFIRMED EMPTY SCREEN FRAMES

Pulled `242:1713` (Add Listing), `242:1811` (Frame 60 content), `242:1858` (Publish), `242:1887`
(Frame 60), `242:2255` (Frame 63), `257:5164` (Verification), `257:5196`/`257:5197` (containers) via
`FIGMA_GET_FILE_NODES` (depth 2) + rendered `242:1713`, `242:1858`, `257:5164` via
`FIGMA_RENDER_IMAGES_OF_FILE_NODES`.

**Finding**: same as T023 — all frames are **empty scaffolds**: only the shared app shell (status bar
`92:*` instances, bottom-nav `Frame 51` with the five `Button`s, empty content containers) exists.
`242:1811`/`242:1887`/`242:2255` are empty content frames (`#F8FAFC`/`#FFFFFF` fills); `257:5164`
"Verification" contains empty `Container`s only. **No 4-step form, no field widgets, no step
indicator, no photo grid, no review step, no become-landlord sheet design exists anywhere in the
file.** This matches the pre-flagged gaps.

**Tokens extracted from the JSON (all already in `lib/core/theme/app_colors.dart`)**: app-shell fill
`#FFFFFF` = `AppColors.surface`; content container `#F8FAFC` = `AppColors.background` (identical to
the T023 pull — no new tokens in the file).

**Action taken (consistent with T023)**: the create form, step widgets, become-landlord sheet, and
all form states are built from the existing `core/theme` token set with **no invented values**; the
absence of design frames for the 4-step create form and the become-landlord sheet is flagged here and
tracked in the T067 gap log. Renders could not be visually verified (model has no image input); JSON
token extraction was used instead.

### T049 pull result (Edit state, 2026-08-08) — CONFIRMED NO EDIT-STATE FRAMES EXIST

Pulled `242:1713` (Add Listing) and `242:1858` (Publish) — the only form-related top-level frames —
again via `FIGMA_GET_FILE_NODES` + `FIGMA_RENDER_IMAGES_OF_FILE_NODES`, specifically hunting for a
prefilled/edit state.

**Finding**: the create frames are reused for edit exactly as they are — **no prefilled-form,
photo-reorder, or edit-state design exists anywhere in the file**. `242:1713`/`242:1858` are the
same empty scaffolds as in T034 (app-shell fill `#FFFFFF` = `AppColors.surface`; content container
`#F8FAFC` = `AppColors.background`). Everything was already present in `core/theme`.

**Action taken (user decision 2026-08-08: "build from existing tokens")**: edit mode reuses the
create form widgets with no new tokens; photo reorder uses the user-approved
`flutter_reorderable_grid_view` package (v5.7.0) over the existing tile styling. The absence of
edit-state design frames is flagged here and tracked in the T067 gap log.

### T057 pull result (Delete confirmation + lifecycle, 2026-08-08) — CONFIRMED NO DELETE/LIFECYCLE FRAMES EXIST

Pulled `257:4378` (My Listings), `257:4407`/`257:4408` (content holders), `242:1713` (Add
Listing), `242:1858` (Publish), `257:5164` (Verification) at depth 3 via
`FIGMA_GET_FILE_NODES` + rendered all six via `FIGMA_RENDER_IMAGES_OF_FILE_NODES`; the full
JSON was walked node-by-node (children names + fill colors) hunting specifically for a delete
confirmation dialog, success/confirmation state, or any lifecycle-specific surface.

**Finding**: identical to T023/T034/T049 — every frame is an **empty scaffold**: shared app
shell (status-bar `92:*` instances, bottom-nav `Frame 51` with Home/Search/Saved/Profile
buttons) over **empty** content containers (`257:4380`/`Frame 60`/`Frame 63` content
`#F8FAFC`/`#FFFFFF` fills). **No delete confirmation dialog, no "listing deleted" success
state, no lifecycle-specific frame exists anywhere in the file.** This matches the pre-flagged
gap (`research.md` Figma frame index).

**Tokens extracted from the JSON (all already in `lib/core/theme/app_colors.dart`)**:
- App-shell fill `#FFFFFF` = `AppColors.surface`; content container `#F8FAFC` =
  `AppColors.background`; bottom-nav stroke `#E2E8F0` = `AppColors.outline` (already
  verified in T023).
- Nav labels: active `#2563EB` = `AppColors.primary`; inactive `#94A3B8` =
  `AppColors.textTertiary` (unchanged across all pulls).

**Action taken (user decision 2026-08-08: "build from existing tokens")**: the delete
confirmation dialog (AlertDialog), the "listing deleted" success toast, and the rejected
status-transition surface are built from the existing `core/theme` token set with **no
invented values** (error-styled actions use `AppColors.error`, confirm surface uses
`AppColors.surface`/`AppColors.surfaceVariant`, text uses `AppTypography`). The absence of
delete/lifecycle design frames is flagged here and tracked in the T067 gap log. Renders could
not be visually verified (model has no image input); JSON token extraction was used instead.
