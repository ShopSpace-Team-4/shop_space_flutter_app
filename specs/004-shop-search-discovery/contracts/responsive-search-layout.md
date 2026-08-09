# Contract: Responsive Search Layout (Phase 3)

Feature `004-shop-search-discovery` · Spec `spec.md` · Plan `plan.md` · Decision D10

## Purpose

Defines how the Search and tenant-detail surfaces adapt to the three Material 3
window-size classes (compact <600dp, medium 600–839dp, expanded ≥840dp — `core/responsive/
window_size.dart`). Structure is chosen by size classes; `flutter_screenutil` scales values
only (constitution §5 — different jobs).

## Search screen

| | compact (<600dp) | medium (600–839dp) | expanded (≥840dp) |
|---|---|---|---|
| Filters | bottom sheet / drawer | bottom sheet / drawer | **persistent sidebar** |
| Results | full-screen list | full-screen list | middle region |
| Detail | pushed route `/search/:listingId` | pushed route `/search/:listingId` | **right pane** (in-place, no navigation) |

- The filter sidebar and the bottom sheet **share the same filter widget tree and the same
  draft/apply `SearchFilters` state** — one filter implementation, two containers
  (FR-015, US1 scenario 6). "Apply" commits the draft; the results refresh without a full
  reload and without list jumping (US1).
- On expanded, selecting a card updates the detail pane in place; on compact/medium the
  card pushes the tenant detail screen. Both render the same tenant detail pane widget.
- `AppAdaptiveShell` stays the app shell (NavigationBar compact, NavigationRail
  medium/expanded) — untouched.

## Tenant detail screen (`/search/:listingId`)

| | compact/medium | expanded |
|---|---|---|
| Route | pushed full screen | not routed — rendered as the Search right pane |

The pane shows the photo gallery (media ordered by `sortOrder`), title, description,
location, size, shop type, amenities, floor details, availability date, minimum lease term,
security-deposit months, status, VAT-inclusive price, and the saved state (FR-008); the
"Contact via WhatsApp" action (contract `whatsapp-contact-flow.md`); and a "no longer
available" localized state when `GET /listings/:id` returns `ListingNotFound`
(US2 scenario 4).

## Verification

Checked at all three breakpoints × EN/AR (RTL) with no overflow and no unusable controls;
the two-pane (three-region) layout appears only on the widest class (FR-015, SC-007).
