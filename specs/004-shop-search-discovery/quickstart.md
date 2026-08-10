# Quickstart — Phase 3 (Shop Search & Discovery, Tenant Side)

Branch `004-shop-search-discovery` · Spec `spec.md` · Plan `plan.md` · Model `data-model.md`

Scenarios for running, testing, and extending the Phase 3 tenant features (`search/`,
`saved/`). Read `../001-phase0-project-foundation/quickstart.md` first (Phase 0
baseline), `../002-auth-verification-roles/quickstart.md` for the session seams, and
`../003-shop-listing-management/quickstart.md` for the browse/detail contract this phase
reuses. Contract details live in `contracts/` — this guide is the validation/run walkthrough.

## Run

```powershell
# Flutter at C:\flutter (bare C:\dart-sdk on PATH is a DIFFERENT SDK — prefer `flutter`)
flutter pub get
dart run build_runner build -d          # after adding/editing freezed / injectable / json_serializable
flutter run   # config from .env (APP_ENV, API_BASE_URL, GOOGLE_SERVER_CLIENT_ID) — see 001 quickstart; .env is a Flutter asset, re-run (not hot reload) after edits
```

Quality gate (must stay green; exits non-zero on failure):

```powershell
dart run tool/quality.dart               # flutter analyze ONLY (test suite removed 2026-08-06)
```

## Key files

| Concern | Location |
|---|---|
| Search filters / options (freezed) | `lib/features/search/data/` |
| Search + tenant detail cubits/screens | `lib/features/search/presentation/` |
| Saved datasource / repository / screen | `lib/features/saved/` |
| WhatsApp contact button (listing detail) | `lib/features/listing/presentation/widgets/whatsapp_contact_button.dart` |
| Locale-aware price/number formatters (NEW) | `lib/core/utils/formatters.dart` |
| New typed failures | `lib/core/errors/failures.dart` (Phase 3 variants) |
| Reused browse/detail contract (DO NOT duplicate) | `lib/features/listing/repository/listing_repository.dart` |
| Router (Search/Saved routes) | `lib/core/router/app_router.dart` |
| Data model | `specs/004-shop-search-discovery/data-model.md` |

## Core flows (walkthrough)

### 1. Search & filter (US1)

1. Sign in → Search tab (`/search`). `SearchCubit` fetches meta options once (categories/
   amenities; city/district from the local curated list) and loads page 1 of AVAILABLE
   shops (skeleton placeholders first, FR-006).
2. Each card shows photo, title, location, VAT-inclusive price (`annualRentWithVat`,
   display-only), and the saved heart.
3. Filter: compact/medium → bottom sheet; expanded → persistent sidebar. Edit the draft,
   "Apply" → commit → debounced (~400 ms) page-1 refetch with no list jump, no stale
   results (generation guard).
4. Scroll to the end → next page auto-loads until `meta.page >= meta.pages`, then an
   end-of-list marker.
5. No matches → localized empty state with a one-tap reset. Failure → localized error +
   retry.

### 2. Tenant detail (US2)

- Compact/medium: tap a card → `/search/:listingId` (pushed). Expanded: card selection
  renders the detail in the right pane (no navigation).
- Renders every field (FR-008): gallery in `sortOrder`, title, description, location,
  size, shop type, amenities, floors, availability, lease term, deposit, status, price.
- Saved state matches the list (D8). Deleted/unavailable shop → localized "no longer
  available" + return to results.

### 3. Contact via WhatsApp (US3) — `listing/` widget

1. On detail, tap "Contact via WhatsApp" (single in-flight flag).
2. The button launches the listing's own `whatsappLink` (`https://wa.me/<phone>`, from
   `GET /listings/:id`, guide §5.3) directly — no profile lookup.
3. A localized `?text=` prefilled message is appended when the link has none; fallback
   `sms:` → `tel:` (phone derived from the link path) if WhatsApp isn't available.
4. Listing without a `whatsappLink`, or all channels failing → localized snackbar, never a
   silent dead button (FR-009, FR-014).
5. No contact is recorded — no Inquiry entity, no confirmation screen.

### 4. Save / unsave (US5) — `saved/`

- Heart on any card (search list, home, detail) or in detail → save/unsave via the shared
  `SavedListingsRepository` (optimistic flip, revert on failure).
- Saved tab (`/saved`) → real saved screen (`GET /users/me/saved-listings`); unsaves from
  anywhere disappear on refresh (SC-006).

## Testing

Per the approved 2026-08-06 rule: new Phase 3 code ships WITHOUT new tests; existing
suites are never deleted and must stay green — fix any failures caused by refactors/API
drift. Verify manually at all three breakpoints × EN/AR (RTL) with Arabic-Indic prices
and no overflow.

## Gotchas

- Browse/detail already exist on `ListingRepository` — **reuse, never duplicate** (D2).
- Save/unsave/my-saved are FINALIZED (API guide §7); the WhatsApp deep link lives on the
  listing model (`whatsappLink`, guide §5.3) — nothing to mock (D4).
- `annualRentWithVat` is backend-owned and display-only (FR-003, §8.4); never submit/store it.
- Only AVAILABLE shops are discoverable (browse sends `status=AVAILABLE`); the app never
  renders rented/pending/expired and never re-implements visibility rules.
- `wa.me` takes the phone with its leading `+` stripped; message is URL-encoded + localized.
- Debounce + generation guard + in-flight pagination are the contract for FR-004/FR-005 —
  don't "simplify" them away.
- Hearts everywhere go through the one `SavedListingsRepository` — never per-screen save logic.
- New failures need l10n keys + `ErrorMapper` entries; every user-facing string is
  externalized (EN + AR) from the first line of code.
- Sort default "newest" assumes `createdAt:desc`; if the backend rejects it, fall back to
  no sort and flag it (D11).
