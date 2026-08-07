# Contract: Listing Form

Branch `003-shop-listing-management` · Spec `spec.md` · Model `data-model.md`

## Purpose

Defines the create/edit listing form behavior shared by the two entry points (FR-001 create,
FR-003 edit): field set + validation, meta load, step flow, photo staging, and the strictly different
Save semantics for create (D5) vs edit (D6).

## Entry points

| Entry | Route | Role gate | Behavior |
|---|---|---|---|
| Create | My Listings → "List a shop" | `roles[]` contains `landlord`; otherwise the Become-a-Landlord bottom sheet (contract `become-landlord-flow.md`) | Fresh `ListingFormCubit`, step 1/4 |
| Edit | My Listings detail → "Edit listing" | owner (`ListingNotOwned` on API) | Cubit preloaded from `GET /listings/:id` (fresh snapshot, D6) |

Both reuse the **same** `ListingFormCubit` (D1) — only `isEditMode` differs.

## Meta load (FR-004)

- On form open, fetch `GET /listings/meta` once (categories, amenities, statuses).
- Load failure → retryable state with a retry button (`ListingMetaUnavailable`); the form is not
  blocked from rendering defaults, but Save is disabled until meta (or at least category options)
  is present.
- `meta` does NOT publish city/district options → local curated EN/AR lists (flagged gap).

## Field set + rules

Categories (FR-004): Retail, Showroom, Office, Warehouse, Kiosk, Restaurant, Other. Single select.
Amenities (FR-004): PARKING, SECURITY, AC (multi-select; anything the API returns renders with a
localized label, unknown values fall back to raw string).

| Field | Required | Widget / input | Rule |
|---|---|---|---|
| Title | yes | `TextFormField` | trimmed, non-empty, max length from Figma |
| Category | yes | single-select dropdown | one of meta categories |
| Area (sqm) | yes | `TextFormField` numeric | > 0, no decimals forced |
| City | yes | dropdown | from local EN/AR list |
| District | yes | dropdown | from local EN/AR list |
| Address | no | `TextFormField` | optional free text |
| Description | no | `TextFormField` (multiline) | optional |
| Amenities | no | multi-select chips | 0..n |
| Number of floors | no | numeric | optional int |
| Floor number | yes | numeric | int; 0 = ground floor (label renders "Ground" in EN/AR) |
| Available from | yes | date picker | date part only, serialized `YYYY-MM-DD` |
| Minimum lease term | no | `TextFormField` | free text (assumption §5.1) |
| Annual rent (EGP) | yes | numeric | > 0; VAT preview shown (backend computes `annualRentWithVat = annualRent × 1.15`, display only — FR-008) |
| Currency | read-only | label | "EGP", never editable/submitted (§8.4) |
| Security deposit (months) | no | numeric | optional int |

Form validation uses manual `Form` + custom validators (constitution — no external form package).

## Steps (create = 4, edit = 4, same order)

1. Details (title, category, area, city, district, address, description)
2. Photos (pick multi, reorder, remove; ≥3 recommended message — never a hard block, D3)
3. Price & lease (floors, available from, lease term, rent, currency, deposit)
4. Review & Submit (renders `fields` + photo outcome; edit also shows the staged media diff)

Navigation is Next/Back; back on step 1 in edit mode exits to detail. No persistence of a draft.

## Photo staging (D3)

- Create: all picked photos live as `XFile`s (`pendingAdds`) for the flow's duration; no local disk
  persistence.
- Edit: `existingMedia` (server state) + `pendingAdds` (`XFile`) + `pendingDeletes` (mediaIds) +
  `pendingOrder` (final order). Reorder/remove mutate these staged lists only — nothing is sent to
  the server until Save.
- Type/size validation client-side: PNG/JPG only, ≤20MB per file (`InvalidMediaFile` for violations;
  shown inline, never sent).

## Save semantics

### Create (D5) — sequential, non-all-or-nothing

1. Validate all steps + photos ≥ 1 (0 photos is allowed but the review shows the recommendation; an
   empty photo set is permitted — assumption, flagged).
2. `POST /listings` → `ShopListing` (PENDING). Duplicate-prevention: `isSubmitting` guard (FR-014).
3. Auto-upload photos (`FormData`, batch `onSendProgress` progress bar, D3) → real `ListingMedia`
   replaces the staged list.
4. Success → navigate to detail. Upload failure → listing stays PENDING, localized message +
   "retry via edit" path (NOT all-or-nothing, D5). Create never offers "publish immediately" (FR-006).

### Edit (D6) — staged, strict all-or-nothing

1. Re-fetch fresh `ShopListing` at the start of each attempt (snapshot, so retries converge).
2. Apply in order: `PUT /listings/:id` (fields only, NO status — FR-010) → media `POST` adds →
   media `DELETE`s → `PUT media/reorder` with the final order.
3. Any failure → "nothing was saved"; the whole save must be retried (a partial listing state never
   surfaces). 404 during any step → `ListingNotFound` → "listing no longer exists" + return to
   My Listings.
4. Success → the saved listing replaces the detail/local list entry; My Listings reloads (FR-009).

## State machine (Cubit)

```
idle → metaLoading → idle(meta)
idle → validating (steps pass) → submitting → success | failure
      → submitting guarded by isSubmitting (no double submit)
edit: idle(loaded) → staging edits (client-side only) → submitting → success | failure
```

A form `failure` is always the typed `Failure` from the datasource (never a raw exception), mapped to
a localized message at the UI layer.
