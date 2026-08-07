# Contract: Listing Status

Branch `003-shop-listing-management` · Spec `spec.md` · Model `data-model.md`

## Purpose

Pins how a listing's lifecycle status is read, changed, and displayed — including the explicit
"publish" moment required by FR-006/FR-009, and the rule that editing never changes status (FR-010).

## The status enum

```dart
enum ListingStatus { pending, available, rented, expired }
```

Values come from the backend (`GET /listings/meta` → `statuses`) and are used verbatim in
`PATCH /listings/:id/status`. `ListingStatus.fromApi` maps `"PENDING"|"AVAILABLE"|"RENTED"|"EXPIRED"`;
unknown values → `pending` + data-integrity log (forward compatible, never crash).

## Backend is the authority (D4)

- The app renders the status the server returns. It never derives, infers, or locally validates a
  transition (no client-side transition graph).
- The app never blocks or enables a picker option based on current status. All four values are always
  offered; the backend accepts or rejects the transition.
- A rejected transition (`ListingStatusFailed`) shows the backend's message via l10n + the current
  status re-fetched, so the UI converges with the server.

## Changing status — `PATCH /listings/:id/status`

| Method & Path | Auth | Body | Success `data` | Error → `Failure` |
|---|---|---|---|---|
| `PATCH /listings/:id/status` | Bearer + owner | `StatusUpdateRequest{ "status": "AVAILABLE" }` | `{ "id": "...", "status": "AVAILABLE" }` | 404 → `ListingNotFound`; 403 → `ListingNotOwned`; rejected transition / other 4xx → `ListingStatusFailed`; per pipeline |

The status picker lives on the My Listings detail (FR-009). Submitting is a single request guarded by
`isSubmitting` (duplicate-prevention, FR-014). On success the Cubit updates the local
`ListingSummary` (and the detail model if open) — no full list reload needed for a status change.

## Publish moment (FR-006)

- A new listing is **always** created as PENDING. There is no "publish immediately" at create time.
- Publishing = the user later choosing `AVAILABLE` in the status picker. While PENDING the listing is
  hidden from the marketplace (backend hides PENDING/EXPIRED; app trusts the server).

## Display rules (spec session 2026-08-07 — app renders, backend decides visibility)

| Status | Tenant-facing visibility | Landlord My Listings rendering |
|---|---|---|
| `PENDING` | hidden (backend) | shown, labeled "Pending" + hint that it's not public yet |
| `AVAILABLE` | offered to tenants | shown, normal |
| `RENTED` | shown with a "Rented" tag | shown, tagged "Rented" |
| `EXPIRED` | hidden (backend) | shown, labeled "Expired" |

The app renders a tag/badge + localized label per status. It does not decide visibility — it displays
whatever the backend returns.

## Interaction with edit (FR-010)

`PUT /listings/:id` never includes `status`. Editing a listing can never implicitly publish or unpark
it. If the user wants a status change they use the picker explicitly. This is enforced at the contract
level: `UpdateListingRequest` has no `status` field.

## Interaction with delete

Deleting removes the listing in any status (after confirmation, FR-012). No status precondition.
