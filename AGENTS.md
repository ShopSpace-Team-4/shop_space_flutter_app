# AGENTS.md

## Repository status

- **Docs/governance only right now.** There is NO Flutter project yet — no
  `pubspec.yaml`, `lib/`, or tests. The app is created starting in Phase 0 of
  the implementation plan. Do not run `flutter analyze` / `flutter test`
  until the scaffold exists.
- Two files govern all work — read them before implementing anything:
  - `.specify/memory/constitution.md` — non-negotiable engineering rules
    (HOW things are built; versioned v1.0.0).
  - `ShopSpace_Flutter_Implementation_Plan.md` — the phased plan (WHAT is
    built; Phase 0–6, in order). Contains the finalized Auth & User API
    (`/api/v1`, envelope `{ message, status, data }`, dev base
    `http://localhost:3000`).

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
- `flutter_screenutil` scales individual values (`.sp`/`.w`/`.h`/`.r`) against
  the Figma reference frame; Material 3 window size classes decide layout
  structure (compact <600dp, medium 600–839dp, expanded ≥840dp). They have
  DIFFERENT jobs — screenutil never picks layout, breakpoints never scale
  values. App shell uses `flutter_adaptive_scaffold` (bottom nav on compact,
  nav rail on medium/expanded).
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
  responsive, localization, storage, errors, shared widgets, DI) — never
  feature logic.

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
- Permission-sensitive UI reads `roles[]`, never `activeRole` alone.
- `addRole` returns a fresh token pair — MUST replace stored tokens
  immediately. After a successful password change, clear session and go to
  login right away (don't wait for a 401).
- Landlord contact is a WhatsApp deep link (`https://wa.me/<phone>`), not
  in-app chat. Advisor chat is request → full response, no streaming.

## Testing & quality gates (a feature is not done until)

- Every Cubit has `bloc_test` coverage for its core state transitions.
- Critical cross-feature flows get an `integration_test`.
- Checked at all three breakpoints AND in both English and Arabic (RTL).
- `flutter analyze` is clean.

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
