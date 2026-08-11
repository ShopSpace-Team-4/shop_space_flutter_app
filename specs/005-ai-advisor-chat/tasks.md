# Tasks: Phase 5 — AI Business Advisor (Chat UI)

**Input**: Design documents from `/specs/005-ai-advisor-chat/`

**Prerequisites**: `plan.md` (required), `spec.md` (required — user stories), `research.md`, `data-model.md`, `contracts/` (4 contracts)

**Tests**: NO test tasks. Per the constitution (amended 2026-08-06) and spec Clarification **Q3**, new Phase 5 code ships **without new test files**; existing suites stay green; the six recommendation scenarios are manual QA / acceptance checks (Polish T034). The quality gate is `dart run tool/quality.dart` → `flutter analyze` only.

**Organization**: Tasks are grouped by user story (US1 → US2 → US3 → US5 in priority order) to enable independent implementation and verification of each story. Foundational tasks block all stories.

## Design Source (Figma — authoritative for this phase's UI)

File: `shop-space-ui` → `https://www.figma.com/design/pvU6vSwQkWqwT27HVS4Jcp/shop-space-ui` (accessed via Composio MCP, already pulled for this task list).

The **only** Advisor frame in the file is **`97:6296` — "AI Space Advisor"** (375×802 mobile frame). Component map for the implementer:

| Surface | Figma node(s) | Notes / token mapping |
|---|---|---|
| Chat header (gradient bar) | `97:6459`, `97:6467` | Fill = linear-gradient `#0F172A → #1E3A8A` = `AppColors.heroGradientStart` / `heroGradientEnd` |
| Header back button | `97:6460` / `97:6461` | Icon `#2563EB` = `AppColors.primary`; tooltip `commonBack` |
| Header avatar bubble | `97:6463` / `97:6464` | 34×34, radius 10, white 12% fill + white stroke |
| Header title | `97:6468` / `97:6469` | "AI Space Advisor" (white) → l10n `advisorTitle` |
| Header status line | `97:6470` / `97:6471` | "● Always available" (white 50%) → l10n `advisorStatus` |
| Welcome row (empty state) | `97:6473`, `97:6474`/`97:6475` | Avatar 28×28 radius 8, gradient `#2563EB → #6366F1` — `#6366F1` is NOT in `AppColors`; use `AppColors.primary → AppColors.promoGradientEnd` and **flag the 0.05 delta** |
| Welcome bubble | `97:6479` | White fill, border `#E2E8F0` = `AppColors.outline`, shadow rgba(0,0,0,0.06)/4; copy → l10n `advisorWelcome` |
| "Try asking…" label | `97:6482` / `97:6483` | `#94A3B8` = `AppColors.textTertiary` → l10n `advisorTryAsking` |
| 4 suggested-question buttons | `97:6485`, `97:6487`, `97:6489`, `97:6491` | 292×38, radius 10, white fill + outline border; **button text is empty in Figma → author 4 localized prompts (l10n `advisorExampleQuestion1..4`) and flag the gap** |
| Chat input pill | `97:6494` | Radius 999, fill `#F1F5F9` = `AppColors.surfaceVariant`; hint → l10n `advisorInputHint` |
| Send button | `97:6496` / `97:6497` | 38×38 circle, `#2563EB` = `AppColors.primary`, shadow rgba(37,99,235,0.35)/10; tooltip → l10n `advisorSendTooltip` |

**Flagged design gaps** (no Figma frame exists — build with existing tokens, flag, per clarifications agreed 2026-08-11):
1. **User message bubble** — no frame; build with `AppColors.primary` fill + `AppColors.onPrimary` text (consistent with the design system).
2. **Assistant answer bubble with sources + disclaimer** — no frame; extend the welcome-bubble `97:6479` style (white, `AppColors.outline` border) for answer text.
3. **Thinking/loading indicator** — no frame; build with tokens (see US1 T016).
4. **Error / timeout / retry states** — no frame; build consistent with `AppColors.error*` tokens and the existing `AppErrorView` pattern.
5. **Recommended Listings section** — no frame; reuse the existing `SearchResultCard` (itself Figma-derived, Phase 3), localize the title (l10n `advisorRecommendedListings`).
6. **Welcome-avatar gradient end `#6366F1`** — not an existing token (see table above).

**Figma rule (constitution §4)**: reuse the tokens already centralized in `core/theme/`; never invent values. If an implementer re-pulls a frame and it differs from this map, update this table and flag the delta.

## Clarifications (bound this task list)

- **Q1** — No session-list screen (chat-first). **Q2** — No history UI (deferred until backend confirms `GET /advisor/sessions/{sessionId}/messages`). **Q3** — No new test files; manual QA at 3 breakpoints × EN/AR. **Q4** — Block sending while generating (exactly one request in flight). **Q5** — Conversation retained for the life of the app run via a get_it lazy-singleton cubit; leave/return never clears; restart/logout does. **Q6** — 10-second client timeout → friendly retry. **Q7** — Trim before send, blank blocked, 500-char cap disables send.
- **2026-08-11 (this task run)**: (a) Figma frames pulled NOW — node IDs embedded below; (b) welcome/empty state built with existing tokens (Figma `97:6473`+`97:6481` exists — reuse it, flag the `#6366F1` delta); (c) loading/error/timeout states built with existing tokens + flagged; (d) search empty-state CTA reuses the existing `AppEmptyView` + `FilledButton.tonal` pattern.

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Verify the Phase 0–4 baseline and scaffold the `advisor/` feature folder.

- [X] T001 Verify baseline and create the feature branch: run `dart run tool/quality.dart` from the repo root and confirm it exits 0; if `flutter analyze` reports pre-existing failures, fix them WITHOUT deleting existing suites; then create/checkout branch `005-ai-advisor-chat`
- [X] T002 Create the `lib/features/advisor/` folder skeleton matching the `lib/features/saved/` convention: `data/models/`, `repository/`, `presentation/cubits/`, `presentation/screens/`, `presentation/widgets/` (add `.gitkeep` where `saved/` uses them)

**Checkpoint**: Baseline clean, feature folder scaffolded, branch created.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Cross-cutting plumbing + the advisor data layer that EVERY user story depends on (models, errors, l10n, DI).

**⚠️ CRITICAL**: No user story work can begin until this phase is complete.

- [X] T003 [P] Add all Phase 5 l10n keys to `lib/core/localization/app_en.arb` (English) and `lib/core/localization/app_ar.arb` (Arabic, RTL-safe copy), then run `flutter gen-l10n` to regenerate `app_localizations*.dart`. Keys: `advisorTitle`, `advisorStatus`, `advisorWelcome`, `advisorTryAsking`, `advisorExampleQuestion1`..`advisorExampleQuestion4`, `advisorInputHint`, `advisorSendTooltip`, `advisorThinking`, `advisorSourcesTitle`, `advisorDisclaimer`, `advisorRecommendedListings`, `searchAskAdvisor`, `errorAdvisorChat`. Follow the existing ARB key style (camelCase, `@` placeholders block only when a key has placeholders)
- [X] T004 [P] Add the advisor typed failure and wire it through the error pipeline: add `class AdvisorChatFailed extends Failure` to `lib/core/errors/failures.dart`; add `AdvisorChatFailed() => l10n.errorAdvisorChat` to the switch in `lib/core/errors/failure_messages.dart`; add a `_AdvisorPaths` matcher (normalize leading slash + `/api/v1`, match path `advisor/chat` POST) and a `_mapAdvisorBadResponse` case in `lib/core/errors/error_mapper.dart` (mirror the `_SavedPaths` pattern) so any non-2xx on `POST /advisor/chat` maps to `AdvisorChatFailed` while 401/network/timeout/offline keep their global typed failures
- [X] T005 [P] Create the `AdvisorSource` freezed model in `lib/features/advisor/data/models/advisor_source.dart`: fields `documentId` (`document_id`), `title`, `category`, `businessType` (`business_type`), all `String?`, mapped with `@JsonKey(name:)` for the snake_case wire keys (data-model §1.2, guide §4.1). Run `dart run build_runner build -d` for this model
- [X] T006 [P] Create the `AdvisorMessage` freezed model + `AdvisorRole { user, assistant }` enum in `lib/features/advisor/data/models/advisor_message.dart`: fields `id` (String, local), `role` (`AdvisorRole`), `content` (String), `sources` (List<AdvisorSource>, default `[]`), `recommendedListings` (List<BrowseListing>, default `[]`), `createdAt` (DateTime). Locally constructed — NO `fromJson`/`toJson` (history loading is out of scope, Q2). Reuse `BrowseListing` from `lib/features/listing/data/models/browse_listing.dart`. Run `dart run build_runner build -d`
- [X] T007 Create the `AdvisorResponse` freezed model in `lib/features/advisor/data/models/advisor_response.dart`: fields `sessionId` (String?), `answer` (String), `sources` (List<AdvisorSource>, default `[]`), `disclaimer` (String?), `recommendedListings` (List<BrowseListing>, default `[]`). Implement the TOLERANT factory `factory AdvisorResponse.fromApiData(Map<String, dynamic> data)` (D2, data-model §1.1, contract `advisor-chat-api.md` §Tolerance): `answer` missing/unparseable → throw `FormatException` (the datasource maps it to a typed failure); `sources` absent/null → `[]`; `disclaimer` absent/null → null; `recommendedListings` absent/null/empty/non-array → `[]`, and each list entry parsed in isolation with try/catch (valid `BrowseListing.fromJson` entries kept, malformed ones skipped). Do NOT use freezed's strict `fromJson` for this model
- [X] T008 [P] Create the `AdvisorRepository` abstract interface in `lib/features/advisor/repository/advisor_repository.dart`: `Future<AdvisorResponse> sendChat({required String message, String? sessionId})` — the repository method IS the use case (constitution §2). Doc comment references contract `contracts/advisor-chat-api.md`
- [X] T009 Create the `AdvisorDataSource` in `lib/features/advisor/data/advisor_datasource.dart` annotated `@Injectable(as: AdvisorDataSource)` (constructor takes the get_it `Dio`): issues `POST /advisor/chat` (base URL already carries `/api/v1` via the Phase 0 client) with a PER-REQUEST `Options(receiveTimeout: Duration(seconds: 10))` — the global 5s dio timeout stays untouched (Q6, D4); request body is `{ "message": msg }` when `sessionId` is null else `{ "message": msg, "sessionId": sessionId }`; unwraps the envelope `data` (already done by the shared `EnvelopeInterceptor` — read the returned data map) and returns `AdvisorResponse.fromApiData(dataMap)`; never throws raw exceptions past the shared pipeline. This is the ONLY advisor code that touches dio
- [X] T010 Create `AdvisorRepositoryImpl` in `lib/features/advisor/repository/advisor_repository_impl.dart` annotated `@Injectable(as: AdvisorRepository)` (constructor takes `AdvisorDataSource`); `sendChat` delegates to the datasource. Cubits depend only on the interface (constitution §2)
- [X] T011 Run `dart run build_runner build -d` and confirm `lib/core/di/injectable.config.dart` is regenerated with `AdvisorDataSource`/`AdvisorRepository` registrations; run `dart run tool/quality.dart` and confirm clean

**Checkpoint**: Foundation ready — models, errors, l10n, datasource, repository, and DI are in place; user story implementation can begin.

---

## Phase 3: User Story 1 - A tenant asks the advisor a question and gets a grounded answer (Priority: P1) 🎯 MVP

**Goal**: A signed-in tenant opens the Advisor, types a question, sees an immediate thinking state, and gets one complete non-streamed assistant answer with sources (when present) and the always-on "informational only" disclaimer; every failure ends in a friendly localized retry — never an infinite spinner.

**Independent Test** (spec US1 + quickstart §1/§2): Sign in → tenant home → tap the **AI Space Advisor** card → the chat opens (signed-out access redirects to login, FR-001) → send "What kind of business should I open in New Cairo?" → loading state appears, then a full assistant message (answer + sources + disclaimer) renders in the same conversation. Whitespace cannot send; the counter caps at 500; the send control disables while generating. A complete, standalone slice.

**Acceptance coverage**: US1 AC1–AC5; FR-001, FR-002, FR-003, FR-012; Q4/Q6/Q7; edge cases (whitespace/long input, 10s timeout, connection drop, 401, no sources, no disclaimer).

### Implementation for User Story 1

- [X] T012 [US1] Create the `AdvisorChatCubit` + freezed `AdvisorChatState` in `lib/features/advisor/presentation/cubits/` (`advisor_chat_cubit.dart`, `advisor_chat_state.dart`), annotated `@LazySingleton()` so get_it registers it as a lazy singleton — the Q5 app-run retention mechanism (same precedent as `AuthSessionCubit`). Constructor injects the `AdvisorRepository` INTERFACE (never the impl/datasource). State holds: `List<AdvisorMessage> messages`, `String? sessionId`, `bool isSending`, and an inline failed-message descriptor (`failedMessageId` + typed `Failure?`) per data-model §3.1. Methods: `sendMessage(String rawInput)` (trim; ignore blank/whitespace-only; ignore when `isSending` or >500 chars — Q7/Q4), `retry()` (re-sends the failed user message through the same path), `reset()` (clears thread + sessionId for logout). Transitions: `empty → sending (user message appended, isSending=true) → answered (assistant message appended with answer/sources/recommendations) | failed (failedMessageId set, prior messages retained)`. On first success store the backend `sessionId`. Run `dart run build_runner build -d`
- [X] T013 [P] [US1] Create `AdvisorChatHeader` in `lib/features/advisor/presentation/widgets/advisor_chat_header.dart` following Figma `97:6459`/`97:6467`: gradient container `AppColors.heroGradientStart → AppColors.heroGradientEnd`, back button (Figma `97:6460`, `Icons.arrow_back`/RTL-aware, tooltip `commonBack`, `context.pop()`), avatar bubble (Figma `97:6463`), title `advisorTitle`, status line `advisorStatus`. All sizes scale with screenutil; no raw pixel literals in `build` (constitution §5)
- [X] T014 [US1] Create `AdvisorChatScreen` in `lib/features/advisor/presentation/screens/advisor_chat_screen.dart`: single centered chat pane at EVERY breakpoint — `Center` → `ConstrainedBox(maxWidth: 480.w)` (FR-013, the exact auth-screen pattern from `reset_password_screen.dart`/`forgot_password_screen.dart`); the pane is a `Column` = header (T013) + `Expanded` message thread + pinned input row (T019). Resolves `getIt<AdvisorChatCubit>()` in `didChangeDependencies` and NEVER closes it (Q5, D3 — leaving/returning keeps the thread). All padding/spacing via `AppSpacing`/screenutil; flex layout so nothing overflows
- [X] T015 [P] [US1] Create `ChatMessageBubble` in `lib/features/advisor/presentation/widgets/chat_message_bubble.dart`: assistant bubble follows Figma `97:6479` (white fill, `AppColors.outline` border, rounded; text `AppTypography.bodyMedium` `textPrimary`) and renders `message.content`; user bubble is the FLAGGED-GAP design (`AppColors.primary` fill, `AppColors.onPrimary` text, aligned to the trailing edge in LTR / leading in RTL). RTL-safe alignment; all radii/spacing scaled
- [X] T016 [P] [US1] Create `ThinkingIndicator` in `lib/features/advisor/presentation/widgets/thinking_indicator.dart`: the loading bubble shown while `isSending` — assistant-aligned bubble with a scaled `CircularProgressIndicator` (strokeWidth is a non-scaling constant — deliberate) + localized `advisorThinking` label; consistent with Figma bubble styling + tokens; flagged as a gap per clarification (c)
- [X] T017 [P] [US1] Create `SourcesDisclosure` in `lib/features/advisor/presentation/widgets/sources_disclosure.dart`: renders the localized `advisorSourcesTitle` + one row per `AdvisorSource` (title when present, then `category`/`businessType`/`documentId` as secondary text; a title-only source still renders); the widget returns `SizedBox.shrink()` when `sources` is empty (edge case: no sources → answer still renders without the disclosure). All scaled
- [X] T018 [P] [US1] Create `DisclaimerBanner` in `lib/features/advisor/presentation/widgets/disclaimer_banner.dart`: ALWAYS renders (D9, FR-003): copy = backend `message.disclaimer` when non-empty, else the fixed localized `advisorDisclaimer` fallback; styled with `AppColors.surfaceVariant` + `textSecondary`, small caption scale
- [X] T019 [US1] Create `ChatMessageInput` in `lib/features/advisor/presentation/widgets/chat_message_input.dart` per Figma `97:6493`/`97:6494`/`97:6496`: `TextField` with `maxLength: 500` + counter, hint `advisorInputHint` (Figma pill `97:6494`, radius 999, fill `AppColors.surfaceVariant`), and a round send button (Figma `97:6496`, `AppColors.primary`, tooltip `advisorSendTooltip`). Send-enabled predicate `!isSending && trimmed.isNotEmpty && trimmed.length <= 500` (Q4/Q7): blank/whitespace blocked, cap disables send, and the control disables while a request generates. `onSend(String trimmed)` fires `cubit.sendMessage`. TextField must support RTL; scale all values
- [X] T020 [US1] Wire the screen (T014) to the cubit (T012) and the widgets: `BlocBuilder<AdvisorChatCubit, AdvisorChatState>` renders the thread as a scrollable `ListView` (reverse-aligned or auto-scrolled to newest) of `ChatMessageBubble`s; an assistant message renders bubble + `SourcesDisclosure` (T017, only when non-empty) + `DisclaimerBanner` (T018); `ThinkingIndicator` (T016) appended while `isSending`; a FAILED user message (T012 `failedMessageId`) renders an inline localized error from `failureMessage(l10n, failure)` with a Retry action (`cubit.retry()`) — raw technical text NEVER reaches the user (FR-012); prior messages stay on failure; the 10s timeout surfaces via the shared `TimeoutFailure` → same localized retry (Q6)

**Checkpoint**: At this point, User Story 1 is fully functional and independently verifiable.

---

## Phase 4: User Story 2 - A tenant follows up in the same conversation (Priority: P1)

**Goal**: After an answer, the tenant asks a follow-up and the advisor answers in context, keeping one continuous conversation that reuses the backend session. App-run retention means leaving and returning never clears the thread.

**Independent Test** (spec US2 + quickstart §1/§4/§5): Send a first question, wait for the answer, then send a follow-up ("What licenses should I consider?") → the answer arrives in the SAME conversation thread with sources/disclaimer, and the follow-up body carries the stored `sessionId`. While an answer is generating, the send control is disabled (no duplicate/overlapping requests). Leaving the Advisor and returning keeps the thread; only restart/logout clears it. A complete, standalone slice.

**Acceptance coverage**: US2 AC1–AC3; FR-004, FR-005, FR-015; Q4/Q5; edge cases (send-while-loading, leave-and-return, 401 mid-chat).

### Implementation for User Story 2

- [X] T021 [US2] Extend `AdvisorChatCubit.sendMessage` (in `lib/features/advisor/presentation/cubits/advisor_chat_cubit.dart`) for multi-turn continuity (FR-004): on the FIRST success persist `state.sessionId` from the response and append the assistant message; every later send passes the stored `sessionId` into `sendChat` so the body is `{ message, sessionId }` (guide §4.2). Follow-ups append to the same `messages` list — the thread stays one conversation
- [X] T022 [US2] Enforce exactly-one-request-in-flight (US2 AC3, Q4, FR-002): confirm `ChatMessageInput` (T019) and the screen (T020) keep the send control disabled whenever `state.isSending`, with no cancellation and no queuing — a tap while generating is ignored
- [X] T023 [US2] Verify and lock in app-run retention (Q5, FR-004/015): confirm `AdvisorChatScreen` resolves `getIt<AdvisorChatCubit>()` and never disposes/closes it; add a code comment on the screen documenting the singleton-retention contract; manually confirm back-navigation and tab-switch leave/return preserve the thread + `sessionId`; restart clears it (by construction)

**Checkpoint**: User Stories 1 AND 2 both work independently.

---

## Phase 5: User Story 3 - A tenant sees recommended listings when the advisor's answer has them (Priority: P2)

**Goal**: When the backend attaches real listings to an answer (`data.recommendedListings`, guide §5), a localized "Recommended Listings" section appears beneath the answer using the EXISTING `SearchResultCard`; tapping a card opens the existing listing-detail screen. No recommendations → no section. No score is ever shown; exactly one advisor request per message.

**Independent Test** (spec US3 + quickstart §3): Ask "I want shops for rent in Smouha suitable for a cafe" → the localized section with existing cards appears under the answer (hearts consistent with search/detail/Saved); ask "What is the difference between renting and buying a shop?" → no listing section at all; tap a card → the existing `/search/:listingId` detail opens (deleted shops show the existing "no longer available" experience); malformed/null recommendation data never crashes and the AI answer always renders. A complete, standalone slice.

**Acceptance coverage**: US3 AC1–AC5; FR-006, FR-007, FR-008, FR-009, FR-010, FR-011; edge cases (null/empty/malformed `recommendedListings`, deleted shop).

### Implementation for User Story 3

- [X] T024 [US3] Create `RecommendedListingsSection` in `lib/features/advisor/presentation/widgets/recommended_listings_section.dart`: renders the localized `advisorRecommendedListings` title above a vertical stack of EXISTING `SearchResultCard`(s) (FR-008 — reuse `lib/features/search/presentation/widgets/search_result_card.dart`; never a new or AI-generated card); the whole section returns `SizedBox.shrink()` when the message has zero valid listings (FR-007 — hidden for absent/null/empty/fully-malformed data); multiple cards stack vertically per app list patterns (US3 AC4); NO AI score or badge anywhere (FR-011, guide §5)
- [X] T025 [US3] Wire the recommendation-card save heart through the SHARED `SavedListingsRepository` (`lib/features/saved/repository/saved_listings_repository.dart`) with the Phase 3 D8 protocol — optimistic `isSaved` flip on tap, revert on failure, typed failure via snackbar (`failureMessage`): add a toggle handler (calls `repo.save`/`repo.unsave`) exposed to the section, resolving the repository from get_it; NEVER advisor-local save logic (D5/D8). `Formatters.formatPrice(annualRentWithVat, l10n, compact: true)` already renders inside `SearchResultCard` — no price changes here
- [X] T026 [US3] Wire card tap → `context.push('/search/${listing.id}')` → the EXISTING `ShopDetailScreen` (FR-009, D5) — normal app navigation; a deleted/unavailable recommended shop surfaces the existing "no longer available" experience from that screen; there is NO advisor-specific detail screen
- [X] T027 [US3] Resilience pass (FR-006/007): in the message renderer (T020) confirm that a message whose `recommendedListings` is null/empty/malformed still renders answer + sources + disclaimer, with the recommendation section simply absent; the assistant answer is never hidden by a section failure and the app never crashes

**Checkpoint**: User Stories 1, 2, and 3 are all independently functional.

---

## Phase 6: User Story 5 - A tenant reaches the advisor from the expected entry points (Priority: P3)

**Goal**: The Advisor is reachable from the tenant home card (already wired — becomes live with the route swap) and from the search empty state.

**Independent Test** (spec US5 + quickstart §5): From a fresh tenant home, tap the **AI Space Advisor** card → the chat opens; clear search results → the empty state shows an advisor entry beside the reset action → tapping it opens the chat. A complete, standalone slice.

**Acceptance coverage**: US5 AC1–AC2; FR-001, FR-014.

### Implementation for User Story 5

- [X] T028 [P] [US5] Swap the `/advisor` route in `lib/core/router/app_router.dart`: replace `_placeholderRoute('/advisor', (l10n) => l10n.navAdvisor)` (line ~170) with `GoRoute(path: '/advisor', redirect: guard?.call, builder: (context, state) => const AdvisorChatScreen())` — the same `AuthGuard` pattern as `/change-password`/`/search/:listingId` (FR-001: signed-out access redirects to `/login`); add the import for `AdvisorChatScreen`; remove the now-unused `_placeholderRoute` helper if no other route uses it (confirm first); the route stays a full-screen route outside the shell
- [X] T029 [P] [US5] Add the advisor CTA to `_EmptySearchView` in `lib/features/search/presentation/screens/search_screen.dart` (line ~596): a localized action "Ask the AI Space Advisor" (`searchAskAdvisor`) beside the existing reset-filters button, reusing the established `AppEmptyView` + `FilledButton.tonal` pattern (clarification (d)); tapping it calls `context.go('/advisor')`; keep the existing reset behavior; all sizing scaled with screenutil

**Checkpoint**: All user stories independently functional and reachable from every entry point.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Cross-story wiring, RTL/breakpoint verification, and the final quality + manual-QA gates.

- [X] T030 Wire the logout reset: in `lib/features/auth/presentation/cubits/auth_session_cubit.dart`, inside `signOut()` and `clearSession()`, resolve the lazy `getIt<AdvisorChatCubit>()` and call `reset()` (D3) so a different user never sees the previous user's conversation; a lazy resolve means the advisor cubit is only constructed if it was used
- [X] T031 RTL + Arabic pass: verify every advisor surface mirrors correctly — bubbles (user trailing/assistant leading in LTR, flipped in RTL), input field, counter, sources, disclaimer, and the "Recommended Listings" title; Arabic numbers/prices render via `Formatters.formatPrice` (locale-aware); confirm NO hardcoded user-facing strings anywhere in `lib/features/advisor/` (all via `AppLocalizations`)
- [X] T032 Breakpoint pass (FR-013, SC-006): verify the chat renders as a single centered pane (max-width 480.w) at compact <600dp, medium 600–839dp, and expanded ≥840dp with no overflow, no clipped controls, and usable send/retry at every size; screenutil scales values, breakpoints never scale values
- [X] T033 Final gates: run `dart run build_runner build -d` (regenerate any stale freezed/injectable/json artifacts) then `dart run tool/quality.dart`; both must pass clean. Confirm NO new test files were created and no existing suite was touched
- [ ] T034 Manual QA (Q3, FR-016): walk `specs/005-ai-advisor-chat/quickstart.md` §1–§5 at all three breakpoints × EN/AR, covering the six recommendation scenarios (answer visible; section shown only with valid listings; card tap → detail; resilience to null/malformed data; no score shown; exactly one request per message — check the dev log for no extra listings calls, FR-010); record the backend gaps for the backend team (no "list my sessions" endpoint, unconfirmed `GET /advisor/sessions/{sessionId}/messages` shape, no structured recommendation-title field)

> **Note (2026-08-11)**: T034 stays open — it is a device/runtime walkthrough (requires a valid live session against the deployed Railway backend at 3 breakpoints × EN/AR). Code-side readiness for it is complete: the on-device verification of T031/T032 passed by code inspection, the analyze gate (T033) is green, no new test files were created, and the backend gaps above are already recorded in `spec.md` Clarifications, `checklists/requirements.md` Notes, and `research.md` (Q1/Q2 + recommendation-title gap).

**Checkpoint**: Feature complete — responsive, localized (EN/AR, RTL), resilient, analyze-clean, and manually QA'd per quickstart.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — starts immediately.
- **Foundational (Phase 2)**: Depends on Setup — BLOCKS all user stories.
- **US1 (Phase 3)**: Depends on Foundational only.
- **US2 (Phase 4)**: Depends on US1 (its send flow) — completes the multi-turn contract.
- **US3 (Phase 5)**: Depends on US1 (assistant-message rendering); sits on top of the data layer built in Foundational.
- **US5 (Phase 6)**: Depends on US1 (the route must resolve to a real `AdvisorChatScreen`). Independent of US2/US3 in files.
- **Polish (Phase 7)**: Depends on all user stories.

### User Story Dependencies

- **US1 (P1)**: Can start after Foundational — no dependency on other stories. **MVP.**
- **US2 (P1)**: After US1; reuses the same cubit/request path — small, additive.
- **US3 (P2)**: After US1; independent of US2.
- **US5 (P3)**: After US1; independent of US2/US3 (different files).

### Within Each User Story

- Models/services/repository are in Foundational (they serve every story — shared).
- Cubit → widgets → screen wiring (US1); same-path extensions (US2); reuse surfaces (US3); route/CTA (US5).

### Parallel Opportunities

- **Setup**: T001 then T002 (sequential).
- **Foundational**: T003, T004, T005, T006 run in parallel (different files). T007 after T005/T006. T008 [P] parallel with T007. T009 after T007; T010 after T008+T009; T011 last.
- **US1**: T013 [P], T015 [P], T016 [P], T017 [P], T018 [P] run in parallel after T012; T014/T019 after T012; T020 wires everything last.
- **US2**: sequential (same cubit file).
- **US3**: T024 → T025 → T026 → T027 (same section file — do not parallelize to avoid conflicts).
- **US5**: T028 and T029 run in parallel (different files).
- **Polish**: sequential except manual QA T034 can start once T031/T032 pass.

---

## Parallel Example: User Story 1

```text
# Launch all independent widgets for US1 together (after T012 cubit):
Task: "Create AdvisorChatHeader ... advisor_chat_header.dart"
Task: "Create ChatMessageBubble ... chat_message_bubble.dart"
Task: "Create ThinkingIndicator ... thinking_indicator.dart"
Task: "Create SourcesDisclosure ... sources_disclosure.dart"
Task: "Create DisclaimerBanner ... disclaimer_banner.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 (Setup).
2. Complete Phase 2 (Foundational — CRITICAL, blocks all stories).
3. Complete Phase 3 (US1): the full ask → answer → sources/disclaimer loop with input rules, loading state, and localized retry.
4. **STOP and VALIDATE**: independently verify US1 (sign in → home card → ask → grounded answer; failure/timeout paths).
5. Deploy/demo if ready — US1 alone is a complete, valuable slice.

### Incremental Delivery

1. Setup + Foundational → foundation ready.
2. Add US1 → verify independently → Deploy/Demo (**MVP**).
3. Add US2 (follow-up continuity) → verify independently.
4. Add US3 (recommended listings) → verify independently.
5. Add US5 (entry points) → verify independently.
6. Polish + gates + manual QA.

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together (T003–T011 parallelizable).
2. Once Foundational is done: Developer A → US1; after US1, Developer B → US2, Developer C → US3, Developer D → US5 (parallel across stories, distinct files).
3. Stories complete and integrate independently.

---

## Notes

- [P] tasks = different files, no dependencies on incomplete tasks.
- [Story] label maps the task to a user story for traceability (US1/US2/US3/US5). Setup, Foundational, and Polish carry no story label.
- Each user story is independently completable and verifiable.
- **No test tasks** — the constitution (amended 2026-08-06) forbids new test files; verification = `flutter analyze` (T011/T033) + manual QA (T034).
- Commit after each task or logical group; stop at any checkpoint to validate the story independently.
- Avoid: vague tasks, same-file conflicts, cross-story dependencies that break independence.
- **Figma-first**: every UI widget references its Figma node(s) in the "Design Source" table above; flagged gaps are built with existing tokens and never invent new styles (constitution §4).
