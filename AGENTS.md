# AGENTS.md

## Repository status

- **Flutter scaffold exists.** Phase 0 (project foundation) is complete:
  `pubspec.yaml`, `lib/` (feature-first layout + `core/`). The `test/` tree
  has been removed; the quality gate is `flutter analyze` only. See
  `specs/001-phase0-project-foundation/tasks.md` for Phase 0 status.
- Quality gate: `dart run tool/quality.dart` runs `flutter analyze` (analyze
  only — the test suite has been removed) and exits non-zero on any failure.
- Two files govern all work — read them before implementing anything:
  - `.specify/memory/constitution.md` — non-negotiable engineering rules
    (HOW things are built; versioned v1.2.0).
  - `ShopSpace_Flutter_Implementation_Plan.md` — the phased plan (WHAT is
    built; Phase 0–6, in order). Contains the finalized Auth & User API
    (`/api/v1`, envelope `{ message, status, data }`, base
    `https://shopspace-backend-production.up.railway.app` for dev/staging/prod).

## Process

- Work one phase/spec at a time, in plan order (0 → 6). Use the spec-kit
  cycle with its review gates: `/speckit.specify` → `/speckit.plan` →
  `/speckit.tasks` → `/speckit.implement`. Only parallelize if explicitly told.
- Do NOT introduce a package, architectural pattern, or folder convention
  beyond the locked list below without flagging it for approval first.
- Feature APIs that aren't finalized (listings, search, advisor, inquiries):
  build the repository interface + Cubit against the expected contract with a
  mock/stub datasource. Never block on the real backend.

## Tech stack (locked — no substitutions)

- `flutter_bloc` — Cubit-first; full BLoC only when discrete events warrant it.
  No Provider / Riverpod / GetX / `setState` business logic.
- `go_router` · `dio` · `get_it` + `injectable` · `freezed` + `json_serializable`.
- Persistence: `flutter_secure_storage` (tokens) · `shared_preferences`
  (non-sensitive prefs like locale, `activeRole`). Images: `image_picker` +
  `cached_network_image`. Links: `url_launcher`. Sign-in: `google_sign_in`
  (ID token for `/auth/google`). Forms: manual `Form` + custom validators —
  NO external form-validation package.
- `flutter_screenutil` scales individual values (`.sp`/`.w`/`.h`/`.r`) against
  the Figma reference frame; Material 3 window size classes decide layout
  structure (compact <600dp, medium 600–839dp, expanded ≥840dp). They have
  DIFFERENT jobs — screenutil never picks layout, breakpoints never scale
  values. App shell uses the hand-rolled `AppAdaptiveShell` (bottom nav on
  compact, nav rail on medium/expanded) — `flutter_adaptive_scaffold` is
  discontinued upstream and is NOT used (approved decision D1).
- Localization: English + Arabic, full RTL. No hardcoded user-facing strings,
  ever — externalize from the first line of code.

## Architecture

- Feature-first: `lib/features/<feature>/data/`, `repository/`,
  `presentation/`. Exactly these — **no `domain/`, no entities, no standalone
  use-case classes.** A repository interface method IS the use case.
- `data/`: datasources (talk to dio) + freezed models. The SAME models flow
  unchanged into `repository/` and `presentation/` — no DTO→entity mapping.
- `repository/`: abstract interface + one impl. Cubits depend only on the
  interface (injected via get_it), never the impl, never a datasource, never
  dio directly.
- Cross-feature reuse (e.g. "List a shop" and "Become a Landlord" both adding
  a role) = inject the same repository into both Cubits. Never duplicate logic
  or reach into another feature's internals.
- `core/` holds only cross-cutting concerns (network, router, theme,
  responsive, localization, storage, errors, shared widgets, DI,
  env config) — never feature logic.
- `auth/` and `user/` are separate features by session boundary: `auth/`
  owns unauthenticated flows (signup, login, OTP, password reset) + token
  lifecycle; `user/` owns everything behind a valid session (profile,
  roles, password change, account deletion).

## API conventions

- Envelope `{ message, status, data }` is unwrapped ONCE in the dio layer.
  Features never parse the envelope.
- Non-2xx → typed `Failure` classes in `core/errors/`. Raw exceptions must
  not reach the UI.
- Bearer token attached via dio interceptor. On 401: exactly ONE silent
  refresh, retry once, then force logout.

## Design source (Figma via Composio MCP)

- Figma (`shop-space-ui`) is the single source of truth for colors, type,
  spacing, radii, elevation — never invent values.
- Pull tokens once → `core/theme/`. Reuse everywhere; don't re-pull per
  screen. Pull screen-specific frames at the START of that screen's work.
- Missing error/empty/loading frames: build something consistent with existing
  tokens and flag the gap — don't invent an unrelated style.

## Roles & sessions

- Accounts default to tenant; landlord is added via ONE shared
  `UserRepository.addRole('landlord')` (→ `POST /users/me/roles`). Never
  duplicate per screen/feature.
- Accounts can hold both roles; `activeRole` only picks which dashboard
  renders and is persisted (`shared_preferences`) so the app reopens on
  the last-used dashboard.
- Permission-sensitive UI reads `roles[]`, never `activeRole` alone.
- `addRole` returns a fresh token pair — MUST replace stored tokens
  immediately (old access token may not carry the new role's
  permissions). After a successful password change, clear session and go
  to login right away (don't wait for a 401).

## Product rules

- Landlord contact is a WhatsApp deep link (`https://wa.me/<phone>`), not
  in-app chat; every contact is recorded as an Inquiry, not a chat thread.
- Advisor chat is request → full response, no streaming.
- Signup always routes to OTP verification, never straight to login.

## Quality gate (analyze only)

- **The test suite has been removed (approved 2026-08-06).** Do not write new
  unit/cubit/widget/integration tests; ship features without test files. This
  is the permanent default.
- The gate is `dart run tool/quality.dart` → `flutter analyze` only; it must
  stay clean on every task.
- Checked at all three breakpoints AND in both English and Arabic (RTL).

## Toolchain gotchas

- Flutter is at `C:\flutter`. Bare `dart` on PATH is `C:\dart-sdk` — a
  DIFFERENT SDK from the Flutter-bundled one (used by opencode's LSP at
  `C:\flutter\bin\cache\dart-sdk\bin\dart.exe`). Prefer `flutter` for Dart
  tooling; version drift between the two is possible.
- `freezed` / `injectable` / `json_serializable` are generated: after adding
  or editing models/DI, run `dart run build_runner build -d`. `flutter analyze`
  will fail on stale generated files.
- Env config: `--dart-define` + `lib/core/env/` (dev/staging/prod).
- Localization files: ARB/JSON under `core/localization/`.
