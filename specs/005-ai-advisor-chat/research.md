# Research: AI Business Advisor (Chat UI) (Phase 5)

Feature `005-ai-advisor-chat` · Branch `005-ai-advisor-chat` · Plan `plan.md`

## Scope

Deliver the AI Business Advisor chat as one new feature boundary — `advisor/` with
`data/ | repository/ | presentation/` on the Phase 0/1/3/4 foundations. A signed-in
tenant opens the Advisor (the existing home `HomeAdvisorCard` already navigates to
`/advisor`; a new CTA is added to the search empty state) and the `/advisor` placeholder
route becomes a real chat screen behind the existing `AuthGuard`. Sending uses the
**finalized** `POST /advisor/chat` contract (guide §4.1/4.2 — first message `{ message }`,
follow-up `{ message, sessionId }`, Bearer auth) — the guide supersedes the implementation
plan's earlier "expected" session endpoints. The response `data` object
(`sessionId`, `answer`, `sources[]`, `disclaimer`, `recommendedListings[]`) is parsed
tolerantly. The conversation (messages + backend `sessionId`) is retained in memory for
the life of the app run via a get_it-registered lazy-singleton `AdvisorChatCubit` — leaving
and returning never clears it; only restart/logout does. Input is trimmed, blank-blocked,
capped at 500 chars, and the send control is disabled while a request generates (exactly
one request in flight). Failures (including a 10-second client timeout and 401) resolve
to friendly localized retry paths. Recommended listings render with the existing
`SearchResultCard` and open the existing `/search/:listingId` detail; no score is shown;
no separate recommendations request is made. Single centered chat pane at every breakpoint;
EN/AR full RTL; UI from the `shop-space-ui` Figma frames pulled at phase start. Session-list
and history UI are out of scope (Q1/Q2) — the missing "list my sessions" endpoint and the
unconfirmed history response shape are flagged as backend gaps. No new test files (Q3).

## Resolved Decisions

### D1 — One feature boundary: `advisor/` with the full three-folder shape

**Decision**: Phase 5 ships as a new `lib/features/advisor/` feature with the exact
`data/ | repository/ | presentation/` layout:
- `data/` — `AdvisorResponse`, `AdvisorSource`, `AdvisorMessage` (freezed) +
  `AdvisorDataSource` (the only code that touches dio for the advisor).
- `repository/` — `AdvisorRepository` abstract interface + one impl; `sendChat` IS the
  use case (constitution §2). There is no use-case class beyond the interface method.
- `presentation/` — `AdvisorChatCubit` + state, the chat screen, and message/sources/
  disclaimer/recommendations/input widgets.

**Rationale**:
- The advisor is a self-contained, session-bound chat feature with its own contract,
  matching the `saved/` precedent (spec-mandated self-contained area, Phase 3 D1).
- The chat state machine (Q4/Q5/Q6/Q7) and the response tolerance rules (FR-006/007)
  are feature-specific; there is nothing to share with other features at the data level.

**Alternatives rejected**:
- Adding the advisor under `search/` or `home/` (mixes an independent contract into an
  unrelated feature; the advisor is reachable from multiple entry points).
- A shared `chat/` feature for future WhatsApp chat (no in-app chat exists; the advisor
  is the only chat surface — constitution §6).
- Skipping the repository layer and letting the cubit call the datasource (violates
  constitution §2 — cubits must call the repository interface).

### D2 — Tolerant response parsing: dedicated models + per-item tolerance in the datasource

**Decision**: Three freezed models, plus reuse:
- `AdvisorResponse { sessionId: String?, answer: String, sources: List<AdvisorSource>,
  disclaimer: String?, recommendedListings: List<BrowseListing> }` — wire model for the
  response `data` object.
- `AdvisorSource { documentId, title, category, businessType }` — a **dedicated** model
  because the guide's source fields are **snake_case** (`document_id`,
  `business_type`), mapped with `@JsonKey(name:)`. Not a reuse of any listing model.
- `AdvisorMessage { id, role, content, sources, createdAt }` — a locally-constructed
  conversation turn (user question or assistant answer), no wire mapping (history loading
  is out of scope, Q2).
- `recommendedListings` items reuse the existing freezed `BrowseListing` unchanged — the
  guide §5 states recommendations use "the same shape as normal listing responses".

**Tolerance lives in one place**: the datasource assembles the `AdvisorResponse` from the
raw `data` map via a tolerant factory (`AdvisorResponse.fromApiData`). Each
`recommendedListings` entry is parsed in isolation with try/catch so a malformed entry is
skipped, not fatal; absent/null/empty `recommendedListings`, `sources`, and `disclaimer`
yield empty/optional fields (FR-006/007 and the edge cases).

**Rationale**:
- freezed's generated `fromJson` is strict (throws on type mismatch); strict parsing of
  an optional, backend-composed list would violate FR-006 ("must tolerate individual
  malformed listing entries by skipping them"). A single tolerant factory keeps the
  freezed model clean and the tolerance auditable in exactly one place.
- Reusing `BrowseListing` means the existing `SearchResultCard` (which takes a
  `BrowseListing`) renders recommendations with zero new card code (D5).

**Alternatives rejected**:
- Reusing `ShopListing` for recommendations (the browse-shaped payload lacks landlordId/
  media/status; the slim `BrowseListing` matches the actual shape and the card contract).
- Building a new `RecommendedListing` model mirroring `BrowseListing` (duplicate shape
  with no difference — violates the no-DTO-mapping / no-duplication rules).
- A hand-rolled parse loop in the cubit or UI (tolerance is a data-acquisition concern;
  presentation must receive an already-safe `AdvisorResponse`).

### D3 — App-run conversation retention via a get_it lazy-singleton cubit

**Decision**: `AdvisorChatCubit` (with its `AdvisorChatState` holding the message thread
and the backend `sessionId`) is registered in get_it as a **lazy singleton** (injectable
`@singleton`), not constructed per-screen like the search/detail cubits. The chat screen
resolves `getIt<AdvisorChatCubit>()` and **never closes it**. This gives Q5's
"retained for the life of the app run; leaving and returning must not clear the thread"
behavior for free: navigating away disposes only the screen's widgets, the cubit (and its
state) survives. A restart rebuilds get_it → fresh cubit → empty thread (Q5 "only an app
restart clears it"). Logout explicitly resets the cubit so a different user never sees the
previous user's conversation.

**Rationale**:
- Q5 requires cross-navigation retention, which per-screen cubit construction (the
  search/detail pattern) cannot provide — those cubits are closed on screen dispose.
- get_it singletons are already an established shape here: `AuthSessionCubit` is a
  get_it singleton (`modules.dart`), and `AppRouter`, `Dio`, `SessionController`, etc.
  are all singletons.
- Retaining via a singleton is simpler and more robust than thread-hoisting in the router
  or a service locator handshake between screen instances.

**Alternatives rejected**:
- Screen-constructed cubit + a static/global thread holder (two sources of truth for the
  conversation, brittle lifecycle wiring, and state that survives for the wrong reasons).
- Persisting the thread to `shared_preferences` (Q5 explicitly scopes retention to the
  app run; persistence would wrongly resurrect conversations after restart and raise
  session-ownership questions — Q2 defers history to the backend contract anyway).
- Router-level `Provider`/inherited-widget hoisting (adds a non-locked pattern; get_it is
  the locked DI).

### D4 — 10-second client timeout via a per-request dio override

**Decision**: The advisor datasource issues `POST /advisor/chat` with a **per-request**
`Options(receiveTimeout: Duration(seconds: 10))`. The global dio client's 5s timeout
(`dio_client.dart`) stays untouched for every other surface; only the advisor call opts
into the spec's 10-second window (Q6). The existing dio pipeline maps the resulting
timeout `DioException` to `TimeoutFailure` (via `ErrorMapper`), which the screen surfaces
as the friendly localized timeout state with a retry path (FR-012) — never an infinite
spinner (SC-001).

**Rationale**:
- The backend's expected answer window is 3–5s (spec Assumptions), but the spec's stated
  client timeout is 10s (Q6). The global 5s dio timeout would cut legitimate slow answers
  off too early, so the advisor call must override it.
- Per-request `Options` keeps the override scoped and auditable without changing the
  global pipeline for all features.
- Reusing the existing timeout→`TimeoutFailure` mapping means the UI, the l10n key, and
  the retry path are already the standard ones — no advisor-specific failure plumbing.

**Alternatives rejected**:
- Raising the global dio timeout to 10s (affects every feature's failure semantics and
  the "no infinite spinner" guarantees elsewhere — too broad a change).
- `Future.timeout()` in the cubit (leaves the socket open and duplicates the pipeline's
  own timeout handling; dio already models timeouts as typed failures).
- No override at all (the 5s global timeout would contradict the spec's 10s requirement).

### D5 — Recommendations reuse the existing card + saved-state + detail navigation

**Decision**: When `AdvisorResponse.recommendedListings` is non-empty after tolerant
parsing (D2), the assistant message renders a localized "Recommended Listings" section
that places each item in the **existing** `SearchResultCard` (thumbnail, title, location,
`Formatters.formatPrice(annualRentWithVat)`, save heart). The heart is wired to the shared
`SavedListingsRepository` (Phase 3 D8 protocol: optimistic flip, revert on failure), so
recommended shops stay consistent with search, detail, and the Saved screen. Tapping a
card pushes the **existing** `/search/:listingId` route (the `ShopDetailScreen` →
`ShopDetailPane`, complete with the "no longer available" experience for deleted shops —
FR-009 and the related edge case). No score is rendered anywhere (guide §5, FR-011).

**Rationale**:
- FR-008/009 demand the existing card, existing detail, and normal navigation — reuse is
  the point, not a new design. `SearchResultCard` takes `BrowseListing`, the exact shape
  of recommendation items (D2).
- Wiring the heart through `SavedListingsRepository` keeps one source of truth for saved
  state across all surfaces (the app's established consistency rule) — a recommendation
  IS a real listing.
- `/search/:listingId` works at every breakpoint from the advisor because the advisor is
  a full-screen pushed route and `ShopDetailScreen` renders the pane full-screen.

**Alternatives rejected**:
- A new advisor-specific recommendation card (FR-008 forbids a new/AI-generated card).
- Rendering recommendations with `ListingCard` (that card takes `ListingSummary`, a
  different shape; and it is the My-Listings landlord card, not the marketplace card).
- Navigating to an advisor-specific detail route (FR-009 forbids it).
- Omitting the save heart entirely (a disabled heart renders on the existing card; wiring
  the real shared repo is both more useful and more consistent than leaving a dead button).

### D6 — One request per user message; recommendations ride the chat response

**Decision**: A user message triggers **exactly one** `POST /advisor/chat` call; the
recommended listings arrive inside that same response's `data.recommendedListings`
(FR-010). The app never issues a separate listings/recommendations request and never
infers relevance — it renders exactly what the backend returns (spec Assumptions: the
backend decides whether an answer carries listings).

**Rationale**:
- FR-010 is explicit, and guide §5 confirms recommendations are generated server-side from
  the same sources (dominant category → up to 3 newest AVAILABLE listings).
- One in-flight request per message also matches Q4 (send control disabled while
  generating), keeping the request model trivial.

**Alternatives rejected**:
- A follow-up `GET /listings?category=…` client-side guess (violates FR-010; the app would
  be inferring relevance the backend owns, and the "dominant category" logic is server-side).
- Caching/lazy-loading recommendations separately (unnecessary — they ship with the answer).

### D7 — Input discipline: trim, blank-block, 500-char cap, send disabled while generating

**Decision**: The chat input (a `TextField` with a localized hint, `maxLength: 500`, and
a counter) is **trimmed before send**; whitespace-only input cannot be sent; at the
500-character cap the send control is disabled; and while a request is generating the send
control is disabled until the answer arrives (Q4/Q7, FR-002). The first message starts a
session implicitly; every later message is a follow-up reusing the stored `sessionId`.

**Rationale**:
- Q7 resolved the rules (trim + blank-block + cap) and Q4 resolved the send-while-loading
  behavior (block) — the plan just reflects the resolved spec.
- `TextField.maxLength` gives the cap and counter natively; the send-enabled predicate is
  derived in the cubit/screen from `state.isSending`.

**Alternatives rejected**:
- Queuing follow-ups typed during generation (Q4 explicitly rejected queuing).
- Cancelling the in-flight request when a new send is attempted (Q4 rejected cancellation).
- Silently truncating >500-char input (Q7 specified blocking at the cap, not truncation).

### D8 — Entry points: home card already wired; search empty state gains a CTA

**Decision**: 
- **Home** (US5 AC1): the existing `HomeAdvisorCard` already calls
  `context.go('/advisor')` — **no change**.
- **Search empty state** (US5 AC2): `_EmptySearchView` in `search_screen.dart` gains an
  advisor entry (a localized "Ask the AI Space Advisor"-style action card/button beside
  the existing reset-filters CTA) that navigates to `/advisor`.

**Rationale**:
- The home wiring already exists (Phase 3/4), so US5 AC1 is satisfied by the route swap
  (D10) alone; the only new entry-point work is the search empty state.
- The empty state is exactly where "a tenant who found nothing can ask the advisor
  instead" (spec US5) — the CTA sits alongside the existing reset action.

**Alternatives rejected**:
- Re-adding a home entry (duplicate work — already wired).
- A dedicated advisor tile on the Search screen when results are present (spec only
  requires the empty-state entry; US5 scopes it there).

### D9 — Disclaimer is always shown; backend text when present, fixed localized fallback otherwise

**Decision**: Every assistant message renders a fixed disclaimer block (localized). When
the backend returns a non-empty `disclaimer` string it is used as the copy; when it is
absent/empty, the app shows its fixed localized "informational only" string. The block
always renders (FR-003 + the "no disclaimer" edge case), following the app's established
message presentation and design tokens.

**Rationale**:
- FR-003 says "Every assistant answer MUST render … the fixed 'informational only'
  disclaimer", and the edge case says a missing `disclaimer` "still renders with the
  standard disclaimer treatment applied consistently" — the fallback is mandated.
- Using the backend copy when present respects the backend as the source of truth without
  a contract change; the gap (no structured requirement either way) is minor and safe.

**Alternatives rejected**:
- Hiding the disclaimer when the backend omits it (contradicts FR-003 and the edge case).
- Ignoring the backend `disclaimer` and always using the static string (discards data the
  backend already sends).

### D10 — Route and layout: `/advisor` behind AuthGuard, single centered pane at every size

**Decision**: 
- **Router** (`core/router/app_router.dart`): replace `_placeholderRoute('/advisor', …)`
  with `GoRoute(path: '/advisor', redirect: guard?.call, builder: … AdvisorChatScreen)`
  — the same guard pattern as `/change-password`, `/search/:listingId`, etc. (FR-001:
  advisor is authenticated-only; unavailable to a signed-out user).
- **Layout** (FR-013): the chat screen is a **single pane** at every breakpoint — a
  centered `ConstrainedBox(maxWidth: 480.w)` inside a `Center`, the exact auth-screen
  pattern (`reset_password_screen.dart`/`forgot_password_screen.dart` use the same
  `480.w` max width) — because this phase has no session list to split into panes. The
  plan's two-pane messaging layout (session list left, active chat right) is deferred with
  the session-list capability (Q1).

**Rationale**:
- The advisor placeholder route currently has **no** guard — it must gain one for FR-001.
- The spec explicitly reuses the auth-screen single-pane pattern and forbids a two-pane
  split this phase (FR-013); max-width centering keeps the message list readable on
  medium/expanded without scaling values at breakpoint boundaries.

**Alternatives rejected**:
- Two-pane split now (spec Q1/Q2 and FR-013 explicitly defer it with the session list).
- A bottom-sheet or drawer chat (not a messaging pattern; the spec wants a chat screen).
- Reusing the app shell's tab system for the advisor (it is a pushed full-screen route,
  matching every other non-tab surface and the existing `context.go('/advisor')` calls).

## Research notes (non-decisions)

- **No mock datasource**: `POST /advisor/chat` is finalized in `docs/FRONTEND_PHASE3_
  ADVISOR_SEARCH_GUIDE.md` §4 (the spec's Assumptions make the guide authoritative). The
  "mock-first" convention applies only to unfinalized feature APIs (constitution §3).
- **Backend gaps flagged (no contract invented)**: (a) no "list my sessions" endpoint →
  no session-list screen (Q1); (b) `GET /advisor/sessions/{sessionId}/messages` response
  shape unconfirmed → no history UI (Q2); (c) no structured recommendation-title field →
  localized static fallback (FR-008); (d) no score field → never render one (FR-011).
- **The 401 rule is global**: exactly one silent refresh, retry once, force logout — the
  advisor reuses the existing `SessionController` pipeline; no advisor-specific code.
- **Existing suites must stay green**: the only refactors are the `/advisor` route swap
  and the search empty-state CTA; neither touches existing test-covered contracts.
