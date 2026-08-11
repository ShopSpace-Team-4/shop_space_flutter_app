# Contract: Advisor Chat State & Conversation (Phase 5)

Feature `005-ai-advisor-chat` · Spec `spec.md` · Plan `plan.md` · Model `data-model.md` · Decisions D3, D7, D9

## Purpose

Defines how the conversation thread lives and how the chat screen drives it: the cubit
lifecycle (Q5 app-run retention), the send-input rules (Q4/Q7), and the failure/retry
behavior (Q6/FR-012). The data flow itself is `advisor-chat-api.md`.

## Cubit lifecycle (Q5, D3)

- `AdvisorChatCubit` is registered in get_it as a **lazy singleton** (injectable
  `@singleton`); the `AdvisorChatScreen` resolves `getIt<AdvisorChatCubit>()` and never
  closes it.
- The state holds the in-memory `List<AdvisorMessage>` thread and the `String? sessionId`.
- Leaving the Advisor (back / tab switch) disposes only screen widgets — the cubit and
  thread survive, so a return renders the same conversation (Q5: retained for the life of
  the app run; **only app restart or logout clears it**).
- Logout resets the cubit (a different user must never see the previous thread). App
  restart rebuilds get_it → fresh cubit → empty thread (Q2 defers backend history).

## State machine

See `data-model.md` §3.1. Highlights:

1. **empty** → first send → **sending** (user message appended, thinking bubble, send
   control disabled) → **answered** (assistant message: answer + sources + disclaimer
   [+ Recommended Listings section]) or **failed** (localized retry on the failed bubble).
2. **Follow-ups** re-use the stored `sessionId` — same path (FR-004).
3. **Leave & return** — state untouched (singleton).
4. **Failed** — the failed user message stays with an inline localized error + retry;
   prior answers are retained (edge case); retry re-sends that same question.

## Send-input rules (Q7, Q4, FR-002)

- **Trim before send** — `input.trim()`.
- **Blank-blocked** — whitespace-only input cannot send.
- **500-char cap** — `TextField.maxLength: 500` + counter; the send control is disabled at
  the cap (blocking, not truncation).
- **One in-flight request** — the send control is disabled while `isSending`; no
  cancellation, no queuing (Q4).
- Send-enabled predicate: `!isSending && trimmed.isNotEmpty && trimmed.length <= 500`.

## Failure & retry (FR-012, Q6)

- Every failure (request error, connection loss, timeout) surfaces a **friendly localized
  message with a clear retry path**; raw technical messages never reach the user.
- A send exceeding the **10-second client timeout** is a timeout failure with the same
  retry path (Q6; timeout enforced in the datasource per `advisor-chat-api.md`).
- The retry re-sends the same question through the same `sendChat` path.
- 401 mid-chat: exactly one silent refresh + retry once via the global pipeline; on
  continued failure the tenant returns to login (US1 AC5).

## Disclaimer (D9)

Every assistant message renders the disclaimer block. Copy = the backend's `disclaimer`
when non-empty, else the fixed localized "informational only" string. The block always
renders (FR-003 + "no disclaimer" edge case), styled from the app's design tokens.

## Localization & RTL

All chat copy — hints, send tooltips, thinking label, sources label, disclaimer, retry
actions, recommendation title, empty-conversation welcome — is externalized (EN + AR) in
`app_en.arb`/`app_ar.arb`. The message list, input, and bubbles render correctly in RTL
(no hardcoded strings, no direction assumptions).
