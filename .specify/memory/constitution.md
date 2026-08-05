<!--
CONSTITUTION SYNC IMPACT REPORT
Version change: (unratified template) -> 1.0.0
Modified principles: n/a (initial ratification; all seven sections filled
from template placeholders)
Added sections: 1. Tech Stack, 2. Architecture, 3. API Conventions,
4. Design Source, 5. Roles & Sessions, 6. Testing & Quality, 7. Process;
Governance rules filled
Removed sections: none
Deferred TODOs: none
-->

# ShopSpace Constitution

## 1. Tech Stack (Locked — No Substitutions)

Flutter targeting iOS and Android is the only mobile framework. The
following packages are locked in and MUST NOT be substituted:

- State management: `flutter_bloc`, Cubit-first. Use full BLoC only when
  discrete events genuinely warrant it. No Provider, Riverpod, GetX, or
  `setState`-driven business logic.
- Routing: `go_router`.
- Networking: `dio`.
- Dependency injection: `get_it` + `injectable`.
- Models: `freezed` + `json_serializable`.
- Responsive/adaptive: `flutter_screenutil` for proportional scaling of
  fonts, padding, and widget sizes against the Figma reference frame,
  COMBINED with Material 3 window-size-class breakpoints (compact <600dp,
  medium 600–839dp, expanded ≥840dp) for layout/structure switching
  (single vs two pane, bottom nav vs nav rail). These are two different
  jobs, not redundant tools: screenutil never decides layout structure,
  and breakpoints never scale individual values. Use
  `flutter_adaptive_scaffold` for the nav-rail/bottom-nav shell pattern.
- Localization: English + Arabic with full RTL support via
  `easy_localization` or `intl`/`flutter_localizations`. No hardcoded
  user-facing strings anywhere, from the first line of code — not
  retrofitted later.

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
  theme, responsive helpers, storage, error mapping, shared widgets, DI
  setup) — never feature-specific logic.

## 3. API Conventions

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
- Design tokens are pulled once, centralized in `core/theme/`, and reused
  everywhere — not re-pulled per screen.
- Screen-specific Figma frames are pulled at the start of work on that
  screen, not all upfront.
- If a needed state (error/empty/loading) has no corresponding Figma
  frame, infer something visually consistent with the existing token set
  and flag the gap — never invent an unrelated style.

## 5. Roles & Sessions

- Every account defaults to the tenant role; the landlord role is added
  on demand through one shared repository method — never duplicated per
  screen/feature.
- Permission-sensitive UI MUST read the roles list, never the single
  "active role" selector alone.
- A successful role change or password change updates or clears local
  session state immediately, without waiting for a subsequent failed
  request to react.

## 6. Testing & Quality

- Every Cubit has `bloc_test` coverage for its core state transitions
  before its feature is considered done.
- Critical cross-feature user flows get an `integration_test` once the
  phases they span are complete.
- A feature is not done until it has been checked at all three
  breakpoints (compact/medium/expanded) and in both English and Arabic
  (RTL layout).
- `flutter analyze` MUST be clean before any feature is considered
  complete.

## 7. Process

- Work proceeds one phase/spec at a time, in the order given, unless
  explicitly told to parallelize.
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

**Version**: 1.0.0 | **Ratified**: 2026-08-05 | **Last Amended**: 2026-08-05
