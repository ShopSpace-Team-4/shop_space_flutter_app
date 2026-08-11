# Data Model — Phase 5 (AI Business Advisor, Chat UI)

Feature `005-ai-advisor-chat` · Branch `005-ai-advisor-chat` · Spec `spec.md` · Plan `plan.md`

Source of truth for wire shapes: `docs/FRONTEND_PHASE3_ADVISOR_SEARCH_GUIDE.md` §4
(chat contract) and §5 (recommendations). Models marked *(reuse)* already exist and flow
unchanged (constitution §2 — no DTO mapping). The advisor's own models are freezed in
`lib/features/advisor/data/models/`.

---

## 1. Entities

### 1.1 `AdvisorResponse` — NEW, `features/advisor/data/models/advisor_response.dart` (freezed)

The response `data` object of `POST /advisor/chat` (guide §4.1). Assembled by the
datasource via a tolerant factory `AdvisorResponse.fromApiData(Map<String, dynamic>)`
(D2) — freezed's strict `fromJson` is **not** used for this model because tolerance is
mandated (FR-006/007). The response shape:

| Field | Type | Notes / tolerance |
|---|---|---|
| `sessionId` | `String?` | Returned on the first response; retained by the cubit for follow-ups (FR-004). Tolerated absent (no follow-up possible until present). |
| `answer` | `String` | The complete non-streamed answer (FR-002). |
| `sources` | `List<AdvisorSource>` | Default `[]` when absent/null (edge case: answer still renders without a sources list). |
| `disclaimer` | `String?` | Rendered when non-empty; the fixed localized "informational only" disclaimer is the fallback when absent (D9, FR-003 edge case). |
| `recommendedListings` | `List<BrowseListing>` | Default `[]` when absent/null/empty; each entry parsed in isolation, malformed entries skipped (FR-006). |

### 1.2 `AdvisorSource` — NEW, `features/advisor/data/models/advisor_source.dart` (freezed)

One knowledge-base citation an answer is grounded in (guide §4.1). Fields are
**snake_case** on the wire → mapped with `@JsonKey(name:)`:

| Field | Wire key | Type | Notes |
|---|---|---|---|
| `documentId` | `document_id` | `String?` | |
| `title` | `title` | `String?` | |
| `category` | `category` | `String?` | |
| `businessType` | `business_type` | `String?` | |

All optional; the app renders what the backend returns (e.g. a title-only citation).
Rendered as a disclosure under the answer (FR-003, "sources" entity).

### 1.3 `AdvisorMessage` — NEW, `features/advisor/data/models/advisor_message.dart` (freezed)

One conversation turn — the user's question or the assistant's answer. **Locally
constructed** by the cubit (there is no wire shape: history loading is out of scope, Q2).

| Field | Type | Notes |
|---|---|---|
| `id` | `String` | Local id (e.g. incrementing/time-based) for keys and retry targeting. |
| `role` | `enum AdvisorRole { user, assistant }` | Who sent the turn. |
| `content` | `String` | The question or the complete answer text. |
| `sources` | `List<AdvisorSource>` | Assistant-only; `[]` for user messages / no-sources answers. |
| `disclaimer` | `String?` | Assistant-only; copied from `AdvisorResponse.disclaimer` so the always-on banner (D9) preserves the per-answer copy (T018 needs `message.disclaimer`). |
| `recommendedListings` | `List<BrowseListing>` | Assistant-only; `[]` when none (FR-007). |
| `createdAt` | `DateTime` | Local timestamp. |

### 1.4 `BrowseListing` — REUSE, `features/listing/data/models/browse_listing.dart`

Each item of `recommendedListings` (guide §5: "the returned listing objects use the same
shape as normal listing responses"): `id, title, category, areaSqm, city, district,
annualRent, annualRentWithVat, currency, thumbnailUrl?, isSaved?`. Rendered by the
existing `SearchResultCard` (D5) with `annualRentWithVat` via `Formatters.formatPrice`
(display-only — never submitted/stored).

### 1.5 `ShopListing` — REUSE, `features/listing/data/models/shop_listing.dart`

Not parsed by the advisor itself. Tapping a recommended card pushes `/search/:listingId`,
where the existing `ListingDetailCubit`/`ShopDetailPane` loads it; a deleted/unavailable
shop surfaces the existing "no longer available" experience (FR-009 edge case).

---

## 2. Relationships

```text
AdvisorResponse 1─* AdvisorSource          (grounding citations, answer disclosure)
AdvisorResponse 0─* BrowseListing          (recommendedListings — optional enrichment, guide §5)
Conversation (in-memory, cubit state) 1─* AdvisorMessage
AdvisorMessage.assistant ── displays ──> AdvisorSource + BrowseListing (recommendations)
BrowseListing ──tapped──> ShopListing detail  (via existing /search/:listingId route)
```

No local persistence — the conversation is an in-memory value held by the singleton
`AdvisorChatCubit` for the life of the app run (Q5, D3); restart/logout reconstructs it
empty. Recommendation cards are real listings: their saved state is server-authoritative
and mutated through the shared `SavedListingsRepository` (D5/D8 consistency).

---

## 3. State machines

### 3.1 `AdvisorChatState` (AdvisorChatCubit)

```
empty (no messages yet; sessionId = null)
  │ send(first question — trimmed, non-blank, ≤500 chars)
  ▼
sending (user message appended + thinking/loading bubble; send control disabled)
  │ success
  ├──────────────────────────────────────────────────────────────┐
  ▼                                                              │ (follow-ups)
answered (assistant message appended: answer + sources            │   reuse sessionId
  + disclaimer [+ Recommended Listings section when ≥1 valid])   │   same path
  │ any failure (request/connection/timeout >10s / 401-not-recovered)
  ▼
failed (friendly localized message with a retry path attached to
  the failed user message; conversation and prior answers retained)
  │ retry (re-sends the same question) ──▶ sending
  │ type a new question ──▶ sending (normal path)

leave & return ──▶ state unchanged (singleton cubit, Q5)
logout / app restart ──▶ empty (cubit reset / get_it rebuilt)
```

Rules that pin the transitions:
- Exactly one request in flight — the send control is disabled while `isSending`
  (Q4, FR-002); no cancellation, no queuing.
- A failure never loses the conversation: the failed user message stays, prior answers
  stay, and the retry re-sends that same message (edge case, FR-012).
- A send exceeding the 10-second client timeout is a timeout failure with the same
  retry path (Q6, D4) — never an infinite spinner (SC-001).
- 401 mid-chat: the global pipeline attempts exactly one silent refresh and retries once;
  on continued failure the tenant is returned to login (US1 AC5) — no advisor-specific
  state; the thread is cleared on logout (D3).

### 3.2 Send-input gating (per Q7)

```
trim(input)
  ├─ empty/whitespace ──▶ cannot send (send control disabled)
  ├─ length > 500 ──▶ cannot send (cap enforced; counter shows length)
  └─ 1 ≤ length ≤ 500 ──▶ can send   (and only when !isSending, Q4)
```

---

## 4. Validation rules

| Rule | Source |
|---|---|
| Question is trimmed before send; blank/whitespace-only sends are blocked; >500 chars cannot be sent (cap disables the control) | Q7, FR-002 |
| Send control disabled while a request generates — exactly one advisor request in flight | Q4, FR-002, SC-007 |
| First message body `{ message }`; follow-up body `{ message, sessionId }`; Bearer auth | guide §4.1/4.2, FR-005 |
| Session identifier retained for the life of the app run; leaving/returning never clears the thread | Q5, FR-004 |
| `recommendedListings` absent/null/empty/malformed → section hidden, answer always renders, no crash | FR-006/007, US3 AC2/AC5 |
| No sources → no sources section; no disclaimer → fixed localized disclaimer still shows | FR-003 edge cases |
| Exactly one advisor request per user message (no separate recommendations request) | FR-010, SC-007 |
| No AI score ever displayed | FR-011, guide §5 |
| Timeout: a send exceeding 10s resolves to a friendly retryable error | Q6, FR-012, SC-001 |
| All failures map to typed `Failure`; raw exceptions never reach the UI | FR-012, constitution §3 |
| 401 → exactly one silent refresh, retry once, then force logout | US1 AC5, constitution §3 |

---

## 5. Wire-shape references

- Finalized: `POST /advisor/chat` — request `{ message }` / `{ message, sessionId }`,
  response `data` `{ sessionId, answer, sources[{document_id,title,category,business_type}],
  disclaimer, recommendedListings[] }` — `docs/FRONTEND_PHASE3_ADVISOR_SEARCH_GUIDE.md` §4.
- Recommendations: generated server-side from sources (dominant category → up to 3 newest
  AVAILABLE listings, same shape as normal listing responses, no score field) — §5.
- Recognized, out of scope: `GET /advisor/sessions/{sessionId}/messages` — response shape
  unconfirmed; no history UI (Q2). No session-list endpoint — no session-list screen (Q1).
