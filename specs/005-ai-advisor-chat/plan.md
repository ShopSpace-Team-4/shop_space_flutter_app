# Implementation Plan: AI Business Advisor (Chat UI)

**Branch**: `005-ai-advisor-chat` | **Date**: 2026-08-11 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/005-ai-advisor-chat/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command; its definition describes the execution workflow.

## Summary

Deliver Phase 5 of ShopSpace: the AI Business Advisor chat, as one feature boundary —
`advisor/` with `data/ | repository/ | presentation/` on the Phase 0/1/3/4 foundations.
A signed-in tenant opens the Advisor (the existing `HomeAdvisorCard` already does
`context.go('/advisor')`; a new CTA is added to the search empty state, US5) and the
`/advisor` placeholder route becomes a real chat screen behind the existing `AuthGuard`
(FR-001). Sending runs through the **finalized** backend contract
`POST /advisor/chat` (guide §4.1/4.2 — first message body `{ message }`, follow-up
`{ message, sessionId }`, Bearer auth; the guide supersedes the plan's earlier "expected"
session endpoints): the datasource parses the response `data` object
(`sessionId`, `answer`, `sources[]`, `disclaimer`, `recommendedListings[]`) **tolerantly** —
absent/null/empty/malformed fields never crash and never hide the answer (FR-006/007).
Messages are strictly request → full response, non-streamed (constitution §6): the app
shows an immediate thinking/loading state, then one complete assistant message with its
sources disclosure and the fixed "informational only" disclaimer (FR-003). The
conversation thread (messages + the backend `sessionId`) is retained **for the life of
the app run**: `AdvisorChatCubit` is a get_it-registered lazy singleton, so leaving and
returning to the Advisor never clears the thread and follow-ups reuse the same session
(Q5, FR-004); only app restart or logout clears it. Input is trimmed before send,
blank/whitespace-only sends are blocked, a 500-character cap disables the send control at
the limit, and the send control is disabled while a request is generating — exactly one
advisor request in flight, no cancellation, no queuing (Q4/Q7, FR-002). Every failure —
request error, connection loss, expired session (401 → the global exactly-one-silent-
refresh-then-login rule) — surfaces a friendly localized message with a retry path, and a
send exceeding the 10-second client timeout is a timeout failure with the same retry
(Q6, FR-012; the advisor call overrides the global 5s dio timeout with a 10s per-request
timeout, D4). When the answer carries at least one valid recommended listing (guide §5 —
up to 3 newest AVAILABLE shops in the dominant category, same shape as browse), a
localized "Recommended Listings" section renders beneath the answer using the **existing**
`SearchResultCard` (heart wired through the shared `SavedListingsRepository`), and tapping
a card pushes the **existing** `/search/:listingId` detail screen (FR-008/009); empty,
null, or fully-malformed recommendation data hides the section entirely (FR-007), no AI
score is ever displayed (FR-011), and exactly one advisor request is sent per user message
(FR-010). The chat is a single centered pane at every breakpoint (max-width 480.w
auth-screen pattern, no two-pane split this phase — no session list, FR-013), responsive
and fully localized EN/AR with RTL. No new packages, no new patterns, no GenUI; the
session-list capability and history loading are explicitly out of scope (Q1/Q2) and the
missing "list my sessions" endpoint plus the unconfirmed history response shape are
flagged as gaps for the backend team. No new test files (constitution, amended 2026-08-06);
the six recommendation scenarios are manual QA / acceptance checks at all three
breakpoints × EN/AR (Q3), and the gate stays `flutter analyze`.

## Technical Context

**Language/Version**: Dart 3.9.2 / Flutter 3.35.7 stable (`C:\flutter`; the bare
`C:\dart-sdk` on PATH is a different SDK and is only used by opencode's LSP — use
`flutter` for all tooling).

**Primary Dependencies** (locked stack, no substitutions; **nothing new added**):
- `flutter_bloc` 9.1.1 (+ `equatable`) — Cubit-first; `AdvisorChatCubit` only (a single
  send action, not an event stream — no full BLoC needed).
- `go_router` **17.2.3** (pin) — replace the `/advisor` placeholder with the real
  `AdvisorChatScreen` behind `AuthGuard`; recommendation taps push the existing
  `/search/:listingId`.
- `dio` 5.11.0 — new `AdvisorDataSource` reuses the Phase 0 pipeline unchanged (envelope
  unwrap, auth header, 401 single-refresh). The advisor call overrides the global 5s dio
  timeout with a **per-request 10s** `Options(receiveTimeout:)` (D4).
- `get_it` 9.2.1 + `injectable` 3.0.0 — register `AdvisorRepository`/
  `AdvisorDataSource` against interfaces, and `AdvisorChatCubit` as a **lazy singleton**
  (the Q5 app-run conversation retention mechanism — consistent with `AuthSessionCubit`
  already being a get_it singleton).
- `freezed` 3.2.5 + `json_serializable` — new models (`AdvisorResponse`,
  `AdvisorSource`, `AdvisorMessage`); recommended listings reuse `BrowseListing` as-is.
- `cached_network_image` — recommendation thumbnails (via the reused `SearchResultCard`).
- `flutter_screenutil` 5.9.3 — scales values; Material 3 window size classes
  (compact <600dp / medium 600–839dp / expanded ≥840dp) never split the chat — single
  centered pane at every size (FR-013).
- `intl` 0.20.3 + `flutter_localizations` — locale-aware number/price formatting via the
  existing `core/utils/formatters.dart` (`Formatters.formatPrice`) on recommendation cards.
- Tests: `bloc_test` + `mocktail` + `integration_test` (existing). **No new tests ship
  this phase** (approved 2026-08-06); existing suites stay green.

**Storage**: No new storage. Tokens stay in `flutter_secure_storage`, prefs in
`shared_preferences` (Phase 0/1, untouched). The conversation and session identifier live
**in memory only** in the singleton `AdvisorChatCubit` — there is no local persistence,
so an app restart (and logout) clears the thread by construction (Q5). History reloading
is out of scope until the backend confirms the messages-endpoint shape (Q2).

**Testing**: `dart run tool/quality.dart` runs `flutter analyze` **only** (analyze-only
gate — the test suite was removed 2026-08-06) and exits non-zero on any failure. Per
constitution §8 (amended 2026-08-06), new Phase 5 code ships **without new tests**.
Verification = the analyze gate + manual smoke at 3 breakpoints × EN/AR (the six
recommendation scenarios are manual QA / acceptance checks, Q3). Refactors (route swap,
search empty-state CTA) must not break existing suites.

**Target Platform**: iOS + Android (mobile-first Flutter app). `AppAdaptiveShell` stays
the app shell; the Advisor is a full-screen chat route outside the shell, single centered
pane at all breakpoints (no two-pane split this phase — no session list, FR-013).

**Project Type**: mobile-app (Flutter).

**Performance Goals**: a thinking/loading state appears immediately on send (FR-002);
a complete answer renders within the backend's expected 3–5s window; a send exceeding the
10-second client timeout resolves to a friendly retryable error — never an infinite
spinner (SC-001); exactly one advisor request in flight at any time (Q4, FR-002); no
layout overflow or mis-rendering at any breakpoint × EN/AR (SC-006).

**Constraints**:
- Envelope `{ message, status, data }` unwrapped exactly once, in the dio layer — the
  feature never parses it. `POST /advisor/chat` is **finalized** (guide §4.1/4.2 — the
  advisor content of `docs/FRONTEND_PHASE3_ADVISOR_SEARCH_GUIDE.md` supersedes the
  implementation plan's earlier expected endpoints) → no mock/stub datasource needed.
  `GET /advisor/sessions/{sessionId}/messages` is documented but its response shape is
  unconfirmed → history loading/rendering is out of scope (Q2); no "list my sessions"
  endpoint exists → no session-list screen (Q1). Both gaps are flagged for the backend.
- Advisor responses are request → full response, **no token streaming** (constitution §6).
- Non-2xx → typed `Failure` (`core/errors/`), never raw exceptions to the UI. New
  `AdvisorChatFailed` gets an l10n key + `ErrorMapper`/`failure_messages` entry; the
  global 10s timeout maps through the existing dio pipeline to `TimeoutFailure` (D4).
- Exactly ONE silent 401 refresh, retry once, then force logout — reused `SessionController`
  pipeline, nothing advisor-specific (US1 AC5).
- Request bodies: first message `{ message }`, follow-up `{ message, sessionId }`; the
  session identifier is the backend's from the first response and is retained for
  follow-ups for the life of the app run (Q5, FR-004).
- Response `data` shape: `{ sessionId, answer, sources: [{ document_id, title, category,
  business_type }], disclaimer, recommendedListings: [...] }`. `sources` fields are
  **snake_case** → a dedicated `AdvisorSource` model with `@JsonKey(name:)` (not a reuse).
  `recommendedListings` reuse the browse listing shape (guide §5) → `BrowseListing`
  reused unchanged.
- Tolerance (FR-006/007): `recommendedListings` may be absent, `null`, empty, or contain
  malformed/partial entries — each item is parsed in isolation and malformed ones are
  skipped; `sources` absent → no sources section; `disclaimer` absent → the fixed
  localized disclaimer still renders; the AI answer always renders, the app never crashes.
- No AI score is ever displayed (guide §5: the API returns no score field; FR-011).
- Exactly one advisor request per user message — no separate recommendations/listings
  request (FR-010); the app never infers whether recommendations should appear — it
  renders exactly what the backend returns.
- Recommendation cards reuse the **existing** `SearchResultCard` (takes `BrowseListing`),
  save heart wired through the shared `SavedListingsRepository` (D8-consistent saved
  state); taps push the **existing** `/search/:listingId` detail screen — never an
  advisor-specific detail screen (FR-008/009). A deleted/unavailable recommended shop
  surfaces the existing "no longer available" experience from that screen.
- Recommended-listings title: no structured backend field exists → localized static
  fallback ("Recommended Listings"), flagged as a gap (FR-008).
- 10-second client timeout: the global dio client is 5s (`dio_client.dart`) → the advisor
  datasource issues its request with a per-request `Options(receiveTimeout:
  Duration(seconds: 10))` so the 10s window is honored (Q6, D4); the pipeline maps the
  resulting dio timeout to `TimeoutFailure` → the same friendly localized retry path.
- Input discipline (Q7): trim before send, blank/whitespace-only sends blocked, 500-char
  cap with the send control disabled at the limit. While generating, the send control is
  disabled — one in-flight request, no cancellation, no queuing (Q4).
- Chat is a single centered pane at every breakpoint (max-width `480.w`, the auth-screen
  pattern) — no two-pane split this phase (FR-013); full Arabic RTL with no overflow.
- No hardcoded user-facing strings; EN/AR externalized from the first line. Design tokens
  from Figma only (`shop-space-ui`, pulled at the start of this phase — chat frames
  expected per the Phase 3/4 experience; missing error/empty/loading frames built
  consistently with existing tokens and flagged, spec Assumptions).
- Base URL: `app_env.dart` points all envs at the single deployed Railway base
  (`https://shopspace-backend-production.up.railway.app`); port-agnostic.

**Scale/Scope**: New endpoints — one: `POST /advisor/chat` (finalized). Screens: Advisor
Chat (single centered pane) replacing the `/advisor` placeholder. Entry points: the
existing home `HomeAdvisorCard` (already navigates to `/advisor` — no change) + a new
advisor CTA in the search empty state (`_EmptySearchView`). Feature: `advisor/` with the
full `data/ | repository/ | presentation/` shape; `data/` holds `AdvisorResponse`,
`AdvisorSource`, `AdvisorMessage` (freezed) + `AdvisorDataSource` (10s timeout, tolerant
parse); `repository/` has the `AdvisorRepository` interface + impl (`sendChat` IS the use
case); `presentation/` has the singleton `AdvisorChatCubit`, the chat screen, and message/
sources/disclaimer/recommendations widgets. ~1 datasource, ~1 repository, ~1 cubit.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| # | Constitution rule | Status |
|---|---|---|
| 1 | Feature-first: `features/<feature>/{data,repository,presentation}`; **no `domain/`, no entities, no standalone use-case classes** (repository method = use case) | PASS — `advisor/` has exactly the three-folder shape; `AdvisorRepository.sendChat` IS the use case |
| 2 | Same freezed models flow unchanged data → repository → presentation (no DTO mapping) | PASS — `AdvisorResponse`/`AdvisorSource`/`AdvisorMessage` are freezed and flow unchanged; `BrowseListing` is reused as-is for recommendations |
| 3 | Cubits depend on repository **interfaces** via get_it; never impl/datasource/dio directly | PASS — `AdvisorChatCubit` injects the `AdvisorRepository` interface (get_it). It is registered as a **lazy singleton** — the deliberate Q5 mechanism (app-run conversation retention, same pattern as the get_it `AuthSessionCubit`) |
| 4 | Cross-feature reuse (inject the same repository into multiple Cubits — never duplicate logic) | PASS — recommendation cards reuse the existing `SearchResultCard` + the shared `SavedListingsRepository` (D8-consistent hearts) + `ListingRepository` via the existing `/search/:listingId` detail — no duplicated listing logic inside `advisor/` |
| 5 | Envelope unwrapped once in dio; typed `Failure` only to UI; raw exceptions never reach UI | PASS — `AdvisorDataSource` reuses the Phase 0 pipeline; `POST /advisor/chat` is finalized (guide §4) so no mock datasource is needed; new `AdvisorChatFailed` is typed |
| 6 | 401 → exactly one silent refresh, retry once, force logout | PASS — reused `SessionController` pipeline (US1 AC5); nothing advisor-specific |
| 7 | Dual-role: default `tenant`; `landlord` via one shared `UserRepository.addRole`; `activeRole` persisted and only picks the dashboard; permission UI reads `roles[]` | N/A Phase 5 — the advisor is available to any authenticated user (guide §4, spec Assumptions); no role logic introduced |
| 8 | `addRole` returns fresh tokens → replace stored pair immediately | N/A Phase 5 — no role-mutation surfaces |
| 9 | Password change → clear session, go to login immediately | N/A Phase 5 — no session-mutation surfaces |
| 10 | Signup always routes to OTP, never login; Google sign-in uses ID token for `/auth/google` | N/A Phase 5 — auth flows untouched |
| 11 | Landlord contact = WhatsApp deep link (not in-app chat); no contact is recorded | N/A Phase 5 (unchanged) — no contact flows added; recommended listings open the existing detail screen whose existing `WhatsAppContactButton` is untouched, nothing is recorded |
| 12 | No package/pattern/folder beyond the locked list without approval | PASS — no new dependencies, no new top-level folders, no GenUI/dynamic-UI generation; the only DI-shape note is the get_it singleton cubit, which reuses the existing `AuthSessionCubit`-as-singleton precedent (flagged, not a deviation) |
| 13 | Design tokens only from Figma; missing frames built consistently + flagged | PASS — `shop-space-ui` pulled at phase start; chat/error/empty/loading frames pulled when available, gaps built with existing tokens and flagged (spec Assumptions) |
| 14 | Localization: EN + AR full RTL; no hardcoded strings, ever | PASS — by design; all chat copy, the disclaimer, sources, and the recommendation title get l10n keys in `app_en.arb`/`app_ar.arb` |
| 15 | Testing & quality: new code ships **without new tests** (2026-08-06); existing suites stay green; checked at 3 breakpoints × 2 languages; `flutter analyze` clean | PASS (adjusted) — new Phase 5 code ships without test files (Q3); the six recommendation scenarios are manual QA / acceptance checks (Q3); refactors (route swap, search empty-state CTA) must not break existing suites; manual smoke at 3 breakpoints × EN/AR |

No violations → Complexity Tracking below is intentionally empty.

**Re-check after Phase 1 design (2026-08-11):** re-verified against `data-model.md`,
`contracts/*`, and `quickstart.md` — all 15 gates still hold (feature shape D1; shared
freezed models + reused `BrowseListing` D2/D5; repository-interface cubit as a get_it
singleton D3; no cross-feature duplication; envelope handled once; 401 pipeline reused;
no role/session/contact surfaces touched; no new packages/folders; Figma tokens deferred
to implementation with gaps flagged; EN/AR externalized; tests adjusted per 2026-08-06
approval). No violations introduced.

## Project Structure

### Documentation (this feature)

```text
specs/005-ai-advisor-chat/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command) — D1–D10 decisions
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
│   ├── advisor-chat-api.md           # POST /advisor/chat contract + tolerance + timeout
│   ├── advisor-chat-state.md         # conversation/cubit lifecycle, retention, input rules, retry
│   ├── advisor-recommended-listings.md # recommendations parsing/render/reuse/navigation
│   └── advisor-layout-entrypoints.md # single centered pane + route + entry points
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

Single Flutter project (matches Phase 0–4 layout; actual tree):

```text
lib/
├── main.dart                      # bootstrap: DI, router (unchanged)
├── app.dart                       # AppAdaptiveShell host (unchanged)
├── core/                          # Phase 0–4 — mostly unchanged
│   ├── router/                    # app_router: /advisor placeholder → AdvisorChatScreen
│   │                              #   (redirect: guard, FR-001)
│   ├── errors/                    # failures.dart (+ AdvisorChatFailed), failure_messages,
│   │                              #   error_mapper (advisor path matcher), dio_failure
│   ├── localization/              # ARB + generated AppLocalizations (+ Phase 5 keys)
│   ├── theme/ · responsive/ · utils/ · storage/ · network/ · widgets/   # unchanged
└── features/
    ├── auth/ · user/ · home/      # Phase 1/2 — untouched (home card already → /advisor)
    ├── listing/ · saved/          # Phase 2/3 — reused unchanged (SearchResultCard,
    │                              #   /search/:listingId detail, SavedListingsRepository)
    ├── search/                    # Phase 3 — entry-point wiring only (US5)
    │   └── presentation/screens/search_screen.dart   # _EmptySearchView += advisor CTA
    └── advisor/                   # Phase 5 — AI Business Advisor (new)
        ├── data/
        │   ├── models/            # AdvisorResponse, AdvisorSource, AdvisorMessage (freezed)
        │   └── advisor_datasource.dart        # POST /advisor/chat; per-request 10s timeout;
        │                                      #   tolerant fromApiData assembly (D2/D4)
        ├── repository/
        │   ├── advisor_repository.dart        # abstract interface (sendChat IS the use case)
        │   └── advisor_repository_impl.dart
        └── presentation/
            ├── cubits/            # advisor_chat_cubit + state (lazy singleton — Q5)
            ├── widgets/           # chat_bubble, thinking_indicator, sources_disclosure,
            │                      #   disclaimer_banner, recommended_listings_section,
            │                      #   chat_message_input
            └── screens/           # advisor_chat_screen (single centered pane, FR-013)

test/                              # UNCHANGED this phase — constitution §8 (2026-08-06):
                                   # new code ships WITHOUT new tests; existing suites must stay
                                   # green. No new Phase 5 test files are created.
```

**Structure Decision**: Single Flutter project (as established in Phase 0 — no new
packages or monorepo). One new feature boundary:
- `advisor/` is fully self-contained (spec scope): its own `AdvisorDataSource`
  (finalized `POST /advisor/chat`), `AdvisorRepository` interface + impl, and
  presentation. The `AdvisorChatCubit` is registered in get_it as a lazy singleton so the
  conversation survives leaving/returning for the life of the app run (Q5, D3) — the same
  precedent as the `AuthSessionCubit` singleton.
- Cross-feature reuse (D5/D8): recommended listings are rendered with the existing
  `SearchResultCard` (BrowseListing) with the heart wired through the shared
  `SavedListingsRepository`, and card taps push the existing `/search/:listingId` detail
  screen — `advisor/` never re-implements listing cards, saved-state, or detail.
- `search/` changes only its empty state: an advisor CTA that navigates to `/advisor`
  (US5 AC2); the home `HomeAdvisorCard` already navigates there (US5 AC1 — no change).
No new top-level directories or dependencies are introduced.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

No violations recorded; table intentionally left empty.
