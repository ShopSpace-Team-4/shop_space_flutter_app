# Gap Log: Shop Listing Management (Landlord Side)

Feature `003-shop-listing-management` · Phase 7 polish (T068) · Branch `003-shop-listing-management`

Consolidated log of every flagged gap per the Phase 0 gap protocol, across all Phase 2 pulls and the
Phase 7 audit. Each entry records the finding, the action taken, and its disposition.

## 1. Backend gap — `GET /listings/meta` does not publish city/district options

- **Finding**: The metadata endpoint publishes only categories, amenities, and statuses
  (`contracts/listings-api.md`, `data-model.md` §1.5). FR-005 requires city and district to be chosen
  from options.
- **Action taken**: Local curated EN/AR lists in `lib/features/listing/data/locality_options.dart`,
  rendered via `AppLocalizations` (full EN/AR parity). Not hardcoded prose — a curated option dataset.
- **Disposition**: **Flag to backend team** — ask them to publish city/district options in `meta` so
  `locality_options.dart` can be dropped. (research.md Open items, spec Assumptions.)

## 2. Figma gap — no design frames exist for the listing screens (all four pulls)

- **Finding**: Pulls T023 (My Listings list/detail), T034 (create form + become-landlord sheet),
  T049 (edit state), and T057 (delete confirmation + lifecycle) all confirmed the `shop-space-ui`
  frames are **empty scaffolds** — only the shared app shell (status bar, bottom-nav, empty `#F8FAFC`
  content containers) exists. **No list card, status badge, status picker, detail pane, 4-step form,
  step indicator, photo grid, review step, become-landlord sheet, or delete dialog** exists anywhere
  in the file. Frames pulled: `257:4378`, `257:4407`, `257:4408`, `242:1713`, `242:1811`, `242:1858`,
  `242:1887`, `242:2255`, `257:5164`, `257:5196`, `257:5197`.
- **Tokens extracted (all already in `lib/core/theme/`)**: active nav `#2563EB` = `AppColors.primary`;
  inactive `#94A3B8` = `AppColors.textTertiary`; content `#F8FAFC` = `AppColors.background`; shell
  `#FFFFFF` = `AppColors.surface`; nav stroke `#E2E8F0` = `AppColors.outline`; nav labels Inter 10px
  (matches `AppTypography.caption` scale).
- **Action taken (user decision 2026-08-08: "build from existing tokens")**: every listing screen,
  widget, sheet, dialog, and state (loading/error/empty/upload) is built from the existing
  `core/theme` token set with **no invented values**. The one approved exception is the photo-reorder
  UX using the user-approved `flutter_reorderable_grid_view` package (v5.7.0, research.md T049) over
  existing tile styling.
- **Disposition**: **Flag to design** — the listing surfaces need real frames before visual fidelity
  can be signed off. Renders could not be visually verified (model has no image input); JSON token
  extraction used instead.

## 3. Verification gap — manual smoke at 3 breakpoints × EN/AR pending

- **Finding**: T033/T048/T056/T063 and now T064/T068 require manual smoke of the landlord journey
  (become → create → publish → my listings → edit → status → delete) at compact/medium/expanded ×
  EN/AR. This environment has no device/emulator and no image input.
- **Action taken**: Completed code-level verification instead: breakpoint structure audit (T064),
  RTL/localization audit with full 216-key EN/AR ARB parity (T065), architecture violations check
  (T066), and the clean final gate `flutter analyze` (T067).
- **Disposition**: **Pending manual verification** — to be run by the team on devices/emulators at
  all three breakpoints × EN/AR before release sign-off.

## 4. Localization note — non-translatable literal tokens

- **Finding**: The only literal user-visible strings in `lib/features/listing/` are the currency code
  `EGP` (`listing_form_step_price.dart` VAT preview + currency tile, `listing_form_step_review.dart`
  rent + VAT rows) and the SI unit `m²` (`listing_card.dart`, `listing_detail_pane.dart`,
  `listing_form_step_review.dart`).
- **Action taken**: None — accepted as language-neutral ISO currency code and SI unit (T065
  clarification, 2026-08-08). The plan mandates fixed read-only EGP; both tokens are identical across
  EN/AR.
- **Disposition**: Closed (documented; not a defect).

## 5. Architecture audit — no violations found (T066)

- **Finding**: Full scan of `lib/features/listing/` (T066).
  - dio import present **only** in `data/listing_datasource.dart`; repository/presentation never see
    dio (`UploadProgress` typedef decouples the callback shape).
  - Cubits import only the `ListingRepository` interface (get_it-injected) — no datasource, no impl,
    no dio.
  - Envelope parsing: none — the meta `{ success, data }` exception is unwrapped by the Phase 0
    `EnvelopeInterceptor` (D2, zero pipeline change).
  - Raw exceptions to the UI: none — every Cubit method catches typed `Failure` and falls back to a
    `ServerFailure` for unknown errors; datasource converts `DioException` → `error.failure`.
  - Duplicate-submission guards (FR-014): `isSubmitting`/`isLoading` on `loadList`, `loadDetail`
    guards, `changeStatus`, `deleteListing`, `submitCreate`, `submitEdit`, `becomeLandlord`,
    `fetchMeta`; `_picking` in the photos step.
  - `annualRentWithVat`/`currency`: `annualRentWithVat` never appears in any request model;
    `currency: "EGP"` is sent only in the create body (plan-mandated) and excluded from update
    (`@JsonKey(includeIfNull: false)`, never set).
  - `roles[]` gating (FR-013): `my_listings_screen._openCreateFlow` reads
    `session.roles.contains('landlord')`; `activeRole` is touched only for the non-blocking dashboard
    switch in `become_landlord_cubit`.
  - `setState`: only `_picking` (UI in-flight flag) in `listing_form_step_photos.dart` — transient UI
    state, **no business logic** in `setState`.
- **Disposition**: Closed — compliant with constitution §1/§2/§3/§5/§6 and plan D1–D8.

## 6. Home screen (Figma `95:4028`) — inferred copy + Phase-3 flags

- **Finding**: The Home frame (`375×1000`, file `pvU6vSwQkWqwT27HVS4Jcp`) contains a real
  layout scaffold (hero gradient, advisor promo card, category chips, recommended/nearby card
  frames) but **all text/copy and card internals are empty** in the Figma JSON. Section headings,
  greeting, search hint, advisor copy, and the empty-state strings were inferred and localized
  (EN/AR) per the gap protocol — no invented values, only sensible fill copy.
- **Action taken (user plan 2026-08-08)**: built the Home screen structure exactly (gradients,
  radii, spacing, card frames) with the existing `core/theme` tokens plus two new design-sourced
  tokens (`heroGradientStart #0F172A`, `heroGradientEnd #3A1E8B`, `promoGradientStart #3A1E8B`,
  `promoGradientEnd #4F8EE6`). Nearby card radius in Figma is 14; the nearest token is
  `AppRadius.large` (16) — used deliberately instead of inventing a 14 token.
- **Backend wiring**: new `BrowseListing` / `BrowsePage` / `BrowseQuery` models, `browse()` on
  `ListingDataSource`/`ListingRepository`, `HomeCubit` (parallel `fetchMeta` + two `browse` calls +
  best-effort profile).
- **Flags carried to Phase 3**:
  - `GET /listings` returns English enum categories; chips render them as-is (localized chip labels).
  - Card tap opens the landlord-oriented `ListingDetailScreen` (edit/delete/status) — a
    tenant-facing detail screen is Phase 3 (user-approved placeholder).
  - `isSaved` hearts, save/unsave, and VAT/number locale formatting are deferred (data already
    present on `BrowseListing`).
- **Disposition**: **Pending manual verification** — no device/emulator in this environment;
  breakpoint (compact/medium/expanded) × EN/AR (RTL) smoke to be run by the team, matching gap-log #3.

## 7. Home card polish (Figma `95:4028`) — three carried gaps

- **Finding**: Matching the Home cards to the Figma spec (2026-08-09) surfaced three data/contract
  limits in `GET /listings` (browse payload).
  - **No status / street address in the browse payload**: the browse listing carries only
    `city`/`district` (no street or full address), so the card location line renders `district`
    (Figma shows a street/area line). No status field exists for the card to show either.
  - **Compact `K` is not Arabic-number-localized**: the compact price token (`120000 → 120K`)
    is a fixed Latin `K`; it is not localized to Arabic-Indic numerals (Phase 3 number/locale
    formatting work, per gap-log #6).
  - **Save heart is visual-only**: the card heart reflects `isSaved` but is non-interactive until
    Phase 3 (save/unsave wiring).
- **Action taken**: card reworked per the Figma spec — inactive category chips white
  fill/outline/muted 12sp, rail cards 133-wide with 120-tall image, nearby cards 76×68 flush
  thumbnail r14 with right-aligned area, "Spaces" heading rename (EN/AR), compact rent
  (`homeRentPerYear` → `120K EGP/yr`; Figma shows `LE` — we keep the API `currency` value,
  flagged as a noted gap), inter-section gaps 8.h. Three gaps flagged above for Phase 3.
- **Disposition**: **Flag to backend** (street/address + status on browse) and **carried to
  Phase 3** (`K`/number locale, save heart interactivity).
