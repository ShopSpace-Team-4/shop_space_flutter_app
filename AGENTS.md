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
    (HOW things are built; versioned v2.1.0).
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
- Feature APIs that aren't finalized (listings, search, advisor):
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
- **Every UI component MUST be responsive.** See "Responsive UI" below.
- Localization: English + Arabic, full RTL. No hardcoded user-facing strings,
  ever — externalize from the first line of code.

## Responsive UI

- **Every UI component must be responsive** — this is a hard rule, not a
  recommendation. There is no such thing as a fixed, unscaled UI widget.
- Scale every size, spacing, radius, icon, and font with `flutter_screenutil`
  against the Figma reference frame (375×812): `.h` (height), `.w` (width),
  `.sp` (font size, text-aware), `.r` (uniform/radius scale).
- **Use `.sp` for fonts** — prefer scaling text via the theme (`AppTypography`
  getters already apply `.sp`) over ad-hoc `fontSize` literals.
- **Use flex layout widgets** (`Expanded`, `Flexible`, `Spacer`, `Row`,
  `Column`, `Wrap`) for structure so content flows and never overflows —
  screenutil scales values, flex widgets pick layout within the available
  space. Never hard-code `double.infinity`-free assumptions about available
  width/height.
- **Never use raw pixel literals in `build`** (e.g. `SizedBox(height: 48)`).
  Use `48.h`, `24.w`, `16.sp`, `10.r` (or a theme token scaled with the same
  suffix). Bare numbers inside `Icon(size:)`, `EdgeInsets`, `SizedBox`,
  `Container` dimensions, `BorderRadius`, and `TextStyle(fontSize:)` are a
  code smell — flag and fix them.
- Constants that cannot scale (e.g. `BorderSide(width: 1)`, pill radii like
  `9999`, `strokeWidth`, shadow blur/elevation) are the only allowed exception
  and MUST be deliberate.
- Breakpoints (`window_size.dart`) still choose layout structure only —
  they never scale values, and screenutil never chooses structure.

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

- Landlord contact is a WhatsApp deep link read straight from the listing
  (`listing.whatsappLink`, `https://wa.me/<phone>`), not in-app chat. The
  tenant button launches it directly with a localized prefilled message and an
  `sms:`/`tel:` fallback. **No contact is recorded** — no Inquiry entity.
- Advisor chat is request → full response, no streaming.
- Signup always routes to OTP verification, never straight to login.

## Quality gate (analyze only)

- **The test suite has been removed (approved 2026-08-06).** Do not write new
  unit/cubit/widget/integration tests; ship features without test files. This
  is the permanent default.
- The gate is `dart run tool/quality.dart` → `flutter analyze` only; it must
  stay clean on every task.
- Checked at all three breakpoints AND in both English and Arabic (RTL).
- Responsiveness is part of the quality gate: any new or edited widget must
  scale every value with screenutil and use flex layout widgets (see
  "Responsive UI"). A widget with raw pixel literals in `build` is a lint
  failure equivalent.

## Toolchain gotchas

- Flutter is at `C:\flutter`. Bare `dart` on PATH is `C:\dart-sdk` — a
  DIFFERENT SDK from the Flutter-bundled one (used by opencode's LSP at
  `C:\flutter\bin\cache\dart-sdk\bin\dart.exe`). Prefer `flutter` for Dart
  tooling; version drift between the two is possible.
- `freezed` / `injectable` / `json_serializable` are generated: after adding
  or editing models/DI, run `dart run build_runner build -d`. `flutter analyze`
  will fail on stale generated files.
- Env config: `.env` file loaded via `flutter_dotenv` (`lib/core/env/` maps
  `APP_ENV` → dev/staging/prod). `.env` is git-ignored; copy `.env.example` to
  `.env` and adjust. It is bundled as a Flutter asset, so a change needs a full
  `flutter run` re-run, NOT a hot reload. Missing/empty `.env` is tolerated —
  the app falls back to dev defaults (T026).
- **Google Sign-In REQUIRED key — Android has no `google-services.json`.** To
  make Google sign-in work on Android you MUST set the web client ID as
  `serverClientId`:
  `GOOGLE_SERVER_CLIENT_ID=246506176135-fajj9l424b8rp5f5d6sum2rr7bfdrpoq`
  in `.env` (iOS client ID, once provisioned, via
  `GOOGLE_IOS_CLIENT_ID=<ios client id>`). Without it the app still builds and
  runs (T026), but Google sign-in fails at runtime — the dev console logs a
  `ShopSpace.auth.google` WARNING banner naming the missing key. All run
  commands in the quickstarts are plain `flutter run`; `.env` carries the
  config.
- Localization files: ARB/JSON under `core/localization/`.
