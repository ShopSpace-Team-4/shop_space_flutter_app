# Feature Specification: Phase 2 — Shop Listing Management (Landlord Side)

**Feature Branch**: `003-shop-listing-management`

**Created**: 2026-08-07

**Status**: Draft

**Input**: User description: "create a spec for Phase 2 — Shop Listing Management (Landlord side) from ShopSpace_Flutter_Implementation_Plan.md and FRONTEND_PHASE2_LISTINGS_API_GUIDE.md, and ask me for any clarifications"

## Clarifications

- **Q1 — Status model**: New listings are created as PENDING and are not visible in the marketplace until explicitly published to AVAILABLE. There is no separate draft state. (Resolved 2026-08-07: adopt the finalized API's four statuses as-is.)
- **Q2 — Marketplace visibility**: Only AVAILABLE listings are offered to tenants, but RENTED listings remain visible in the marketplace carrying a "Rented" tag; PENDING and EXPIRED listings are not shown at all. (Resolved 2026-08-07: keep the Rented badge.)
- **Q3 — Minimum photos**: The app recommends at least 3 photos but enforces no minimum; the backend accepts any count. (Resolved 2026-08-07: guidance only, no hard rule.)

### Session 2026-08-07

- Q: In the price and lease terms step, how should the landlord choose or enter the listing's currency? → A: Currency is a fixed, read-only EGP value in the price step; the `currency` field stays on the listing model for forward compatibility.
- Q: When does the app upload the photos collected in the create flow, given the media API requires the listing to exist first? → A: Single Submit creates the listing first, then auto-uploads all collected photos as part of the same action; a failed upload leaves a pending listing with a clear message and a retry path via edit.
- Q: When should photo changes (add, remove, reorder) during the edit flow be persisted? → A: All photo changes are buffered locally and committed together with the listing update when the landlord saves (all-or-nothing per Save).

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A tenant becomes a landlord and publishes their first listing (Priority: P1)

A tenant who wants to rent out a shop taps "List a shop" in the app. Because they only hold the tenant role, the app shows a "Become a Landlord" confirmation sheet explaining what the landlord role grants. When the tenant confirms, the account gains the landlord role and the user is taken straight into the create-listing flow — no re-login and no interruption. The create flow is a guided, multi-step form: first the shop's details (title, category, size, location, description, amenities, floors), then its photos, then price and lease terms (rent, currency, deposit, lease term, availability date), then a final review. The review shows the annual rent the landlord entered alongside the VAT-inclusive amount the tenant would see. On submission the listing is created in a "pending" state (not visible to tenants in the marketplace). The landlord can then publish it explicitly to make it available.

**Why this priority**: Creating and publishing a listing is the core value a landlord gets from the product. The role-upgrade step is the entry gate to all listing management, so this journey must work end to end before anything else in the phase.

**Independent Test**: From a brand-new tenant account, tap "List a shop", confirm the landlord upgrade, complete all four steps of the create flow with valid data, submit, and confirm the listing appears in My Listings as pending; then publish it and confirm it becomes available. This is a complete, standalone slice.

**Acceptance Scenarios**:

1. **Given** a signed-in tenant whose account does not include the landlord role, **When** they tap "List a shop", **Then** a "Become a Landlord" confirmation sheet explains the role change and asks for confirmation.
2. **Given** the tenant confirms the upgrade, **When** the role is added, **Then** the account holds the landlord role, the stored credentials are refreshed so the new role works immediately, and the user is taken directly into the create-listing flow without logging in again.
3. **Given** a landlord completes the create-listing form with valid data, **When** they submit, **Then** the listing is created and appears in My Listings in the pending state, and a clear confirmation tells the user the listing is not yet public.
4. **Given** a pending listing, **When** the landlord publishes it, **Then** it becomes available and the status change is reflected in My Listings.
5. **Given** the landlord upgrade fails (e.g. no connection), **When** the user confirms, **Then** no role is added, a friendly, localized error with a retry path is shown, and the user is not taken into the create flow.

---

### User Story 2 - A landlord views and manages all their listings (Priority: P1)

A landlord opens "My Listings" and sees every listing they own, each showing its photo, title, key details, and current status. The list is always up to date with the latest create, edit, and status changes. On a wide screen the list sits next to a preview of the selected listing; on a phone the preview opens as its own screen.

**Why this priority**: My Listings is the landlord's home base for the whole phase — every other action (edit, status change, delete) starts here, and it is the only place the landlord sees the outcome of everything they do.

**Independent Test**: Create two listings with different statuses, open My Listings, and confirm both appear with the correct photos, details, and status labels; make a status change and confirm the list refreshes. A complete, standalone slice.

**Acceptance Scenarios**:

1. **Given** a landlord with one or more listings, **When** they open My Listings, **Then** every listing they own is shown with its photo, title, key details, and current status.
2. **Given** a listing is created, edited, or has its status changed, **When** the landlord returns to or refreshes My Listings, **Then** the change is reflected.
3. **Given** a wide screen, **When** the landlord selects a listing, **Then** its details appear next to the list; on a phone the details open as a separate screen.
4. **Given** the listings fail to load (e.g. no connection), **When** My Listings opens, **Then** a friendly error with a retry action is shown instead of a broken or empty screen.

---

### User Story 3 - A landlord edits an existing listing (Priority: P2)

A landlord opens one of their listings from My Listings and edits it. The same multi-step form is prefilled with the listing's current data. The landlord can change any detail (title, category, location, size, description, amenities, floors, price, lease terms, availability) and update its photos — adding new ones, removing existing ones, and arranging the order in which they appear. Saving the changes keeps the listing's current status and reflects the updates in My Listings.

**Why this priority**: Editing keeps existing listings accurate — a landlord must be able to correct a mistake or refresh details as the shop's situation changes. It is P2 because creating and viewing listings come first, but edit is expected by any landlord who keeps listings current.

**Independent Test**: Edit an existing listing's price and title, add one photo, remove one photo, reorder the remaining photos, save, and confirm My Listings shows the updated data and photos. A complete, standalone slice.

**Acceptance Scenarios**:

1. **Given** a landlord opens one of their listings for editing, **When** the edit form opens, **Then** every field is prefilled with the listing's current values and all current photos are shown in order.
2. **Given** the landlord changes one or more fields, **When** they save, **Then** the listing's details are updated, its status is unchanged, and My Listings reflects the change.
3. **Given** the landlord adds, removes, or reorders photos, **When** they save, **Then** the photo set and order are persisted.
4. **Given** the landlord cannot edit a listing they do not own, **When** they attempt to save, **Then** a friendly, localized error explains the listing cannot be modified.
5. **Given** a listing was deleted elsewhere while being edited, **When** the landlord saves, **Then** a friendly message explains the listing no longer exists and the user is returned to My Listings.

---

### User Story 4 - A landlord manages a listing's lifecycle and can remove it (Priority: P2)

A landlord changes what happens to a listing over its life. They can publish a pending listing to make it available to tenants, mark an available listing as rented once a lease is signed, mark a listing as expired when it can no longer be offered, and delete a listing entirely. Rented listings stay visible to tenants but tagged "Rented" rather than offered as available; expired listings no longer show in the marketplace. Deleting is protected by a confirmation step because it is permanent.

**Why this priority**: Lifecycle control is the difference between a listing that stays stale and one that reflects reality. Status management is how a landlord keeps the marketplace honest and manages their commitments; deletion is the final cleanup action. It is P2 because it sits on top of create and view.

**Independent Test**: Publish a pending listing, confirm it becomes available; mark an available listing as rented and confirm the change; mark a listing as expired and confirm; delete a listing after confirmation and confirm it disappears from My Listings. A complete, standalone slice.

**Acceptance Scenarios**:

1. **Given** a pending listing, **When** the landlord publishes it, **Then** the status changes to available.
2. **Given** an available listing, **When** the landlord marks it as rented, **Then** the status changes to rented and the listing remains visible in the marketplace carrying a "Rented" tag rather than being offered as available.
3. **Given** an available or pending listing, **When** the landlord marks it as expired, **Then** the status changes to expired and the listing no longer appears as available in the marketplace.
4. **Given** a landlord initiates deletion of a listing, **When** they confirm the deletion, **Then** the listing and its photos are removed and it disappears from My Listings.
5. **Given** a status change or deletion fails (e.g. no connection), **When** the action completes, **Then** a friendly, localized error with a retry path is shown and the listing's actual state is unchanged.

---

### Edge Cases

- Tenant taps "List a shop" but the landlord-role upgrade fails — no role is added, the user stays a tenant, and a friendly error with retry is shown; the create flow is not entered.
- Role upgrade succeeds but switching the active dashboard to landlord fails — the user still proceeds into the create flow, because permissions come from the account's roles, not the active-role choice.
- Network fails mid-way through the multi-step create or edit form — the user can retry without losing the data already entered in the form.
- A photo upload fails after the listing was already created during the create flow — the listing stays pending (not silently lost) and a clear, localized retry path via the edit flow is shown.
- Listing metadata (categories, amenities) fails to load when the form opens — the form shows a retryable state instead of breaking or showing hardcoded options.
- A photo that is not a PNG/JPG image or is larger than the allowed size is selected — it is rejected with a clear, localized message and the rest of the form is unaffected.
- A landlord tries to change or delete a listing they do not own — the attempt is rejected with a friendly message.
- A listing is deleted from another device while the landlord is editing it — saving shows a friendly message that the listing no longer exists and returns to My Listings.
- A listing is re-ordered with photos while the edit form is open — the saved order wins and the form refreshes from the saved state.
- The same action button (save, publish, delete) is tapped twice — only one action is processed, with no duplicate listings or double submissions.
- VAT amounts — the VAT-inclusive figure is always computed by the backend; the app only ever displays it and never submits it, so it can never be entered incorrectly.
- Lists and forms viewed in Arabic — full RTL mirroring; images, text, and ordering lay out correctly.
- My Listings and the create/edit form used at all three screen sizes — no overflow, no unusable controls; the two-pane layout appears only on the widest screens.
- A landlord's My Listings is empty — a clear empty state invites them to create their first listing.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST provide a single "List a shop" entry point. When the account's roles do not include the landlord role, the system MUST show a "Become a Landlord" confirmation sheet before any listing-management action, and MUST NOT grant listing permissions based on the active-role choice alone.
- **FR-002**: On confirmation, the system MUST add the landlord role to the account and immediately adopt the refreshed credentials returned by the change so listing management works right away, then route the user into the create-listing flow without requiring a re-login.
- **FR-003**: The system MUST let a landlord create a listing through a multi-step form covering, in order: shop details (title, category, size, location details, description, amenities, floors), photos, price and lease terms (annual rent, currency, security deposit, minimum lease term, availability date), and a final review before submission.
- **FR-004**: The category and amenity options offered by the form MUST be driven by the listing metadata provided by the backend, not hardcoded in the app, and the form MUST surface a retryable state if that metadata cannot be loaded.
- **FR-005**: The system MUST require the shop's city and district to be chosen from provided options rather than typed freely, with the address carrying the street/building-level detail.
- **FR-006**: A newly created listing MUST start in the pending state — not visible to tenants in the marketplace — and MUST require an explicit publish action to become available.
- **FR-007**: The system MUST let a landlord attach photos from their device, show upload progress, and support removing and reordering photos before and after creation. The system MUST reject files that are not supported image types or exceed the allowed size with a clear, localized message. Photos selected during the create flow are uploaded immediately after the listing is created, within the same submission; if an upload fails the listing remains pending and the landlord can retry adding photos from the edit flow.
- **FR-008**: The final review step MUST show all entered data before submission and MUST display both the annual rent the landlord entered and the VAT-inclusive amount tenants would see.
- **FR-009**: The system MUST provide a "My Listings" view listing every listing the landlord owns, showing photo, title, key details, and current status, and MUST reflect create, edit, and status changes on refresh.
- **FR-010**: The system MUST let a landlord edit every field of an existing listing they own through the same multi-step form, prefilled with current values, and save changes without altering the listing's status. Photo additions, removals, and reordering are buffered during editing and persisted together with the listing update when the landlord saves.
- **FR-011**: The system MUST let a landlord change a listing's status (publish to available, mark as rented, mark as expired). Rented listings MUST remain visible in the marketplace but tagged as "Rented" (never offered as available); expired listings MUST NOT be shown in the marketplace at all.
- **FR-012**: The system MUST let a landlord delete a listing they own after an explicit confirmation, removing the listing and its photos.
- **FR-013**: Permission-sensitive listing actions MUST check the account's roles (specifically the landlord role), never the active-role selection alone.
- **FR-014**: Every listing action (create, edit, status change, delete, photo operations) MUST either succeed or end in a friendly, localized message with a clear retry path — raw technical errors MUST never reach the user. Duplicate submissions MUST be prevented.
- **FR-015**: All screens in this phase MUST be responsive at all three screen-size classes — My Listings using a two-pane list-and-detail layout on the widest class and single-pane navigation on phones, the multi-step form as a single centered column at every size — and MUST be localized in English and Arabic with correct RTL rendering and no layout overflow.
- **FR-016**: Photos attached to a listing MUST display correctly in My Listings, the edit flow, and the review step.

### Key Entities *(include if feature involves data)*

- **Shop listing**: The rentable shop — title, category, size (m²), city, district, address, description, amenities, floor details, availability date, minimum lease term, annual rent, currency (fixed to EGP in this phase; the field remains on the model for forward compatibility), security deposit, current status (pending/available/rented/expired), its photos in order, and its VAT-inclusive rent (computed by the backend, read-only). Owned by exactly one landlord.
- **Listing photo**: An image attached to a listing with a display order; a listing can have several, and the order controls how they appear.
- **Listing metadata**: The reference options (categories, amenities, statuses) the backend publishes so the create/edit form is never hardcoded.
- **Landlord role**: The account permission added (via the shared role capability from Phase 1) that grants the right to create and manage listings. It is part of the account's roles and is what listing permissions are checked against.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A first-time tenant can go from tapping "List a shop" to a published, marketplace-visible listing in under 5 minutes, with no re-login during the journey.
- **SC-002**: A landlord can complete the create flow, the edit flow, a status change, and a deletion — 100% of these actions either succeed or end in a friendly, localized message with a retry path; no crashes and no raw technical errors.
- **SC-003**: Every listing created appears in My Listings immediately in the correct status, and every publish/rented/expired change is reflected in My Listings on the next refresh.
- **SC-004**: 100% of photos added, removed, or reordered appear correctly and persist; unsupported files and oversized files are rejected with a clear message in every attempt.
- **SC-005**: Rented listings appear in the marketplace only with a "Rented" tag (never as available), and expired listings never appear in the marketplace at all.
- **SC-006**: A tenant-only account upgraded through "List a shop" gains the landlord role and can immediately create and manage listings, with the upgraded credentials working on the first action.
- **SC-007**: The create/edit form renders its category and amenity options from live metadata with no hardcoded lists; when metadata is unavailable the form shows a retryable state rather than a broken or misleading form.
- **SC-008**: All screens in this phase are verified at all three screen-size classes and in both English and Arabic (RTL), with the My Listings two-pane layout on the widest class and no layout overflow.

## Assumptions

- The finalized Phase 2 listings API guide (`FRONTEND_PHASE2_LISTINGS_API_GUIDE.md`) is the authoritative contract for this phase; the implementation plan's earlier simplified listing shapes (draft/published/rented statuses and `GET /listings/mine`) are superseded by it (see Clarifications Q1).
- The pending status plays the "not yet public" role; there is no separate draft state beyond it (see Clarifications Q1).
- A listing's marketplace presence is driven by its status: only AVAILABLE listings are offered to tenants, RENTED listings remain visible with a "Rented" tag, and PENDING/EXPIRED listings are hidden (see Clarifications Q2).
- The app recommends at least 3 photos per listing but enforces no minimum; the backend accepts any count (see Clarifications Q3).
- The listings metadata response is the one listing response that does not use the standard envelope (it returns `{ success, data }` instead of `{ message, status, data }`); the networking layer handles this single exception.
- `minimumLeaseTerm` is a free-text field per the API guide, not a preset dropdown of options.
- The app's environment configuration points all envs at the single deployed Railway base (`https://shopspace-backend-production.up.railway.app`); there is no local dev base. This spec is agnostic to the port.
- Photos are selected from the device's gallery or camera through the standard system pickers already locked in from Phase 0.
- The VAT-inclusive rent is always computed by the backend as 115% of the annual rent; the app only displays it and never submits it.
- Photo and thumbnail URLs returned by the backend (media uploads and `thumbnailUrl` fields) are absolute Cloudinary CDN URLs; the app renders them directly as-is and does not prepend a base address (see API guide §8.6).
- A listing can be edited at any status; changing status is always an explicit user action.
- Deleting a listing also removes its uploaded photos.
- Saved listings (the tenant's saved/favourite list) belong to Phase 3 and are out of scope for this phase, even though the backend endpoints exist.
- The listing detail endpoint is used to prefill the edit form; marketplace browsing and detail are Phase 3 scope.
- City and district must be chosen from dropdown options per the API guide (§8.1). The metadata endpoint only publishes categories, amenities, and statuses — it does NOT provide city/district options — so the app uses a local curated city/district list for the dropdowns and the gap (backend not yet exposing city/district options) is flagged for the backend team.
- The minimum supported tablet size for the expanded layout class remains 10"+ (established in Phase 0).
- Design for all screens in this phase (My Listings, Create/Edit Listing, status changes, "Become a Landlord" sheet) comes from the `shop-space-ui` Figma file, pulled at the start of this phase; any missing states (error/empty/loading) use styles consistent with the existing design tokens and are flagged.
- English and Arabic are the only required locales; additional locales later are a supported extension, not a rebuild.
