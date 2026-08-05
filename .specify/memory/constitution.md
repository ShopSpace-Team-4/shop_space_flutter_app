<!--
CONSTITUTION SYNC IMPACT REPORT
Version change: 1.1.0 -> 1.2.0 (MINOR)
Modified principles:
  - 1. Tech Stack: replaced the flutter_adaptive_scaffold mandate with the
    hand-rolled AppAdaptiveShell (Material NavigationBar/NavigationRail).
    flutter_adaptive_scaffold is discontinued upstream (deprecated Feb 2025,
    archived flutter/flutter#162965) and was replaced by approved decision D1
    (2026-08-05) in the Phase 0 implementation plan. The responsive/adaptive
    split stays unchanged (screenutil scales values, size classes pick layout).
Added sections: none
Removed sections: none
Deferred TODOs: none
-->

<!--
CONSTITUTION SYNC IMPACT REPORT
Version change: 1.0.0 -> 1.1.0 (MINOR)
Modified principles:
  - 1. Tech Stack: added the packages the implementation plan locks in
    (equatable, flutter_secure_storage, shared_preferences, image_picker,
    cached_network_image, url_launcher, google_sign_in, bloc_test,
    mocktail, integration_test), --dart-define + core/env/ environment
    config, and ARB/JSON localization files under core/localization/
  - 2. Architecture: added core/env/ and core/utils/ to the cross-cutting
    list; documented the auth/ vs user/ session-boundary feature split
  - 3. API Conventions: pinned the /api/v1 prefix and dev base URL
    (http://localhost:3000)
  - 5. Roles & Sessions (renumbered to 6): clarified the dual-role model,
    activeRole persistence, fresh-token replacement after addRole, and
    session clearing after password change
  - 7. Process (renumbered to 8): made the spec-kit cycle and its review
    gates explicit
Added sections:
  - 5. Product Rules & Integrations (WhatsApp deep-link contact, no in-app
    chat, inquiries as logged records, advisor request -> full response)
Removed sections: none
Deferred TODOs: none
-->

# ShopSpace Constitution

## 1. Tech Stack (Locked — No Substitutions)

Flutter targeting iOS and Android is the only mobile framework. The
following packages are locked in and MUST NOT be substituted:

- State management: `flutter_bloc` with `equatable`, Cubit-first. Use full
  BLoC only when discrete events genuinely warrant it. No Provider,
  Riverpod, GetX, or `setState`-driven business logic.
- Routing: `go_router`.
- Networking: `dio`.
- Dependency injection: `get_it` + `injectable`.
- Models: `freezed` + `json_serializable`.
- Local persistence: `flutter_secure_storage` for tokens,
  `shared_preferences` for non-sensitive prefs (e.g. last-picked locale,
  last-used `activeRole`).
- Images: `image_picker` for listing photos, `cached_network_image` for
  display.
- External links: `url_launcher` (WhatsApp deep link, phone/mail fallback).
- Google Sign-In: `google_sign_in` (obtains the ID token the backend
  expects at `/auth/google` and `/users/me/link-google`).
- Forms/validation: manual `Form`/`TextFormField` + custom validators. No
  external form-validation package.
- Responsive/adaptive: `flutter_screenutil` for proportional scaling of
  fonts, padding, and widget sizes against the Figma reference frame,
  COMBINED with Material 3 window-size-class breakpoints (compact <600dp,
  medium 600–839dp, expanded ≥840dp) for layout/structure switching
  (single vs two pane, bottom nav vs nav rail). These are two different
  jobs, not redundant tools: screenutil never decides layout structure,
  and breakpoints never scale individual values. Use the hand-rolled
  `AppAdaptiveShell` (Material `NavigationBar`/`NavigationRail`) for the
  nav-rail/bottom-nav shell pattern — `flutter_adaptive_scaffold` is NOT
  used: it is discontinued upstream (deprecated Feb 2025, archived
  flutter/flutter#162965) and was replaced by approved decision D1
  (2026-08-05).
- Environment config: `--dart-define` + a `lib/core/env/` config class
  (dev/staging/prod base URLs).
- Localization: English + Arabic with full RTL support via
  `easy_localization` or `intl`/`flutter_localizations`, with ARB/JSON
  files under `core/localization/`. No hardcoded user-facing strings
  anywhere, from the first line of code — not retrofitted later.
- Testing: `bloc_test`, `mocktail`, and `integration_test` (see §7).

## 2. Architecture (Two Layers Only — No Domain Layer)

Feature-first folders under `lib/features/<feature>/`, each containing
exactly:

- `data/` — datasources (talk to `dio`) and models (freezed). The SAME
  models are reused unchanged across data → repository → presentation;
  there are no separate domain entities.
- `repository/` — an abstract interface plus one implementation.
  Presentation depends only on the interface (injected via `get_it`),
  never the implementation directly.
- `presentation/` — screens, widgets, cubit.

Hard rules:

- No `domain/` folder, no entity classes, no standalone use-case
  classes. A repository interface method IS the use case.
- Cubits MUST call only the repository interface — never `dio` or a
  datasource directly.
- Cross-feature reuse (e.g., two screens that both add a user role)
  happens by injecting the same repository into both Cubits — never by
  duplicating logic or reaching into another feature's internals.
- `core/` holds only cross-cutting concerns (network client, router,
  theme, responsive, localization, env config, storage, error mapping,
  shared widgets, DI setup, utils) — never feature-specific logic.
- `auth/` and `user/` are separate features by session boundary: `auth/`
  owns the unauthenticated flows (signup, login, OTP, password reset) and
  the token lifecycle; `user/` owns everything behind a valid session
  (profile, roles, password change, account deletion).

## 3. API Conventions

- All endpoints live under `/api/v1` (dev base URL:
  `http://localhost:3000`).
- All backend responses follow the envelope `{ message, status, data }`.
  This is unwrapped once, centrally in the dio layer. No feature
  re-implements envelope parsing.
- Non-2xx responses map to typed `Failure` classes in `core/errors/`.
  Raw exceptions MUST NOT reach the UI.
- Authorization: `Bearer <accessToken>` is attached automatically to
  authenticated requests via a dio interceptor.
- On 401: attempt exactly one silent token refresh, retry the original
  request once, then force logout on continued failure.
- When a backend endpoint is not finalized, build the repository
  interface and Cubit against the expected/documented contract, working
  against a mock/stub datasource rather than blocking. Do not wait for
  the real API to exist before writing the feature.

## 4. Design Source (Figma via Composio MCP)

- The Figma file is the single source of truth for colors, typography,
  spacing, radii, and elevation. NEVER invent these values.
- Design tokens are pulled once (Phase 0), centralized in `core/theme/`,
  and reused everywhere — not re-pulled per screen.
- Screen-specific Figma frames are pulled at the start of work on that
  screen/phase, not all upfront.
- If a needed state (error/empty/loading) has no corresponding Figma
  frame, infer something visually consistent with the existing token set
  and flag the gap — never invent an unrelated style.

## 5. Product Rules & Integrations

- Landlord–tenant contact is a WhatsApp deep link only
  (`https://wa.me/<phone>` with a prefilled message, opened via
  `url_launcher` with dialer/SMS fallback). There is no in-app chat.
- Every landlord contact is recorded as an Inquiry (a logged record), not
  a chat thread.
- Advisor chat is strictly request → full response; no token streaming.
- Signup always routes to OTP verification, never straight to login.

## 6. Roles & Sessions

- Every account defaults to the tenant role; the landlord role is added
  on demand through ONE shared repository method
  (`UserRepository.addRole('landlord')` → `POST /users/me/roles`), never
  duplicated per screen/feature.
- Accounts can hold both roles simultaneously; `activeRole` only controls
  which dashboard renders. It is persisted locally so the app reopens on
  the last-used dashboard.
- Permission-sensitive UI MUST read the roles list, never the single
  "active role" selector alone.
- `addRole` returns a fresh token pair — it MUST replace the stored
  tokens immediately (the old access token may not reflect the new
  role's permissions).
- After a successful password change, clear the local session and route
  to login right away; do not wait for a 401.

## 7. Testing & Quality

- Every Cubit has `bloc_test` coverage for its core state transitions
  before its feature is considered done.
- Critical cross-feature user flows get an `integration_test` once the
  phases they span are complete.
- A feature is not done until it has been checked at all three
  breakpoints (compact/medium/expanded) and in both English and Arabic
  (RTL layout).
- `flutter analyze` MUST be clean before any feature is considered
  complete.

## 8. Process

- Work proceeds one phase/spec at a time, in plan order (Phase 0 → 6),
  through the spec-kit cycle with its review gates
  (`/speckit.specify` → `/speckit.plan` → `/speckit.tasks` →
  `/speckit.implement`), unless explicitly told to parallelize.
- This constitution governs HOW anything is built, regardless of which
  phase or spec is being implemented; the phase's own spec governs WHAT
  is built.
- Do not introduce a new package, architectural pattern, or folder
  convention not listed here without flagging it first for approval.
  This constitution changes only deliberately, never by silent drift.

## Governance

This constitution supersedes all other practices. Amendments require
documentation, approval, and a migration plan.

- Versioning: MAJOR for backward-incompatible principle removals or
  redefinitions; MINOR for a new principle or materially expanded
  guidance; PATCH for clarifications, wording, and typo fixes.
- Compliance: every spec, plan, and code review MUST verify adherence to
  this document; any deviation MUST be flagged and approved before merge.

**Version**: 1.2.0 | **Ratified**: 2026-08-05 | **Last Amended**: 2026-08-05
