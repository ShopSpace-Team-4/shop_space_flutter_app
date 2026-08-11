# Contract: Advisor Chat API (Phase 5)

Feature `005-ai-advisor-chat` · Spec `spec.md` · Plan `plan.md` · Model `data-model.md` · Decisions D2, D4, D6

## Purpose

Defines how `advisor/` talks to the backend for the chat. `POST /advisor/chat` is
**finalized** — `docs/FRONTEND_PHASE3_ADVISOR_SEARCH_GUIDE.md` §4 is the authoritative
contract (the spec's Assumptions state the guide supersedes the implementation plan's
earlier expected advisor endpoints), so **no mock datasource** is needed. Session-list
and history endpoints are not part of this contract.

## Inherited rules (non-negotiable)

1. Envelope `{ message, status, data }` unwrapped once in the dio layer; this contract
   describes the `data` field only.
2. Bearer token attached via the auth interceptor. 401 → exactly one silent refresh,
   retry once, force logout (reused `SessionController` — US1 AC5).
3. Non-2xx → typed `Failure`; new variants live in `core/errors/failures.dart` with l10n
   keys + `ErrorMapper` entries. Raw exceptions never reach the UI (FR-012).

## Endpoint: `POST /advisor/chat` (Bearer, authenticated only — FR-001)

**First message** (no session yet — a session is created implicitly):

```json
{ "message": "What kind of business should I open in New Cairo?" }
```

**Follow-up** (reuses the session returned by the first response — FR-004):

```json
{ "message": "What licenses should I consider?", "sessionId": "<advisor-session-id>" }
```

**Response `data`:**

```json
{
  "sessionId": "<advisor-session-id>",
  "answer": "...",
  "sources": [
    { "document_id": "...", "title": "...", "category": "...", "business_type": "..." }
  ],
  "disclaimer": "...",
  "recommendedListings": []
}
```

`recommendedListings` items use the same shape as normal listing responses (guide §5) —
each is parsed with the existing `BrowseListing.fromJson` (D2, data-model §1.4).

## Tolerance rules (`AdvisorDataSource` → `AdvisorResponse.fromApiData`)

- `sessionId` absent → null; follow-ups are impossible until the first response stores it.
- `answer` missing/unparseable → the response is treated as failed (typed failure + retry).
- `sources` absent/null → `[]` (no sources disclosure, edge case).
- `disclaimer` absent/null → null (fixed localized disclaimer fallback in the UI, D9).
- `recommendedListings` absent, `null`, empty, or a non-array → `[]`.
- `recommendedListings` containing malformed/partial entries → each entry is parsed in
  isolation (try/catch); valid entries are kept, malformed ones skipped (FR-006). The AI
  answer always renders; the app never crashes (FR-007).

Tolerance is implemented **once**, in the datasource's tolerant factory — presentation
receives an already-safe `AdvisorResponse` (D2).

## Timeout (Q6, D4)

The advisor call is issued with a per-request `Options` of `connectTimeout: 15s`,
`sendTimeout: 15s`, and `receiveTimeout: 90s` — the global dio client stays at 5s for every
other surface. The wider receive window accounts for LLM answer generation and a Railway cold
start. A send exceeding the window surfaces the standard `TimeoutFailure` → the friendly
localized timeout state with a retry path (FR-012). Never an infinite spinner.

## Failure surface

| Condition | Typed failure | UI |
|---|---|---|
| Request/network error | `NetworkFailure` | localized error + retry (FR-012) |
| Timeout >90s | `TimeoutFailure` | localized timeout + retry (Q6) |
| No connection | `OfflineFailure` | localized error + retry |
| 401 (unrecovered) | global pipeline → force logout | return to login (US1 AC5) |
| Other non-2xx on the chat call | `AdvisorChatFailed` (new) | localized error + retry |

The retry re-sends the same question; prior messages and answers are never lost.

## Out of scope / flagged gaps (no invented contracts)

- `GET /advisor/sessions/{sessionId}/messages` — documented but response shape
  unconfirmed → no history UI (Q2). Shape to be added once the backend confirms it.
- "List my sessions" — no endpoint exists → no session-list screen (Q1).
- Recommendation title — no structured backend field → localized static fallback (FR-008).
- Score — the API returns none → never display one (FR-011).
