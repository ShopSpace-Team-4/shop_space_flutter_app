# Research: Shop Search & Discovery (Tenant Side) (Phase 3)

Feature `004-shop-search-discovery` · Branch `004-shop-search-discovery` · Plan `plan.md`

## Scope

Deliver tenant-side search & discovery in two feature boundaries on the Phase 0/1/2
foundations: `search/` (browse + filters + pagination + tenant detail, reusing the
finalized Phase 2 browse contract) and `saved/` (self-contained saved-listings area with
its own data/repository/presentation, per spec Q1). The tenant→landlord contact is a
self-contained `WhatsAppContactButton` in `listing/` that launches the listing's own
`whatsappLink` (finalized, guide §5.3) with a localized prefilled message and `sms:`/`tel:`
fallback — nothing is recorded (no Inquiry entity; the former `inquiries/` feature was
removed 2026-08-09). Search
is two-pane (three-region with a filter sidebar) on expanded, sheet-filters + pushed
detail on compact/medium; UI from the `shop-space-ui` Figma frames pulled at phase
start; EN/AR full RTL with Arabic-Indic price formatting.

## Resolved Decisions

### D1 — Two feature boundaries: `search/` and `saved/`

**Decision**: Phase 3 ships as two new features under `lib/features/`:
- `search/` — `data/` (SearchFilters value types) + `presentation/` (cubits,
  screens, widgets). **No `repository/`**: its data contract is the existing
  `ListingRepository` (`browse`, `getListing`, `fetchMeta`), injected per the
  constitution's cross-feature reuse rule rather than duplicated (see D2).
- `saved/` — full `data/ | repository/ | presentation/` shape (spec Q1 mandates its
  own data, repository, and presentation layers).
- The tenant→landlord contact is **not a feature**: it is a self-contained
  `WhatsAppContactButton` widget in `listing/` that consumes the listing's own
  `whatsappLink` (the former `inquiries/` feature — models, mock datasources,
  launcher, repository, cubit, confirmation/history screens — was removed
  2026-08-09; nothing is recorded).

**Rationale**:
- Spec Q1 explicitly requires saved listings as a self-contained feature area so the
  saved list works independently of search.
- Search is a read-mostly surface over the already-finalized browse/detail contract;
  giving it a second repository would duplicate `ListingRepository` methods, which
  constitution §2 forbids ("never by duplicating logic").
- The contact button needs no data/repository layer because `whatsappLink` ships on
  the finalized listing payload — mirroring the constitution's "repository method IS
  the use case" by keeping the launch inline in the widget.

**Alternatives rejected**:
- A single `marketplace/` feature covering search+saved (spec Q1 demands separate
  self-contained areas; one folder would mix two independent contracts).
- A second browse repository in `search/` that delegates to `ListingRepository`
  (pure indirection — violates "repository method IS the use case" by hiding the
  real contract).
- A full `inquiries/` feature (data/repository/cubit/confirmation/history) — removed
  2026-08-09: no record, no confirmation, no history, no expected backend contract.

### D2 — Search reuses the finalized browse contract; no mock needed

**Decision**: `SearchCubit` and the tenant `ListingDetailCubit` inject the existing
`ListingRepository` and call `browse(BrowseQuery)` / `getListing(id)` /
`fetchMeta()`. `BrowseQuery`, `BrowsePage`/`BrowseMeta`, `BrowseListing`, and
`ShopListing` (all freezed, Phase 2) are reused unchanged. Search's user-facing
filters are captured by a new `SearchFilters` value type (D12) that converts 1:1 into
`BrowseQuery.toQueryParameters()`. Because browse is finalized and the app always
sends the signed-in token (spec Assumptions), `isSaved` flags are authoritative from
the response.

**Rationale**:
- `docs/FRONTEND_PHASE2_LISTINGS_API_GUIDE.md` §5.2 already supports every filter this
  phase needs (city, district, category, priceMin/Max, areaMin/Max, amenities,
  page/limit, sort) and the browse model is already wired end-to-end (home screen uses
  it).
- The standing "mock-first" convention applies only to **unfinalized** feature APIs;
  browse/detail are finalized, so no stub is required.
- `GET /listings/meta` (via `ListingRepository.fetchMeta`) supplies category/amenity
  filter options and is already implemented.

**Alternatives rejected**:
- Building search against a mock `SearchDataSource` (unnecessary — the real contract
  exists and is live; a stub would only delay against the Railway backend).
- Duplicating browse methods onto a `SearchRepository` (see D1).

### D3 — Dedicated `SavedListing` model for the slim §7.3 payload

**Decision**: `saved/` defines its own freezed `SavedListing` mirroring the exact
`GET /users/me/saved-listings` item (API guide §7.3): `id, title, location` (a single
combined `"New Cairo, Cairo"` string), `annualRent, annualRentWithVat, currency,
areaSqm, thumbnailUrl, isSaved`. It is **not** a reuse of `BrowseListing`, which has
separate `city`/`district` and lacks the combined location string.

**Rationale**:
- The saved payload genuinely differs from both `BrowseListing` and `ShopListing`
  (combined `location`, no category/status/landlordId). Forcing reuse would require
  tolerant/absent-field mapping, which the no-DTO-mapping rule discourages.
- The combined `location` string renders directly in saved cards and in the saved-list
  state (FR-013 "key details").

**Alternatives rejected**:
- Reusing `BrowseListing` with an optional `location` field bolted on (pollutes the
  browse model with a shape it never returns; leaves `city`/`district` null).
- Client-side re-joining `city`+`district` from saved ids via `getListing` per row
  (N+1 fetches for a screen the backend already serves).

### D4 — REMOVED 2026-08-09: inquiries + landlord profile were expected contracts

**Removed**: The `inquiries/` feature (with a mock-first `InquiriesDataSource` for the
expected `GET /users/:id`, `POST /inquiries`, `GET /inquiries/mine`) is **out of scope**.
The tenant contact flow now consumes the **finalized** `whatsappLink` field on
`GET /listings/:id` (guide §5.3) directly from `ShopListing` — no profile lookup, no
inquiry record, no mock datasource, nothing to swap later. See D6.

### D5 — REMOVED 2026-08-09: launch-before-record protocol

**Removed**: The launch-before-record ordering (D5) existed only to keep the WhatsApp
hand-off independent of an inquiry-record call. Since no inquiry is recorded anymore
(2026-08-09), there is nothing to order — the button's only actions are
launch + fallback + snackbar. Retry concerns now reduce to: a missing `whatsappLink` or
an all-channels-failed launch shows a localized snackbar with the button re-tappable
(FR-009, FR-014).

### D6 — WhatsApp deep link from `listing.whatsappLink` + `sms:`/`tel:` fallback

**Decision**: The contact button (`listing/presentation/widgets/whatsapp_contact_button.dart`)
wraps `url_launcher` and is fully self-contained (no cubit, no DI):
- Primary: launch the listing's own `whatsappLink` as-is
  (`https://wa.me/<phone>`, already phone-without-`+`, guide §5.3); append the localized
  prefilled message as `?text=` ONLY when the link has none.
- Fallback chain when the primary can't launch (`canLaunchUrl` false): `sms:` with the
  same prefilled body → `tel:`, phone derived from the wa.me path.
- If the listing carries no `whatsappLink` or every channel fails, the button shows a
  localized snackbar (`whatsappContactUnavailable` / `errorContactLaunchFailed`) —
  never a silent dead button (FR-009, FR-014). A single in-flight flag makes rapid
  double-taps produce exactly one launch.
- The prefilled message is localized (EN/AR) and URL-encoded by the `Uri` builder,
  e.g. "Hello, I'm interested in the shop '<title>' in <city>, <district>."

**Rationale**:
- Constitution §6: landlord–tenant contact is a WhatsApp deep link only, opened via
  `url_launcher` with dialer/SMS fallback. The listing model is the authoritative
  source — no landlord-profile endpoint exists (removed 2026-08-09).

**Alternatives rejected**:
- `https://api.whatsapp.com/send?phone=...` (wa.me is the documented, shorter form).
- Silently failing when no link/channel works (FR-009 forbids silent failure).
- The former profile-lookup + record flow (removed 2026-08-09).

### D7 — Debounce + generation guard + guarded pagination in `SearchCubit`

**Decision**: `SearchCubit` owns the request discipline:
- **Debounce**: filter changes start a `dart:async` `Timer` (~400 ms); the previous
  timer is cancelled on every change so rapid adjustments fire one request for the
  latest criteria (FR-004, SC-002).
- **Generation guard**: each fired request carries a monotonically increasing
  generation; a response is applied only if its generation is still the latest — stale
  responses are dropped, never rendered (no racing results).
- **Pagination**: a `page`/`hasMore`/`isLoadingMore` in state; a scroll-notifier in the
  list triggers `loadMore` near the end; an in-flight flag prevents duplicate `loadMore`
  calls; `hasMore` derives from `meta.page < meta.pages` (no duplicated items); the
  end-of-list state renders when `page >= pages` (FR-005).
- **Initial load**: a skeleton/placeholder state renders from the first frame so the
  <2s target feels instant (FR-006, SC-001).

**Rationale**:
- FR-004/SC-002 are explicit about debounce, no-race, and settle-on-latest; a plain
  future-per-tap would violate them.
- `dart:async` `Timer` needs no new package (keeps the locked stack clean).

**Alternatives rejected**:
- `rxdart` `debounceTime`/`switchMap` operators (new dependency; the same behavior is
  ~15 lines with `Timer` + a generation counter).
- Optimistic filter application without a generation guard (races under rapid input —
  exactly what SC-002 forbids).

### D8 — Saved-state consistency via the one shared `SavedListingsRepository`

**Decision**: `SavedListingsRepository` (interface) is injected into every surface that
shows a heart or saved state: `SearchCubit`, tenant `ListingDetailCubit`, the home
card heart, and `SavedListingsCubit`. Tapping the heart calls
`SavedListingsRepository.save(id)` / `.unsave(id)` (finalized, idempotent endpoints);
the initiating surface updates its local item's `isSaved` immediately (optimistic),
and on failure reverts with a localized message + retry. Because every surface mutates
through the same repository and the backend is authoritative, `isSaved` stays
consistent across results, detail, and the saved list (FR-012/FR-013, SC-006). The
Phase 2 home hearts (currently visual-only, gap-log) become interactive through this
same repository; the spec's Q1 "relocation" of any home-area save endpoints is
confirmed forward-only — nothing in `home/` calls save/unsave today (verified: the
heart renders `isSaved` only).

**Rationale**:
- Constitution §2: cross-feature reuse = inject the same repository into every Cubit —
  never duplicate save logic per screen.
- The save/unsave/my-saved contract is finalized (API guide §7), so this is built
  against the real endpoints, not a stub (spec Assumptions).

**Alternatives rejected**:
- Each surface calling a static/global saved-ids registry (introduces a new global
  pattern not in the locked set; server stays authoritative anyway).
- Duplicating save calls in each cubit (constitution §2 forbids it; drift risk).

### D9 — Locale-aware Arabic price/number formatting in `core/utils`

**Decision**: A new `core/utils/formatters.dart` provides the Phase 3 number/price
surface:
- `formatPrice(double value, AppLocalizations l10n, {bool compact})` renders EGP
  prices with locale-aware digits: Arabic-Indic numerals (`٠١٢٣٤٥٦٧٨٩`) in AR, Latin
  digits in EN; a localized compact form (e.g. AR `١٢٠ ألف` vs EN `120K`) replaces the
  Latin-only `K` token flagged in gap-log #7.
- `formatArea`, `formatDate`, `formatDeposit`-style helpers cover the remaining
  numeric fields (size m², availability date, security-deposit months) with the same
  digit/date-locale rule (edge case "amounts, sizes, dates, and filters render with
  correct Arabic digit and currency formatting").
- Backed by `intl` `NumberFormat` with the active locale (already locked).

**Rationale**:
- The gap-log explicitly defers Arabic-Indic + price formatting to Phase 3; the spec
  makes it an edge case and SC-007.
- `core/utils` is the established cross-cutting home for formatters (the folder exists;
  adding a file there adds no new convention).

**Alternatives rejected**:
- Per-feature formatting helpers (three copies of the same locale logic — drift risk).
- Relying on the raw `double.toString()` (ignores Arabic digits entirely).

### D10 — Responsive Search layout: three-region on expanded, sheet + push on compact/medium

**Decision**: Material 3 size classes (established Phase 0) pick structure; screenutil
only scales values. On **expanded** (≥840dp): a persistent **filter sidebar** + results
list + tenant detail pane arranged as a three-region row; selecting a card updates the
detail pane in place (no navigation). On **compact/medium** (<840dp): filters open from
a **bottom sheet/drawer**, and tapping a card pushes `/search/:listingId` as a full
screen. The filter sidebar and the bottom sheet share the same filter widget tree and
`SearchFilters` draft/apply state (FR-015, US1 scenario 6).

**Rationale**:
- Matches the implementation plan's Phase 3 adaptive behavior and the constitution's
  split (breakpoints pick structure, screenutil scales values).
- One filter surface reused in two containers keeps filter logic single-sourced.

**Alternatives rejected**:
- A filter sidebar on medium (spec ties the sidebar to the widest class only).
- A pushed detail even on expanded (the spec's two-pane requirement).

### D11 — Sort default "newest first" is an assumption; backend flagged

**Decision**: The initial results sort as "newest available shops" (spec US1). The
browse contract documents `sort=annualRent:asc` as an example but not a creation-date
sort; the app therefore sends `sort=createdAt:desc` when a "newest" default is
requested, and falls back to the server's default ordering (no sort param) if the
backend rejects the expression — surfaced as a single local assumption flag for the
backend team. The sort filter is exposed as a small selectable set
(newest / price asc / price desc) mapped to documented/best-effort sort expressions.

**Rationale**:
- The guide's sort param format (`field:direction`) is documented; only the exact
  field name for creation date is unconfirmed.
- Never block the phase on an unconfirmed sort key — degrade to server default.

**Alternatives rejected**:
- Hardcoding `createdAt:desc` with no fallback (a backend 400 would fail the initial
  load — the worst moment to error).
- No sort at all (contradicts US1's "newest" wording).

### D12 — Filters: single-select city/district/category, multi-select amenities

**Decision**: `SearchFilters` (freezed, in `search/data/models/`) holds
`city, district, category` (single-select `String?`), `priceMin, priceMax, areaMin,
areaMax` (`double?`), `amenities` (`List<String>`, multi-select), `sort`
(`String?`), plus page/limit; `SearchFilterOptions` bundles the option sources:
categories + amenities from `ListingRepository.fetchMeta()` (retryable, never
hardcoded — spec Assumptions), city/district from the existing local curated
`LocalityOptions` (flagged gap: meta does not publish them, carried from Phase 2).
`SearchFilterBuilder` converts `SearchFilters` → `BrowseQuery` 1:1 (contract
`search-browse.md`). The filter sheet/sidebar edits a **draft**; "Apply" commits it to
the cubit, which resets pagination and debounce-fetches page 1.

**Rationale**:
- 1:1 mapping to the browse query params avoids ambiguity (multi-select city is not a
  documented param shape — keep city/district/category single, amenities comma-joined
  multi, exactly as the guide documents).
- Reusing `fetchMeta` + `LocalityOptions` honors the "no invented option sources" rule
  and carries the Phase 2 gap forward for the backend to close.

**Alternatives rejected**:
- Multi-select city/district (undocumented param shape; would need `city=a&city=b`).
- Hardcoded category/amenity lists (spec + constitution forbid invented sources).

## Open items (non-blocking)

> **Backend hand-off flags (recorded 2026-08-09, T063)** — one consolidated note for the
> backend team. Three open assumptions, all non-blocking on the app side:
> 1. **Sort key for "newest" (D11)**: the app sends `sort=createdAt:desc` for the
>    newest-first default and, on the first backend rejection of that expression,
>    retries once without a sort and degrades to the server default. The backend
>    should confirm `createdAt` (or the correct field) is sortable via
>    `sort=field:direction`, or the default order never sorts newest-first.
> 2. **City/district filter options (D12)**: `GET /listings/meta` publishes categories
>    and amenities but not cities/districts; the app filters city/district from the
>    local curated `LocalityOptions` (carried from Phase 2). The backend should publish
>    city/district options in `GET /listings/meta` so the local list can be dropped.
> 3. **Figma scaffolds expected empty (Q3)**: the `shop-space-ui` frames for
>    Search/Browse, tenant Listing Detail, and Saved Shops were empty scaffolds at
>    pull time (2026-08-09); Phase 3 UI was built from the existing `core/theme` token
>    set with no invented values. No backend dependency — design-only flag.
>
> The contact flow needs **NO backend flag**: it consumes the finalized
> `whatsappLink` field on `GET /listings/:id` (guide §5.3) and the `sms:`/`tel:`
> fallback; the earlier `GET /users/:id` profile and `POST /inquiries` /
> `GET /inquiries/mine` dependencies were removed from scope (2026-08-09).

- **Sort key for "newest"**: backend should confirm `createdAt` (or the correct field)
  is sortable via `sort=field:direction` (D11).
- **City/district filter options**: backend should publish them in `GET /listings/meta`
  so the local curated `LocalityOptions` can be dropped (carried from Phase 2 gap-log).
- **Browse payload gaps** (carried from Phase 2 gap-log #6): browse items have no
  street/address or status — cards therefore show title/location/price only, which the
  spec's card fields already satisfy; the tenant detail uses `GET /listings/:id` (full
  `ShopListing`, now including `whatsappLink`) so nothing is lost.
- **Figma fidelity**: `shop-space-ui` frames for Search/Browse, tenant Listing Detail,
  and Saved Shops are pulled at the START of
  implementation (spec Q3). Based on the Phase 2 experience (all four pulls found only
  the shared shell — gap-log #2), the frames are **expected to be empty scaffolds**;
  the plan is to build from the existing `core/theme` token set with no invented
  values and flag any invented fill copy (e.g. empty-state strings) per the gap protocol.
  Contact confirmation and My Inquiries have **no frames and are removed from scope**
  (2026-08-09) — the contact flow is a button + snackbar on the existing detail pane.

## Figma frame index (Phase 3) — recorded during the first implementation pull (T001, 2026-08-09)

File: **`shop space ui`** · file_key **`pvU6vSwQkWqwT27HVS4Jcp`** · accessed via Composio
Figma MCP (account `figma_crum-wecht`, ACTIVE). Frame tree: CANVAS `0:1` "Design System"
→ SECTION `104:262` "Mobile App" → screen FRAMEs below. Pulled via
`FIGMA_DISCOVER_FIGMA_RESOURCES` (depth 2) + `FIGMA_GET_FILE_JSON` on `104:262` and the
screen nodes.

| Phase 3 screen | Node ID | Pull result (2026-08-09) |
|---|---|---|
| Search/Browse (tenant) | `97:4660` "Search" | Shell + header `97:5214`: back btn `97:5216`, search field `97:5219` (r999 pill, placeholder **"City, type, district…"**, fill `#f1f5f9`), filter slider `257:6346`; filter-chip row `97:5228` (6 r999 pills: `97:5229`–`97:5240`); results `97:5272` with 6 cards `257:3969`/`257:4009`/`257:4028`/`257:4066`/`257:4085`/`257:4104`. **Card content is NOT duplicated in this frame** — the full card lives in `257:6070` "Spaces" (same `343×83.5`, r14) — see next row. |
| Browse card anatomy (canonical) | `257:6070` "Spaces" (frame) + card `257:6127` | **Full card content confirmed**: image `76×82` (r~?, `#f1f5f9` backdrop); title **"Prime Corner Unit"** (`#0f172a`) + heart btn `257:6135` top-right; location **"King Fahd Road, Al Olaya"** (`#94a3b8`); price **"85K LE/yr"** (`#2563eb`, compact); status badge **"Available"** (`#16a34a` text on `#f0fdf4`, r9999 pill, dot+text). Frame header: title "Spaces" + filter slider; chip row: **All (selected, `#2563eb`), Retail, Office, F&B, Boutique, Boutique**. Bottom nav `257:6071` (Home/Search/Saved/Profile). |
| Tenant Listing Detail | `97:5547` "Property" | Shell + body container `97:5996` (→ `97:5997`, 730h blank container). Nav bar `97:5548`. **Empty scaffold — no gallery/text/label content.** |
| Saved Shops | `242:2494` "Saved" | Shell + body container `242:2560` (blank). Nav bar `242:2512`. **Empty scaffold — no card content.** |

Contact confirmation and My Inquiries (former US4) were pulled-looking, found to have
**no frame**, and are **removed from scope** (2026-08-09): the contact flow is a
`WhatsAppContactButton` + snackbars on the existing tenant detail pane — no dedicated
screens.

Card unit conventions observed: 16px screen padding (`layout13`), card gap 12, price uses
compact `K` + `/yr` — note the Phase 3 contract `arabic-number-formatting.md` renders
full `EGP 690,000` / `٦٩٠٬٠٠٠ ج.م` (approved D9 overrides the Figma "LE/yr" shorthand;
home card already uses `{amount}/yr` via `homeRentPerYear`). Status badge fills `#f0fdf4`
/ text `#16a34a` (already tokenized? check `core/theme` when building the card).

Missing error/empty/loading frames: **none present for any Phase 3 screen** — build from
existing `core/theme` tokens and flag (Q3). Related shells reused from Phase 2: Home
`95:4028`, Property `97:5547` (shared shell), search/saved tab shells. `Section 1`
(`92:404`) contains only status-bar/notch components (no screens).
