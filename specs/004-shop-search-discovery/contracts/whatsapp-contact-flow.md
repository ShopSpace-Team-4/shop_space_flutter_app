# Contract: WhatsApp Contact Flow (Phase 3)

Feature `004-shop-search-discovery` · Spec `spec.md` · Plan `plan.md` · Model `data-model.md`

## Purpose

Defines the tenant's "Contact via WhatsApp" action (spec US3, FR-009): from the tenant
detail screen's button through the OS hand-off. Trimmed on 2026-08-09 — the button reads
the listing's own `whatsappLink` and launches it directly. **No profile lookup, no
inquiry record, no confirmation screen.**

## Trigger & ownership

The "Contact via WhatsApp" button lives on `ShopDetailPane` (`search/` presentation) and is
rendered by the self-contained `WhatsAppContactButton`
(`features/listing/presentation/widgets/whatsapp_contact_button.dart`). It owns the whole
launch flow itself (in-flight guard + snackbars) — no Cubit, no repository, no get_it
wiring — so both surfaces that use the pane (pushed compact/medium screen and the expanded
right region) get the wiring for free.

## Flow (trimmed US3)

```text
tenant taps "Contact via WhatsApp" (single in-flight flag set)
  ├─ listing.whatsappLink absent ─▶ localized snackbar (FR-009, never silent)
  ├─ primary: https://wa.me/<phone>?text=<localized message> ──▶ opens ──▶ done
  │     (a localized ?text= is appended when the backend link has none)
  ├─ primary can't open ─▶ sms: (same body) ─▶ tel: (phone from the link path)  (D6)
  └─ every channel failed ─▶ localized launch-failure snackbar (FR-014)
```

Nothing happens in-app after a successful launch — no navigation, no dialog. Double-taps
produce exactly one action (in-flight flag, FR-014).

## Deep link construction

- The backend returns the listing's `whatsappLink` as `https://wa.me/<phone>` where
  `<phone>` is the landlord's E.164 number with its leading `+` stripped.
- The button appends a localized prefilled `?text=` (e.g. "Hello, I'm interested in the
  shop '<title>' in <city>, <district>.") only when the link carries none; the `Uri`
  builder URL-encodes it.
- The `sms:`/`tel:` fallbacks use the phone from the link's path and the same localized
  body. A non-`wa.me`/malformed link with no derivable phone only attempts the primary
  launch.

## Guarantees (edge cases)

- Missing `whatsappLink` → localized snackbar; never a silent dead button (FR-009).
- WhatsApp can't open → dialer/SMS fallback keeps contact possible (D6).
- Every failure path ends in a friendly localized message with a retry (FR-014).
- Double-tap → exactly one launch (in-flight flag).

Removed from scope 2026-08-09 (see spec Clarifications): the landlord-profile lookup
(`GET /users/:id`, old Q2) and the `POST /inquiries` record step — nothing is recorded and
`features/inquiries/` was deleted.
