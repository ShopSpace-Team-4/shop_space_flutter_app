# Contract: Advisor Recommended Listings (Phase 5)

Feature `005-ai-advisor-chat` · Spec `spec.md` · Plan `plan.md` · Model `data-model.md` · Decisions D2, D5, D6

## Purpose

Defines how recommended listings render beneath an assistant answer: reuse of the
existing listing card, saved-state consistency, navigation to the existing detail screen,
and the tolerance rules. It is an **optional enrichment** of the answer (US3, P2) — never
a separate request.

## Source & shape (guide §5)

- Recommended listings are generated **server-side** from the advisor response's own
  sources (most common `category` → up to 3 newest `AVAILABLE` listings).
- They arrive inside the same chat response's `data.recommendedListings` (FR-010) and use
  **the same shape as normal listing responses** → parsed with the existing
  `BrowseListing` (D2).
- The API returns **no score field** → the app never displays an AI score or scoring badge
  (FR-011, guide §5).

## Rendering (FR-007/008, D5)

- **Section shown only when** ≥1 `recommendedListings` entry parsed validly. Hidden for
  absent, `null`, empty, or fully-malformed data (FR-007). A rendering failure of the
  section never hides the AI answer or crashes the app.
- A localized "Recommended Listings" title sits above the cards (static fallback — the
  backend provides no structured title; flagged gap, FR-008).
- Each recommendation renders with the **existing** `SearchResultCard` (takes a
  `BrowseListing`): thumbnail, title, location, `Formatters.formatPrice(annualRentWithVat)`
  (display-only), and the save heart. **No new or AI-generated card.**
- Multiple cards stack vertically following the app's existing list patterns (US3 AC4).
- The section lives **inside the assistant message** as a natural extension of the answer
  (US3 AC1).

## Saved-state consistency (D5/D8)

- The heart is wired through the shared `SavedListingsRepository` (Phase 3 D8 protocol:
  optimistic flip, revert on failure). Recommended shops therefore stay consistent with
  search, the detail screen, and the Saved tab — one source of truth, no advisor-local
  save logic.
- Recommended-listing `isSaved` flags come from the browse-shape payload the backend
  returns (server-authoritative when the signed-in token is sent, always the case here).

## Navigation (FR-009)

- Tapping a recommended card pushes the **existing** `/search/:listingId` route
  (`ShopDetailScreen` → `ShopDetailPane`) through the app's normal navigation.
- A recommended listing deleted/unavailable after the answer was generated surfaces the
  existing "no longer available" experience from that detail screen (edge case) — the
  advisor never re-implements listing detail.
- There is **no advisor-specific detail screen**.

## Request discipline (FR-010, SC-007)

- Exactly **one** advisor request per user message; the recommended listings ride that
  same response. No separate recommendations/listings call, ever.
- The app never infers whether recommendations should appear — it renders exactly what the
  backend returns (spec Assumptions: the backend decides relevance).
