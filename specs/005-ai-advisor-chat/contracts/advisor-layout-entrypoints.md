# Contract: Advisor Layout & Entry Points (Phase 5)

Feature `005-ai-advisor-chat` · Spec `spec.md` · Plan `plan.md` · Decisions D8, D10

## Purpose

Defines where the Advisor lives in the app (route + guard) and how the chat screen lays
out at every breakpoint, plus the entry points that reach it (US5).

## Route & guard (FR-001, D10)

- `core/router/app_router.dart`: replace `_placeholderRoute('/advisor', …)` with
  `GoRoute(path: '/advisor', redirect: guard?.call, builder: … → AdvisorChatScreen)` —
  the same `AuthGuard` pattern as `/change-password` and `/search/:listingId`. The Advisor
  is available only to a signed-in user; a signed-out access attempt redirects to `/login`.
- The route stays a full-screen route outside the shell (matching every other non-tab
  surface and the existing `context.go('/advisor')` callers).

## Layout (FR-013, SC-006, D10)

- **Single chat pane at every size class** — compact, medium, and expanded all render the
  same centered chat: a `Center` wrapping `ConstrainedBox(maxWidth: 480.w)`, the exact
  auth-screen pattern (used by `reset_password_screen.dart` / `forgot_password_screen.dart`).
- The implementation plan's **two-pane messaging layout** (session list left, active chat
  right) is **deferred** with the session-list capability (Q1) — not built this phase.
- The screen scrolls the message thread inside the constrained pane; the input row is pinned
  at the bottom of the pane. All sizes/spacing scale with `flutter_screenutil`; layout
  structure is chosen only by the breakpoint rules above (no per-value scaling at
  breakpoint boundaries).
- Full Arabic RTL: the thread, bubbles, input, sources, disclaimer, and recommendation
  title mirror correctly; numbers/prices render with the app's locale-aware formatting
  (`Formatters.formatPrice`); no layout overflow at any size × language.

## Entry points (US5)

1. **Tenant home** (US5 AC1): the existing `HomeAdvisorCard` already calls
   `context.go('/advisor')` — **no change**; it becomes live once the route is swapped.
2. **Search empty state** (US5 AC2): `_EmptySearchView` in `search_screen.dart` gains an
   advisor entry action (localized, e.g. "Ask the AI Space Advisor") beside the existing
   reset-filters CTA; tapping it navigates to `/advisor`.

## Responsiveness gate

Every widget in this surface scales all values with screenutil (`.h`/`.w`/`.sp`/`.r` or
scaled theme tokens) and uses flex widgets (`Expanded`/`Flexible`/`Column`/`Row`) so the
thread, thinking state, error state, and input never overflow (constitution §5, FR-013).
