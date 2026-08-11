# Feature Specification: Phase 5 — AI Business Advisor (Chat UI)

**Feature Branch**: `005-ai-advisor-chat`

**Created**: 2026-08-11

**Status**: Draft

**Input**: User description: "create a spec for Phase 5 — AI Business Advisor (Chat UI) from ShopSpace_Flutter_Implementation_Plan.md and FRONTEND_PHASE3_ADVISOR_SEARCH_GUIDE.md (advisor content only — §4 and §5, not search/filteration), plus the AI Advisor Recommended Listings feature description"

## Clarifications

- **Q1 — Session-list scope**: No session-list screen in this phase. (Resolved 2026-08-11: A — chat-first.) A session is created implicitly by the first message; the app keeps the backend session identifier and reuses it for follow-ups. The backend guide documents no "list my sessions" endpoint, so the missing session-list capability is flagged as a gap for the backend team rather than built on an assumed contract.
- **Q2 — Chat-history scope**: History is NOT built until the backend team confirms the contract. (Resolved 2026-08-11: defer.) `GET /advisor/sessions/{sessionId}/messages` is documented in the guide but its response shape is unconfirmed, so no history loading/rendering UI is built this phase. Only messages sent during the current app session are shown. The endpoint's response shape will be added to the spec once the backend team confirms it.
- **Q3 — Testing expectations**: The constitution governs — no new test files. (Resolved 2026-08-11: A.) The six recommendation scenarios from the feature description are treated as manual QA / acceptance checks (verified at all three breakpoints and in both English and Arabic), and the quality gate stays `flutter analyze`. This is a documented deviation from the pasted feature description's testing section.

### Session 2026-08-11

- **Q4 — Send-while-loading behavior**: What happens when a tenant sends a follow-up while the previous request is still loading? (Resolved 2026-08-11: C — block.) Sending is blocked while a request is generating: the send control is disabled until the current answer arrives, so only one advisor request is ever in flight — no cancellation, no queuing. US2 AC3, the related edge case, and FR-002 are updated to match.
- **Q5 — Conversation retention scope**: If the tenant leaves the Advisor screen mid-conversation and returns, should the conversation still be there? (Resolved 2026-08-11: B — app-run-scoped.) The thread (messages + session identifier) is retained for the life of the app run: leaving and returning to the Advisor does NOT clear the conversation; only an app restart clears it. The related edge case, FR-004, and FR-015 are updated to match.
- **Q6 — Client timeout threshold**: How long should the app wait before showing the timeout/error state? (Resolved 2026-08-11: B — 10 seconds.) A request that exceeds a 10-second client timeout is treated as a timeout failure with the friendly, localized retry path. The related edge case, FR-012, and SC-001 are updated to match.
- **Q7 — Question input rules**: Should there be a limit on question length and how should blank input be handled? (Resolved 2026-08-11: B — trim + blank-block + 500-char cap.) The input is trimmed before sending, blank/whitespace-only sends are blocked, and the question is capped at 500 characters with the send control disabled at the cap. FR-002 and the edge cases are updated to match.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A tenant asks the advisor a question and gets a grounded answer (Priority: P1)

A signed-in tenant opens the Advisor from an entry point (the existing "AI Space Advisor" card on the tenant home, or the search empty state), types a business question such as "What kind of business should I open in New Cairo?", and sends it. The app immediately shows a thinking/loading state, then renders the assistant's full answer as a new message in the conversation. The answer is non-streamed — one question, one complete response. Every assistant answer shows the knowledge-base sources it was grounded in and a fixed "informational only" disclaimer. If the backend takes too long, the tenant sees a clear, friendly timeout/error state with a retry path — never an endless spinner.

**Why this priority**: Asking a question and getting a grounded, cited answer is the entire purpose of the feature. Nothing else in this phase (follow-ups, session history, recommendations) matters unless the core question-and-answer loop works, so this is the foundation everything else builds on.

**Independent Test**: Sign in, open the Advisor, send a question, and confirm the loading state appears, then a full assistant message renders with the answer, its sources, and the disclaimer. A complete, standalone slice.

**Acceptance Scenarios**:

1. **Given** a signed-in tenant on the Advisor, **When** they enter a business question and send it, **Then** a thinking/loading state shows immediately and a complete assistant answer arrives as a new message in the same conversation.
2. **Given** an assistant answer, **When** it renders, **Then** the answer text, the sources it was grounded in, and the "informational only" disclaimer are all visible as part of the message.
3. **Given** the backend does not respond within the expected 3–5 seconds, **When** the wait exceeds the allowed window, **Then** a friendly, localized timeout/error state appears with a retry path instead of an infinite spinner.
4. **Given** the tenant sends a question with no connection, **When** the request fails, **Then** a friendly, localized error with a retry action appears and raw technical messages never reach the user.
5. **Given** the session expires while chatting (e.g. a 401), **When** a request fails, **Then** exactly one silent token refresh is attempted and the request is retried once; if that also fails the tenant is returned to login per the global session rule.

---

### User Story 2 - A tenant follows up in the same conversation (Priority: P1)

After receiving an answer, the tenant asks a follow-up question in the same chat — for example "What licenses should I consider?" — and the advisor responds in context, keeping the thread going as one continuous conversation rather than starting fresh.

**Why this priority**: Real advisory sessions are multi-turn; a single question-and-answer is rarely enough. Continuity is core to the chat experience and uses the same request path as the first message, so it is P1 alongside US1.

**Independent Test**: Send a first question, wait for the answer, then send a follow-up and confirm the answer arrives in the same conversation thread, in context. A complete, standalone slice.

**Acceptance Scenarios**:

1. **Given** the tenant has received one answer in a conversation, **When** they send a follow-up question, **Then** the follow-up's answer appears in the same conversation thread and the backend associates it with the same session.
2. **Given** a follow-up answer that the backend grounds in sources, **When** it renders, **Then** sources and disclaimer are shown exactly as for a first answer.
3. **Given** a previous request is still loading, **When** the tenant tries to submit a follow-up, **Then** the send control is disabled until the current answer arrives, so only one advisor request is ever in flight and no duplicate or overlapping requests occur (Clarification Q4).

---

### User Story 3 - A tenant sees recommended listings when the advisor's answer has them (Priority: P2)

The advisor can optionally attach real ShopSpace listings to its answer (for example, when the tenant asks "I want shops for rent in Smouha suitable for a cafe"). When recommendations exist, the assistant message shows a "Recommended Listings" section beneath the answer, rendered with the existing ShopSpace listing card — no new card design. Tapping a recommended card opens the existing listing-detail screen. When the answer carries no recommendations (for example, "What is the difference between renting and buying a shop?"), no listing section appears at all — just the answer.

**Why this priority**: Recommendations turn a text answer into an actionable shortlist of real shops and reuse already-built listing surfaces, but they are an optional enrichment of the core chat — hence P2, sitting on top of US1/US2.

**Independent Test**: Send a question known to return recommendations and confirm the section with the existing cards appears beneath the answer; send a question known to return none and confirm no listing section renders; tap a recommended card and confirm the existing listing-detail screen opens. A complete, standalone slice.

**Acceptance Scenarios**:

1. **Given** an assistant answer that includes recommended listings, **When** the message renders, **Then** a localized "Recommended Listings" title and the existing ShopSpace listing cards appear directly beneath the answer as a natural extension of it.
2. **Given** an assistant answer with no recommended listings (empty or absent), **When** the message renders, **Then** only the answer, sources, and disclaimer appear — no listing section, no empty placeholder.
3. **Given** a recommended listing card, **When** the tenant taps it, **Then** the existing listing-detail screen for that shop opens, using the app's normal navigation.
4. **Given** multiple recommended listings, **When** the message renders, **Then** all valid cards appear in one vertical stack following the app's existing layout patterns, without breaking the conversation.
5. **Given** malformed, missing, or invalid recommendation data, **When** the message renders, **Then** the AI answer still renders and the app never crashes — the recommendation section is simply skipped.

---

> **Removed 2026-08-11 — User Story 4 ("A tenant resumes or reopens a past conversation") is deferred.** Resolved via Clarifications Q1 (A: no session-list screen) and Q2 (defer history until the backend team confirms the `GET /advisor/sessions/{sessionId}/messages` contract). There is no way to enumerate or reload past conversations this phase, so there is no history story; conversation continuity within the live app session is covered by US2. The remaining stories are numbered US1–US3, US5 to keep stable references.

### User Story 5 - A tenant reaches the advisor from the expected entry points (Priority: P3)

The Advisor is reachable from where tenants expect it — the existing "AI Space Advisor" card on the tenant home screen (already wired to the Advisor route) and the search empty state, where a tenant who found nothing can ask the advisor instead.

**Why this priority**: Entry points are discoverability polish; they only matter once the chat works, so they are the last slice.

**Independent Test**: From a fresh tenant home, open the Advisor via the card; clear the search results and confirm the advisor entry point appears in the search empty state and opens the chat. A complete, standalone slice.

**Acceptance Scenarios**:

1. **Given** the tenant home screen, **When** the tenant taps the existing "AI Space Advisor" card, **Then** the Advisor chat opens.
2. **Given** a search with no results, **When** the empty state is shown, **Then** an advisor entry point is visible and opens the Advisor chat.

---

### Edge Cases

- The tenant pastes a very long question or enters only whitespace — input is trimmed before sending, blank/whitespace-only sends are blocked, and a question longer than 500 characters cannot be sent (cap enforced with the send control disabled at the limit) (Clarification Q7).
- The backend takes longer than the expected 3–5 second window — the app waits up to the 10-second client timeout before showing a friendly, localized timeout/error state with a retry path; never an infinite spinner (Clarification Q6).
- The connection drops while a message is being sent — the message send shows a friendly error with a retry action; the conversation and any already-received answers are not lost.
- The tenant tries to send a follow-up while a request is still loading — the send control is disabled until the current answer arrives, so only one advisor request is ever in flight (no cancellation, no queuing) (Clarification Q4).
- The session expires mid-chat (401) — exactly one silent token refresh is attempted and the request is retried once; on continued failure the tenant is returned to login.
- An assistant response carries no `sources` — the answer still renders without a sources list.
- An assistant response carries no `disclaimer` — the answer still renders with the standard disclaimer treatment applied consistently.
- `recommendedListings` is `null`, absent, an empty list, or contains malformed/partial listing objects — the AI answer always renders and the app never crashes; the recommendation section only renders when at least one valid listing parses.
- A recommended listing was deleted or made unavailable after the answer was generated — tapping its card surfaces the existing "no longer available" experience from the listing-detail screen.
- The tenant leaves the Advisor screen mid-conversation (back or tab switch) and returns — the conversation and session identifier are retained for the life of the app run and must not be cleared on leave-and-return (Clarification Q5). Only an app restart clears the conversation; reloading past messages after a restart is deferred until the backend team confirms the history endpoint contract (Clarification Q2).
- Arabic/RTL usage — all chat copy, sources, the disclaimer, and the recommendation title are localized; numbers, prices, and layout mirror correctly, and the input field and bubbles work in RTL.
- The chat is used at all three screen sizes — no overflow, no unusable controls; the chat renders as a single pane at every size, centered with a maximum content width on wider screens (the same pattern as the auth screens), since this phase has no session list to split into panes.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Advisor MUST be available only to a signed-in user; accessing it MUST pass the same session gate as every other authenticated screen in the app.
- **FR-002**: The chat screen MUST let the user type a business question and send it, MUST show a clear loading/thinking state while the backend is generating, and MUST render the complete non-streamed answer as a message in the conversation (one question → one full response; no partial/streamed tokens). While the backend is generating, the send control MUST be disabled so only one advisor request is ever in flight (Clarification Q4). The question input MUST be trimmed before sending, blank/whitespace-only input MUST NOT be sendable, and the question MUST be capped at 500 characters with the send control disabled at the cap (Clarification Q7).
- **FR-003**: Every assistant answer MUST render its answer text together with any sources it was grounded in and the fixed "informational only" disclaimer, following the app's established message presentation and design system.
- **FR-004**: A follow-up question MUST continue the same conversation thread, reusing the same session with the backend so context is preserved; a first message MUST start a session implicitly (the backend returns the session identifier in the first response and the app MUST retain it for follow-ups). The conversation and its session identifier MUST be retained for the life of the app run — leaving and returning to the Advisor must not clear the thread (Clarification Q5).
- **FR-005**: The Advisor MUST accept questions and follow-ups through the documented chat endpoint (`POST /advisor/chat`, first message body `{ message }`, follow-up body `{ message, sessionId }`, Bearer auth). The documented session-messages endpoint (`GET /advisor/sessions/{sessionId}/messages`) is recognized, but history loading/rendering is out of scope for this phase — no history UI is built until the backend team confirms that endpoint's response shape (Clarification Q2).
- **FR-006**: The advisor response's `recommendedListings` field MUST be parsed as optional: the app MUST handle it being absent, `null`, empty, or a non-empty list without throwing, and MUST tolerate individual malformed listing entries by skipping them.
- **FR-007**: A "Recommended Listings" section MUST appear beneath an assistant answer **only** when at least one valid recommended listing parsed; it MUST be hidden for empty, null, absent, or fully-malformed recommendation data, and a rendering failure of the section MUST never hide the AI answer or crash the app.
- **FR-008**: The recommendation section MUST show a localized title above the cards (a sensible static fallback such as "Recommended Listings" when the backend provides no structured title) and MUST render each recommended listing with the existing ShopSpace listing card component — reusing the app's existing card, not a new or AI-generated one.
- **FR-009**: Tapping a recommended listing card MUST open the existing listing-detail screen for that shop through the app's normal navigation — never a separate, advisor-specific detail screen.
- **FR-010**: The app MUST NOT issue a separate recommendation/listings request: recommended listings arrive inside the same advisor response as the answer, so each user message triggers exactly one advisor request.
- **FR-011**: The app MUST NOT display any AI score or scoring badge on recommendation cards, as the backend currently returns no score field (guide §5).
- **FR-012**: The app MUST surface a friendly, localized message with a clear retry path for every failure — request errors, timeouts, and connection loss — and raw technical errors MUST never reach the user; on a 401 the app MUST follow the global exactly-one-silent-refresh-then-login rule. A request that exceeds the 10-second client timeout MUST be treated as a timeout failure with the same friendly retry path (Clarification Q6).
- **FR-013**: The Advisor MUST be responsive at all three screen-size classes — a single chat pane at every size, centered with a maximum content width on medium/expanded screens (the same pattern as the auth screens), since this phase has no session list to split into panes — and MUST be localized in English and Arabic with correct RTL rendering and no layout overflow. The implementation plan's two-pane messaging layout (session list left, active chat right) applies once the session-list capability is added in a later phase.
- **FR-014**: The Advisor MUST be reachable from the tenant home's existing "AI Space Advisor" card and from the search empty state.
- **FR-015**: The Advisor MUST NOT include a session-list screen in this phase; sessions are created implicitly by the first message, the backend session identifier is retained for follow-ups for the life of the app run (Clarification Q5), and the missing "list my sessions" endpoint is flagged as a gap for the backend team (Clarification Q1).
- **FR-016**: The recommendation scenarios MUST be verified as manual QA / acceptance checks — answer visible, recommendation section shown only when recommendations exist, card tap navigation, and resilience to null/malformed recommendation data — at all three breakpoints and in both English and Arabic, with no new test files written: the constitution (amended 2026-08-06) governs and `flutter analyze` stays the quality gate (Clarification Q3; documented deviation from the pasted feature description's testing section).

*Example of how a technical gap is surfaced without changing the API contract:* the recommendation title currently has no structured backend field, so the app uses a localized static fallback and notes the gap for the backend team rather than inventing a contract change.

### Key Entities *(include if feature involves data)*

- **Advisor conversation (session)**: A multi-turn question-and-answer thread started implicitly by the user's first message and identified by the backend session identifier returned in the first response; follow-up messages reuse it, and its message history is retrievable from the backend.
- **Advisor message**: One turn in a conversation — either the user's question or the assistant's answer — with a role, the content, the sources the answer was grounded in, and a timestamp.
- **Advisor source**: A knowledge-base citation an answer is grounded in (document identifier, title, category, business type); rendered as a disclosure under the answer.
- **Recommended listing**: A real ShopSpace listing the advisor optionally attaches to an answer; it uses the same shape as normal listing responses (up to 3 newest available listings in the dominant category, no score field), and in the app it is displayed and opened with the existing listing card and detail screen.
- **Disclaimer**: The fixed "informational only" notice shown with advisor answers.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A tenant can go from opening the Advisor to seeing a complete, cited answer (text + sources + disclaimer) with a visible loading state and no infinite spinner — the answer renders within the backend's expected 3–5 second window, and a send that exceeds the 10-second client timeout resolves to a friendly retryable error (Clarification Q6); 100% of question sends resolve to a rendered answer or a friendly retryable error.
- **SC-002**: 100% of follow-up questions are answered in the same conversation thread, in context, without losing prior messages.
- **SC-003**: The recommendation section renders with the existing listing card exactly when the response carries at least one valid recommended listing, and is hidden for absent/null/empty/malformed data — verified across all response variations, with the AI answer always visible.
- **SC-004**: 100% of recommended-card taps open the existing listing-detail screen; no advisor-specific detail screen exists.
- **SC-005**: No failure path — timeout, no connection, expired session, or malformed recommendation data — crashes the app or shows a raw technical message; every path ends in a friendly, localized message with a retry action, and 401 handling performs exactly one silent refresh before returning the tenant to login.
- **SC-006**: Every advisor screen is verified at all three screen-size classes and in both English and Arabic (RTL), with a single centered chat pane at every size (no two-pane split this phase, as there is no session list), correct Arabic number/price formatting, and no layout overflow.
- **SC-007**: Exactly one advisor request is sent per user message (no separate recommendations request), and no AI score is ever displayed.
- **SC-008**: The feature adds no new packages, no new architectural pattern, and no GenUI/dynamic-UI generation; existing advisor chat, listing card, and navigation patterns are preserved.

## Assumptions

- The advisor content of `FRONTEND_PHASE3_ADVISOR_SEARCH_GUIDE.md` (§4 AI Business Advisor and §5 Advisor Recommendations) is the authoritative backend contract for this phase and supersedes the implementation plan's earlier "expected" advisor endpoints. Chat uses `POST /advisor/chat` for both the first message and follow-ups; history uses `GET /advisor/sessions/{sessionId}/messages`. Search/filter (§2) and WhatsApp contact (§3) content in that guide belongs to other phases and is out of scope here.
- No explicit session-creation or session-listing endpoint is documented in the guide; a session is created implicitly by the first chat message, and the returned session identifier is retained for follow-ups for the life of the app run (Clarification Q5). Because no "list my sessions" endpoint is documented, no session-list screen is built this phase (Clarification Q1, resolved: chat-first).
- No response-shape assumption is made for `GET /advisor/sessions/{sessionId}/messages`; history loading/rendering is out of scope until the backend team confirms that endpoint's contract (Clarification Q2, resolved: defer).
- Advisor responses are strictly request → full response; there is no token streaming.
- Recommended listings reuse the existing listing shape returned by normal listing responses (guide §5) and render with the existing listing card. A localized static fallback title ("Recommended Listings") is shown because the backend currently provides no structured title; this is flagged as a gap rather than a contract change.
- The app never infers whether recommendations should appear — it renders exactly what the backend returns. The backend decides relevance (e.g. shops in Smouha for a cafe → answer + listings; "what is a security deposit?" → answer only).
- All UI and screens in this phase come from the `shop-space-ui` Figma frames, pulled at the start of the phase, and must be typical — following the design's established patterns and tokens with no invented styles. Missing error/empty/loading states use styles consistent with the existing design tokens and are flagged.
- Because this phase has no session list, the chat uses a single pane centered with a maximum content width on wider screens (the same adaptive pattern as the auth screens); the implementation plan's two-pane messaging layout is deferred with the session-list capability.
- English and Arabic are the only required locales; additional locales later are a supported extension, not a rebuild.
- The constitution (amended 2026-08-06) governs testing: new work ships without new test files and the quality gate is `flutter analyze`. The six recommendation scenarios in the pasted feature description are treated as manual QA / acceptance checks (Clarification Q3, resolved: A).
- The minimum supported tablet size for the expanded layout class remains 10"+ (established in Phase 0).
