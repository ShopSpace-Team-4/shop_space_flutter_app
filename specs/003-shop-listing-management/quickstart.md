# Quickstart — Phase 2 (Shop Listing Management)

Branch `003-shop-listing-management` · Spec `spec.md` · Plan `plan.md` · Model `data-model.md`

Scenarios for running, testing, and extending the Phase 2 listing feature (landlord-side create /
edit / status / delete / media). Read `../001-phase0-project-foundation/quickstart.md` first (Phase 0
baseline) and `../002-auth-verification-roles/quickstart.md` for the user/role seams this phase reuses
(never re-implements).

## Run

```powershell
# Flutter at C:\flutter (bare C:\dart-sdk on PATH is a DIFFERENT SDK — prefer `flutter`)
flutter pub get
dart run build_runner build -d          # after adding/editing freezed / injectable / json_serializable
flutter run --dart-define=APP_ENV=prod   # base: https://shopspace-backend-production.up.railway.app
```

Quality gate (must stay green; exits non-zero on failure):

```powershell
dart run tool/quality.dart               # flutter analyze + full flutter test (incl. integration_test)
```

## Key files

| Concern | Location |
|---|---|
| Listing datasource / freezed models | `lib/features/listing/data/` |
| Listing repository (interface + impl) | `lib/features/listing/repository/` |
| Listing screens/cubits (My Listings, detail, form) | `lib/features/listing/presentation/` |
| New typed failures | `lib/core/errors/failures.dart` (listing variants) |
| Role gate + become-landlord seam (REUSED) | `lib/features/user/repository/user_repository.dart` |
| Token rotation on `addRole` (REUSED) | `lib/features/auth/.../session_controller.dart` → `onTokensUpdated` |
| API + flow contracts | `specs/003-shop-listing-management/contracts/` |
| Data model | `specs/003-shop-listing-management/data-model.md` |

## Core flows (walkthrough)

### 1. List a shop (create) — role gate first

1. "List a shop" reads `roles[]` (never `activeRole`). No `landlord` → Become-a-Landlord bottom
   sheet (contract `become-landlord-flow.md`) → `UserRepository.addRole('landlord')` →
   `SessionController.onTokensUpdated(freshTokens)` BEFORE proceeding → `switchActiveRole(landlord)`.
   Switch failure ≠ blocker (permissions come from `roles[]`).
2. `ListingFormCubit` opens step 1; `GET /listings/meta` loads categories/amenities/statuses once
   (retryable `ListingMetaUnavailable`).
3. Steps: details → photos → price/lease → review. Manual `Form` validators; no form package.
4. Save (create, D5): `POST /listings` → always PENDING (FR-006) → batch photo upload
   (`POST /listings/:id/media`, repeated `photos`, shared progress bar). No "publish immediately";
   publish later via the status picker.

### 2. My Listings & detail

- `GET /listings/my-listings` → bare `List<ListingSummary>` (no pagination meta). Empty → empty
  state inviting the first listing. Failure → typed `Failure` + retry.
- Detail = `GET /listings/:id`. Status picker (PENDING/AVAILABLE/RENTED/EXPIRED) →
  `PATCH /listings/:id/status`; backend validates transitions (D4). Rejected transition →
  `ListingStatusFailed` + status re-fetched.

### 3. Edit listing — strict all-or-nothing (D6)

1. Re-fetch fresh `ShopListing` at the start of each attempt (snapshot).
2. Stage photo ops client-side only: `pendingAdds` (XFile) / `pendingDeletes` (mediaIds) /
   `pendingOrder` (final order). Reorder/delete hit the server ONLY on Save.
3. Save applies in order: `PUT /listings/:id` (fields only — NO status, FR-010) → media `POST`
   adds → media `DELETE`s → `PUT media/reorder`.
4. Any failure → "nothing was saved", full re-Save (retries converge via the fresh snapshot).
   404 during a step → "listing no longer exists" → back to My Listings.

### 4. Delete listing

- Detail → delete → confirmation dialog (FR-012) → `DELETE /listings/:id` (removes listing + its
  photos) → My Listings reloads.

## Testing

```powershell
flutter test test/features/listing         # datasource/repo/cubit (mocktail + bloc_test)
flutter test test/widget                   # 3 breakpoints × EN/AR
flutter test test/integration_test         # existing suites stay green
```

Per the approved 2026-08-06 rule: new Phase 2 listing code ships WITHOUT new tests; existing tests are
never deleted and must stay green — fix any failures caused by refactors/API drift.

## Gotchas

- `GET /listings/meta` returns `{ success, data }` — handled transparently by the Phase 0 envelope
  interceptor (D2). No pipeline change.
- `annualRentWithVat` / `currency` are backend-owned: display only, never submitted (§8.4).
- `availableFrom`: submit `YYYY-MM-DD`; parse the date part back from the returned ISO-8601 datetime.
- `floorNumber: 0` = ground floor (label "Ground" in EN/AR).
- Media URLs are absolute Cloudinary CDN URLs — render as-is, never prepend a base address.
- Photos: PNG/JPG only, ≤20 MB/file; ≥3 is a recommendation, never a hard block. Reject client-side
  (`InvalidMediaFile`) — never send invalid files.
- `mediaId` = the `_id` from the upload/listing response (`ListingMedia.id`).
- Never parse the envelope in features; never touch dio outside datasources; never decide
  permissions from `activeRole`; never re-implement `addRole`/token rotation in the listing feature.
- City/district options are not published by meta → local curated EN/AR lists (flagged gap); all envs
  use the deployed Railway base (https://shopspace-backend-production.up.railway.app).
- Every user-facing string is externalized (EN + AR) from the first line of code.
