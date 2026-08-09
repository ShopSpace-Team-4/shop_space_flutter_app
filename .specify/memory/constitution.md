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
  - 3. API Conventions: pinned the /api/v1 prefix and base URL
    (https://shopspace-backend-production.up.railway.app for all envs)
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

<!--
CONSTITUTION SYNC IMPACT REPORT
Version change: 2.0.0 -> 2.1.0 (MINOR)
Modified principles:
  - 1. Tech Stack: clarified that the locked responsive stack is
    MANDATORY for every UI component, not advisory — flutter_screenutil
    scales every size/spacing/radius/icon/font and Material 3 size
    classes pick layout structure.
Added sections:
  - 5. Responsive UI (renumbered 6): hard rule that every UI component
    scales with screenutil (.h/.w/.sp/.r) AND lays out with flex widgets
    (Expanded/Flexible/Spacer/Row/Column/Wrap). Theme tokens converted
    from const values to scaling getters so typography/spacing/radius
    auto-scale; raw pixel literals in build are banned. Layout structure
    stays the exclusive job of breakpoints; screenutil never picks layout.
Removed sections: none
Deferred TODOs: none
-->

<!--
CONSTITUTION SYNC IMPACT REPORT
Version change: 1.2.0 -> 2.0.0 (MAJOR)
Modified principles:
  - 7. Testing & Quality: removed the mandatory per-Cubit `bloc_test`,
    per-screen widget-test, and cross-feature `integration_test`
    requirements (approved amendment, 2026-08-06). New work ships without
    new tests; the existing test suite must remain green and
    `flutter analyze` must stay clean. The manual breakpoint/RTL check is
    unchanged.
Added sections: none
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
  and breakpoints never scale individual values. Responsiveness is a
  MANDATORY property of every UI component, not an afterthought — see §5.
  Use the hand-rolled
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
- Testing: `bloc_test`, `mocktail`, and `integration_test` (see §8).

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

- All endpoints live under `/api/v1` (base URL:
  `https://shopspace-backend-production.up.railway.app` for dev/staging/prod).
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

## 5. Responsive UI (Mandatory)

- Every UI component MUST be responsive. There is no such thing as a fixed,
  unscaled UI widget; responsiveness is a property of each widget, not a
  per-screen afterthought.
- Every size, spacing, radius, icon, and font MUST scale with
  `flutter_screenutil` against the Figma reference frame (375×812): `.h`
  (height), `.w` (width), `.sp` (font size, text-aware), `.r` (uniform/
  radius scale).
- Use `.sp` for fonts — scale text via the theme (`AppTypography` getters
  already apply `.sp`), never via raw `fontSize` literals.
- Layout structure MUST be built with flex widgets (`Expanded`, `Flexible`,
  `Spacer`, `Row`, `Column`, `Wrap`) so content flows and never overflows.
  screenutil scales values; flex widgets pick layout inside the available
  space. Never assume a fixed available width/height.
- Raw pixel literals in `build` (e.g. `SizedBox(height: 48)`, `Icon(size: 20)`,
  bare `EdgeInsets`, bare `fontSize`) are a lint failure equivalent — use
  `48.h`, `20.w`, `16.sp`, `10.r`, or a theme token scaled with the same
  suffix.
- The only allowed exceptions are constants that cannot scale
  (`BorderSide(width: 1)`, pill/circular radii like `9999`, `strokeWidth`,
  shadow blur/elevation) and they MUST be deliberate.
- Breakpoints choose layout structure ONLY; screenutil scales values ONLY.
  The two never trade jobs.
- Compliance: the quality gate checks that any new or edited widget scales
  every value with screenutil and uses flex widgets. A widget with raw
  pixel literals in `build` fails the gate.

## 6. Product Rules & Integrations

- Landlord–tenant contact is a WhatsApp deep link only, read straight from
  the listing (`listing.whatsappLink`, `https://wa.me/<phone>` with a
  localized prefilled message appended, opened via `url_launcher` with
  dialer/SMS fallback). There is no in-app chat.
- No contact is ever recorded — there is no Inquiry entity or inquiries
  endpoint (removed 2026-08-09).
- Advisor chat is strictly request → full response; no token streaming.
- Signup always routes to OTP verification, never straight to login.

## 7. Roles & Sessions

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

## 8. Testing & Quality

- **New work ships WITHOUT new tests (approved amendment, 2026-08-06).**
  Do not write unit/cubit/widget/integration tests for new features.
- The existing test suite stays in place and MUST remain green: fix
  failures caused by refactors or API drift; never delete existing
  coverage.
- Critical cross-feature flows are verified by manual smoke testing, not
  by new automated `integration_test`s.
- A feature is not done until it has been checked at all three
  breakpoints (compact/medium/expanded) and in both English and Arabic
  (RTL layout).
- Responsiveness is part of the quality gate (see §5): every new or edited
  widget must scale all values with screenutil and use flex widgets for
  layout. Raw pixel literals in `build` are a lint failure equivalent.
- `flutter analyze` MUST be clean before any feature is considered
  complete.

## 9. Process

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

**Version**: 2.1.0 | **Ratified**: 2026-08-05 | **Last Amended**: 2026-08-08
