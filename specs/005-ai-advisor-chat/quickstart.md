# Quickstart — Phase 5 (AI Business Advisor, Chat UI)

Branch `005-ai-advisor-chat` · Spec `spec.md` · Plan `plan.md` · Model `data-model.md`

Scenarios for running and manually validating the Phase 5 Advisor feature (`advisor/`).
Read `../001-phase0-project-foundation/quickstart.md` first (Phase 0 baseline),
`../002-auth-verification-roles/quickstart.md` for the session seams, and
`../004-shop-search-discovery/quickstart.md` for the listing card / saved-state / detail
surfaces this phase reuses. Contract details live in `contracts/` — this guide is the
validation/run walkthrough.

## Run

```powershell
# Flutter at C:\flutter (bare C:\dart-sdk on PATH is a DIFFERENT SDK — prefer `flutter`)
flutter pub get
dart run build_runner build -d          # after adding/editing freezed / injectable / json_serializable
flutter run   # config from .env (APP_ENV, API_BASE_URL, GOOGLE_SERVER_CLIENT_ID) — see 001 quickstart; .env is a Flutter asset, re-run (not hot reload) after edits
```

Quality gate (must stay green; exits non-zero on failure):

```powershell
dart run tool/quality.dart               # flutter analyze ONLY (test suite removed 2026-08-06)
```

## Key files

| Concern | Location |
|---|---|
| Advisor datasource (`POST /advisor/chat`, 10s timeout, tolerant parse) | `lib/features/advisor/data/advisor_datasource.dart` |
| Advisor models (freezed) | `lib/features/advisor/data/models/` |
| Advisor repository (interface + impl; `sendChat` IS the use case) | `lib/features/advisor/repository/` |
| Chat cubit (lazy singleton — app-run retention, Q5) | `lib/features/advisor/presentation/cubits/` |
| Chat screen + message/sources/disclaimer/recommendations/input widgets | `lib/features/advisor/presentation/` |
| Router: `/advisor` placeholder → real route behind AuthGuard | `lib/core/router/app_router.dart` |
| New typed failure `AdvisorChatFailed` | `lib/core/errors/failures.dart` |
| Search empty-state advisor CTA (US5) | `lib/features/search/presentation/screens/search_screen.dart` |
| Reused listing card / detail / saved repo (DO NOT duplicate) | `lib/features/listing/presentation/widgets/search_result_card.dart` · `lib/features/search/presentation/screens/shop_detail_screen.dart` · `lib/features/saved/repository/saved_listings_repository.dart` |
| Data model | `specs/005-ai-advisor-chat/data-model.md` |

## Core flows (manual validation)

### 1. Ask a question & get a grounded answer (US1)

1. Sign in → tenant home → tap the **AI Space Advisor** card (already wired) → the chat
   screen opens (auth-only; signed-out access redirects to login, FR-001).
2. Type a question such as "What kind of business should I open in New Cairo?" → Send.
3. Expect an immediate thinking/loading state, then one complete assistant message: the
   answer, its sources disclosure (when present), and the "informational only" disclaimer.
   Non-streamed — one question, one full response (FR-002/003).
4. Send a follow-up ("What licenses should I consider?") → the answer arrives in the same
   thread, in context, reusing the backend session (US2, FR-004).

### 2. Input rules & one-in-flight (Q4/Q7, FR-002)

- Whitespace-only input cannot send; a trimmed question ≤500 chars sends; the counter
  caps at 500 and the send control disables at the limit.
- While an answer is generating, the send control is disabled — exactly one advisor
  request in flight; no duplicates, no cancellation, no queuing.

### 3. Recommended listings (US3, P2)

- Ask something known to return recommendations (e.g. "I want shops for rent in Smouha
  suitable for a cafe") → a localized "Recommended Listings" section appears beneath the
  answer using the **existing** listing cards (heart included — saved state consistent
  with search/detail/Saved, D5). No score is shown anywhere (FR-011).
- Ask something with no recommendations (e.g. "What is the difference between renting and
  buying a shop?") → no listing section at all, just the answer (FR-007).
- Tap a recommended card → the existing `/search/:listingId` detail screen opens; a
  deleted/unavailable shop shows the existing "no longer available" experience (FR-009).
- Each question triggers exactly one network request (FR-010) — check the dev log for no
  extra listings calls.

### 4. Failure, timeout & session paths (FR-012, Q6, US1 AC3–AC5)

- No connection → friendly localized error with a retry action; the conversation and
  prior answers are not lost; retry re-sends the same question.
- Simulate a slow backend (>10s) → the 10-second client timeout resolves to a friendly
  localized timeout/error with a retry path — never an infinite spinner.
- Session expires mid-chat (401) → exactly one silent refresh + one retry via the global
  pipeline; on continued failure the tenant returns to login.

### 5. Retention, entry points & resilience (Q5, US5, FR-006/007)

- Leave the Advisor (back or tab switch) mid-conversation and return → the thread is still
  there (app-run retention via the singleton cubit). App restart (or logout) clears it.
- From a search with no results → the empty state shows an advisor entry; tapping it opens
  the chat (US5 AC2).
- Malformed/empty `recommendedListings` or missing `sources`/`disclaimer` → the answer
  still renders; no crash; the recommendations section simply does not appear.

## Testing

Per the approved 2026-08-06 rule: new Phase 5 code ships WITHOUT new tests; existing
suites are never deleted and must stay green — fix any failures caused by refactors
(route swap, search empty-state CTA). The six recommendation scenarios from the spec are
treated as manual QA / acceptance checks (Q3). Verify every advisor screen at all three
breakpoints (compact/medium/expanded — the chat is a single centered pane at each, max
width 480.w) × EN/AR (RTL) with Arabic number/price formatting and no overflow (FR-013,
SC-006).

## Gotchas

- `POST /advisor/chat` is FINALIZED (guide §4) — build against it directly; **no mock
  datasource**.
- Recommended listings reuse the browse shape → parse with the existing `BrowseListing`;
  never a new model, never the landlord `ListingCard` (FR-008).
- Recommendations render with the existing `SearchResultCard` and open the existing
  `/search/:listingId` detail — never an advisor-specific card/detail (FR-008/009).
- Save hearts on recommendation cards go through the one shared `SavedListingsRepository`
  — never per-screen save logic (D5/D8).
- The advisor call overrides the global 5s dio timeout with a **10s per-request**
  `Options(receiveTimeout:)` (Q6, D4) — keep it scoped to the advisor datasource.
- The conversation lives in the singleton `AdvisorChatCubit` — the screen must **not**
  close it (Q5, D3).
- No session-list screen and no history UI this phase (Q1/Q2); the "list my sessions"
  gap and the unconfirmed history response shape are flagged for the backend team.
- New failures need l10n keys + `ErrorMapper`/`failure_messages` entries; every
  user-facing string (hints, disclaimer, sources label, recommendation title, retry
  actions, welcome copy) is externalized (EN + AR) from the first line of code.
