# Feature Specification: Phase 3 — Shop Search & Discovery (Tenant Side)

**Feature Branch**: `004-shop-search-discovery`

**Created**: 2026-08-09

**Status**: Draft

**Input**: User description: "create a spec for Phase 3 — Shop Search & Discovery (Tenant side) from ShopSpace_Flutter_Implementation_Plan.md and FRONTEND_PHASE2_LISTINGS_API_GUIDE.md, ask me any questions for clarifications"

## Clarifications

- **Q1 — Saved-listings scope**: Saved listings ARE in scope for Phase 3. (Resolved 2026-08-09: include.) The tenant can save and unsave shops and revisit them from a dedicated saved-shops screen, using the finalized backend save/unsave/my-saved-listings endpoints. The save/unsave capability is delivered as its own self-contained feature area — with its own data, repository, and presentation layers — rather than living inside the search/home feature, so the saved list and the search results stay independent. Any existing save/unsave endpoints living in the "home" area are relocated into this new "saved" feature area.
- **Q2 — Landlord phone for WhatsApp**: The WhatsApp deep link uses the landlord's phone. (Resolved 2026-08-09, then superseded 2026-08-09: the listing-detail response carries the landlord's full `whatsappLink` (`https://wa.me/<phone>`) directly, so the app launches it with no separate profile lookup. The earlier landlord-profile-lookup resolution (`GET /users/:id`) was **removed from scope** — no profile endpoint is needed.)
- **Q3 — Design source**: All UI and screens in this phase must come from the `shop-space-ui` Figma frames, pulled at the start of the phase, and must be typical — i.e. follow the design's established patterns and token set with no invented styles. Any missing error/empty/loading states use styles consistent with the existing design tokens and are flagged. (Resolved 2026-08-09: confirmed — Figma is the sole UI source.)

### Session 2026-08-09

- Q: Should the Search screen expose a sort control, or is newest-first the only ordering? → A: Expose a lightweight sort control (newest / price low-to-high / high-to-low) with newest-first as the default; the chosen sort applies across filter changes and the reset-filters action restores newest-first.
- Q: How should the saved-shops list treat a shop that is no longer available? → A: Keep every saved shop exactly as the backend returns it (no status field added to the contract); an unavailable shop is surfaced only at the detail step with the friendly "no longer available" message and a return to the list.
- Q: When a tenant deliberately contacts the same landlord about the same shop again, what happens? → A: Nothing is recorded — the contact is a pure OS hand-off (WhatsApp/`sms:`/`tel:`) and there is no inquiry history. The double-tap guard stops only accidental duplicates.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A tenant searches and filters shops to find a suitable space (Priority: P1)

A signed-in tenant opens the Search screen and immediately sees the newest available shops as a list of cards, each showing a photo, the shop's title, its location, and its price (the VAT-inclusive annual rent). The tenant narrows the results with filters — location (city and/or district), price range, size range, shop type, and amenities. As a filter changes, the results update quickly without a full page reload and without the list jumping. Results load progressively as the tenant scrolls, so long lists never stall. If no shop matches, a clear empty state explains that nothing matched and offers to reset the filters.

**Why this priority**: Finding and narrowing down shops is the primary reason a tenant opens the app. Nothing else in this phase (detail, contact) matters unless a tenant can reach a shortlist of relevant shops quickly, so search is the foundation everything else builds on.

**Independent Test**: Sign in, open Search, confirm an initial list of available shops appears; apply each filter individually and confirm the list narrows correctly; scroll and confirm more results load; set filters that match nothing and confirm the empty state with a reset action. A complete, standalone slice.

**Acceptance Scenarios**:

1. **Given** a signed-in tenant, **When** they open the Search screen, **Then** a list of available shops appears promptly, each card showing a photo, title, location, and the VAT-inclusive price, with loading placeholders while the list is being fetched.
2. **Given** the tenant changes a filter (location, price, size, shop type, or amenities), **When** the filter is applied, **Then** the results refresh to match the new criteria quickly, without a full reload, and rapid repeated changes settle on the latest criteria rather than firing a burst of requests.
3. **Given** a filter combination that matches no shops, **When** the results return empty, **Then** a clear, localized empty state explains that no shops matched and offers a one-tap way to clear the filters.
4. **Given** results span multiple pages, **When** the tenant scrolls to the end of the list, **Then** the next page loads automatically until no more results remain, and a clear end-of-list state is shown.
5. **Given** the results cannot be loaded (e.g. no connection), **When** the Search screen opens or a filter changes, **Then** a friendly, localized error with a retry action is shown instead of a broken or empty screen, and raw technical messages never reach the user.
6. **Given** a phone-sized screen, **When** the tenant applies filters, **Then** filters open from a bottom sheet/drawer so results keep the full screen; on a wide screen filters sit in a persistent sidebar.
7. **Given** results are shown, **When** the tenant changes the sort (newest, price low-to-high, or high-to-low), **Then** the list reorders accordingly without a full reload, defaults to newest-first, and the chosen sort applies to subsequent filter changes.

---

### User Story 2 - A tenant views a shop's full details (Priority: P1)

The tenant taps a shop card and sees the complete listing: a photo gallery, title, full description, location, size, shop type, amenities, floor details, availability date, minimum lease term, security-deposit months, the current status, and the VAT-inclusive annual rent. The detail screen also shows whether the tenant has already saved the shop. On a wide screen the detail appears beside the results list; on a phone it opens as its own screen.

**Why this priority**: Reading the full listing is the step between "this looks interesting" and "I want to contact the landlord." It is P1 because the whole phase's value depends on a tenant being able to see exactly what a shop offers before deciding to reach out.

**Independent Test**: Open a shop card and confirm every field the landlord entered is shown correctly, the photo gallery renders, the saved state is correct, and the layout matches the current screen size. A complete, standalone slice.

**Acceptance Scenarios**:

1. **Given** an available shop, **When** the tenant opens its detail screen, **Then** every field is shown — photos in order, title, description, location, size, shop type, amenities, floor details, availability date, lease term, deposit, status, and the VAT-inclusive price.
2. **Given** the tenant has already saved the shop, **When** the detail screen opens, **Then** the saved state is shown consistently with the list view.
3. **Given** a wide screen, **When** the tenant selects a shop, **Then** its detail appears beside the results list; on a phone the detail opens as a separate screen.
4. **Given** a shop was deleted or made unavailable while being viewed, **When** the detail cannot be shown, **Then** a friendly, localized message explains the shop is no longer available and returns the tenant to the results.

---

### User Story 3 - A tenant contacts the landlord via WhatsApp (Priority: P2)

On the detail screen the tenant taps "Contact via WhatsApp." The app opens WhatsApp with a message already filled in about this specific shop, addressed to the listing's own `whatsappLink` (`https://wa.me/<phone>`). If WhatsApp is not installed on the device, the app falls back to the native dialer or an SMS composer. Nothing is recorded and nothing happens in-app after launch (no confirmation screen, no inquiry history).

**Why this priority**: Contacting the landlord is the phase's conversion moment — the tenant has found a shop and now wants to act. It is P2 because it sits on top of search and detail, but it is the outcome those earlier steps exist to enable.

**Independent Test**: Open a shop's detail, tap "Contact via WhatsApp," confirm WhatsApp opens with a prefilled message about the shop (or the sms/tel fallback launches). A complete, standalone slice.

**Acceptance Scenarios**:

1. **Given** the tenant taps "Contact via WhatsApp" on a shop, **When** WhatsApp is available, **Then** WhatsApp opens with a message prefilled about that shop, built from the listing's `whatsappLink` plus a localized `?text=`.
2. **Given** WhatsApp is not installed, **When** the tenant taps "Contact via WhatsApp," **Then** the app falls back to the native dialer or an SMS composer so the contact is still possible.
3. **Given** the listing carries no `whatsappLink`, **When** the tenant taps contact, **Then** a localized snackbar explains the contact details aren't available.
4. **Given** the tenant taps contact twice, **When** both taps happen rapidly, **Then** only one contact action is processed.
5. **Given** every channel fails to open, **When** the tenant taps contact, **Then** a friendly, localized snackbar with a retry path appears (FR-014).

---

> **Removed 2026-08-09 — User Story 4 ("A tenant reviews their contact history" / My Inquiries) is out of scope.** The backend has no inquiries endpoints and no contact is recorded, so there is no history to show. The remaining stories are numbered US1–US3, US5 to keep stable references.

### User Story 5 - A tenant saves shops to revisit later (Priority: P2)

The tenant marks shops they like with a save action from the results list or the detail screen, and finds all their saved shops in one dedicated place. The saved state stays consistent across the results list, the detail screen, and the saved list, so a shop marked saved in one place is marked saved everywhere. The saved-list capability is its own self-contained feature area, separate from search, so the saved list works independently of the search screen.

**Why this priority**: Saving is a lightweight way to keep a shortlist without contacting every landlord, and the backend already supports it. It is P2 because search and detail are the core of the phase; saving is a supporting convenience.

**Independent Test**: Save a shop from the results list, open its detail and confirm the saved state, save a second shop from detail, open the saved list and confirm both appear, then unsave one and confirm it disappears everywhere. A complete, standalone slice.

**Acceptance Scenarios**:

1. **Given** an available shop in the results, **When** the tenant saves it, **Then** the shop is saved and the saved state is shown on its card and on its detail screen.
2. **Given** the tenant has saved shops, **When** they open the saved list, **Then** every saved shop appears with its key details.
3. **Given** a shop is saved, **When** the tenant unsaves it from any screen, **Then** the saved state is removed consistently across the results, detail, and saved list.
4. **Given** the saved list cannot be loaded, **When** it opens, **Then** a friendly, localized error with a retry action is shown.

---

### Edge Cases

- Rented, pending, and expired shops never appear in search results — only available shops are discoverable.
- A filter combination returns zero results — a clear empty state with a one-tap reset is shown instead of a blank screen.
- The tenant changes filters rapidly — the app settles on the latest criteria and does not fire a burst of overlapping requests or show stale results.
- The tenant scrolls to the end of a long list — the next page loads automatically; the end of the list is clearly indicated and nothing is duplicated.
- The connection drops while searching, viewing detail, or loading saved shops — a friendly, localized error with a retry action appears.
- The session expires while the tenant is searching (e.g. a 401) — the app performs exactly one silent token refresh and retries; if that fails the tenant is returned to login per the global session rule.
- A shop is deleted or made unavailable by the landlord while the tenant is viewing or saving it — a friendly message explains the shop is no longer available.
- A shop the tenant already saved becomes unavailable — it stays listed in the saved-shops list exactly as the backend returns it; only opening its detail surfaces the friendly "no longer available" message and returns the tenant to the list.
- WhatsApp is not installed — the app falls back to the native dialer or SMS composer so the contact is still possible.
- The listing has no `whatsappLink` or no channel can open — a localized snackbar surfaces instead of a silent dead button (FR-014).
- The tenant taps save, contact, or any action twice — only one action is processed; no duplicate saves or contacts.
- A shop is already saved when the tenant taps save — the action is idempotent and does not duplicate the saved entry.
- Prices and numbers shown in Arabic — amounts, sizes, dates, and filters render with correct Arabic digit and currency formatting and full RTL mirroring.
- Search, detail, and saved screens used at all three screen sizes — no overflow, no unusable controls; the two-pane (three-region) layout appears only on the widest screens.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST let a signed-in user search available shops. Only shops whose status is available MUST be shown in results; pending, rented, and expired shops MUST never appear.
- **FR-002**: The system MUST support filtering search results by at least: location (city and/or district), price range, size range, shop type, and amenities.
- **FR-003**: The system MUST show the VAT-inclusive annual rent as the tenant-facing price on result cards and detail screens, and MUST never let the app submit or store that computed figure.
- **FR-004**: The system MUST refresh search results when a filter changes without a full page reload, MUST debounce rapid filter changes so overlapping requests do not race, and MUST prevent duplicate submissions.
- **FR-005**: The system MUST load long result sets in pages as the tenant scrolls, with a clear loading state, an end-of-list state, and no duplicated items. The pagination request MUST send the backend browse endpoint's `page` (starting at 1) and `limit` (fixed at 10) query parameters exactly as the API guide defines them (guide §5.2: `page=1`, `limit=10`), and the end-of-list state MUST derive from the response `meta { page, limit, total, pages }` (`hasMore = meta.page < meta.pages`).
- **FR-006**: The system MUST show loading placeholders while the initial results are fetched so the tenant sees progress immediately.
- **FR-007**: The system MUST display each result card with at least a photo, title, location, and VAT-inclusive price, and MUST display its saved state when the user has one.
- **FR-008**: The system MUST show a full listing-detail screen with all listing fields: photo gallery in order, title, description, location, size, shop type, amenities, floor details, availability date, minimum lease term, security-deposit months, status, and the VAT-inclusive price.
- **FR-009**: The system MUST provide a "Contact via WhatsApp" action on the listing-detail screen that opens WhatsApp with a message prefilled about the specific shop, built from the listing's own `whatsappLink` (`https://wa.me/<phone>`, a localized `?text=` appended when the link has none), and MUST fall back to `sms:` → `tel:` (phone from the link path) when WhatsApp is unavailable. If the listing carries no `whatsappLink`, the action MUST surface a clear, localized snackbar instead of failing silently.
- **FR-012**: The system MUST let a tenant save and unsave a shop from the results list and the detail screen, MUST persist the saved state, and MUST keep it consistent across the results list, the detail screen, and the saved list. The capability lives in its own self-contained feature area (its own data, repository, and presentation layers), independent of the search screen.
- **FR-013**: The system MUST provide a saved-shops screen listing everything the tenant has saved with their key details, and MUST reflect unsaves consistently. Saved shops that become unavailable remain listed exactly as the backend returns them; the unavailable state is surfaced only when the tenant opens the shop's detail, which shows a friendly "no longer available" message and returns them to the list.
- **FR-014**: Every action in this phase (search, filter, load more, open detail, save/unsave, contact) MUST either succeed or end in a friendly, localized message with a clear retry path — raw technical errors MUST never reach the user — and duplicate rapid actions MUST be prevented.
- **FR-015**: All screens in this phase MUST be responsive at all three screen-size classes — Search using a two-pane (three-region) list-and-detail layout with a persistent filter sidebar on the widest class and a bottom-sheet/drawer filter plus pushed detail screens on phones — and MUST be localized in English and Arabic with correct RTL rendering, Arabic number/price formatting, and no layout overflow.
- **FR-016**: The system MUST let the tenant reorder search results via a visible sort control with three options — newest first (default), price low-to-high, and price high-to-low — MUST apply the chosen sort to subsequent filter changes without a full reload, and MUST restore newest-first when the filters are reset.

### Key Entities *(include if feature involves data)*

- **Shop listing**: The rentable shop as shown to tenants — title, shop type, size (m²), city, district, address, description, amenities, floor details, availability date, minimum lease term, annual rent, the VAT-inclusive rent (computed by the backend, read-only), security deposit in whole months, status (available), photos in order, thumbnail, and whether the current tenant has saved it. Owned by exactly one landlord.
- **Search filters**: The criteria a tenant combines to narrow results — location (city/district), price range, size range, shop type, amenities, and a sort option (newest / price asc / price desc) — together with pagination state: the request sends the backend browse endpoint's `page` (starting at 1) and a fixed `limit` of 10, and the response `meta { page, limit, total, pages }` drives `hasMore` and the end-of-list state (FR-005).
- **Saved listing**: The relationship marking that a tenant has saved a shop, persisting the saved state across the app so it reads consistently everywhere.
- **Landlord contact**: A pure OS hand-off — the tenant detail button launches the listing's own `whatsappLink` (`https://wa.me/<phone>`) with a localized prefilled message and an `sms:`/`tel:` fallback. No contact is recorded (no Inquiry entity, removed 2026-08-09).
- **Listing photo**: An image attached to a shop with a display order; the gallery and cards render them in order.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A tenant can go from opening the Search screen to seeing a loaded list of available shops within 2 seconds on a normal connection, with loading placeholders visible from the first moment.
- **SC-002**: Every filter change is reflected in the results without a full reload, and rapid changes settle on the latest criteria with no stale or racing results — 100% of filter interactions behave this way.
- **SC-003**: Only available shops ever appear in search results; pending, rented, and expired shops never appear — verified across all filter combinations.
- **SC-004**: 100% of listing-detail views render every field the landlord entered, including the photo gallery, amenities, lease terms, and the VAT-inclusive price.
- **SC-005**: Every "Contact via WhatsApp" action opens WhatsApp (or the dialer/SMS fallback) with a correctly prefilled message; a listing with no `whatsappLink` shows the localized snackbar and never a dead button.
- **SC-006**: A tenant can save a shop from any surface and see the saved state immediately reflected on the results list, the detail screen, and the saved list — with no inconsistency, and the saved-shops screen reading independently of the search screen.
- **SC-007**: All screens in this phase are verified at all three screen-size classes and in both English and Arabic (RTL), with the two-pane (three-region) Search layout on the widest class, correct Arabic number/price formatting, and no layout overflow.
- **SC-008**: No action in this phase can end in a crash or a raw technical message; every failure path ends in a friendly, localized message with a retry action.
- **SC-009**: Infinite scroll behaves like the backend pagination contract — every scroll to the end sends the next `page` request at `limit=10`, pages append with no duplicated items, and a clear end-of-list state appears once `page >= meta.pages`.

## Assumptions

- The finalized Phase 2 listings API guide (`FRONTEND_PHASE2_LISTINGS_API_GUIDE.md`) is the authoritative contract for browse, detail, and saved-listings data in this phase; it supersedes the implementation plan's earlier simplified listing shapes and "expected" search query parameters. The guide's browse endpoint already supports the filters this phase needs (city, district, category, price range, size range, amenities, pagination, sorting) and the tenant-facing price is `annualRentWithVat`.
- Search is available to any signed-in user (a landlord is also a tenant); the app's session gate applies as it does to all authenticated screens.
- The browse and detail endpoints work with or without a token, but the app always sends the signed-in user's token so saved-state flags are accurate.
- Only shops with status `AVAILABLE` are discoverable — this phase does not surface rented, pending, or expired shops in any way (consistent with the Phase 2 decision).
- The tenant contact flow reads the listing's own `whatsappLink` returned by `GET /listings/:id` (guide §5.3): the full `https://wa.me/<phone>` deep link. The app appends a localized `?text=` prefilled message when the link has none and derives the `sms:`/`tel:` fallback phone from the link path. No profile endpoint or inquiry endpoint is used (the earlier `GET /users/:id` lookup and the expected `POST /inquiries` / `GET /inquiries/mine` were removed from scope, 2026-08-09).
- Saved listings ARE in scope for this phase and are delivered as their own self-contained feature area (its own data, repository, and presentation layers), independent of the search screen; any save/unsave endpoints previously living in the "home" area are relocated there (see Clarifications Q1).
- Prices shown to tenants are always the VAT-inclusive amount computed by the backend (115% of annual rent); the app never submits or stores that figure.
- The save/unsave and my-saved-listings endpoints are finalized (per the API guide), so the saved-listings feature is built against the real contract rather than a stub.
- Filters that map to reference options (shop type/category, amenities, city/district) use the same option sources established in earlier phases — live metadata where the backend publishes it, and the local curated city/district list where it does not.
- The minimum supported tablet size for the expanded layout class remains 10"+ (established in Phase 0).
- Design for all screens in this phase (Search/Browse, Listing Detail, and Saved Shops) comes from the `shop-space-ui` Figma file and MUST be typical — screens are built from the Figma frames pulled at the start of this phase and follow the design's established patterns and tokens with no invented styles; any missing states (error/empty/loading) use styles consistent with the existing design tokens and are flagged (see Clarifications Q3).
- English and Arabic are the only required locales; additional locales later are a supported extension, not a rebuild.
