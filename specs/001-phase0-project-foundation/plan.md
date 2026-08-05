# Implementation Plan: Phase 0 — Project Foundation, Design Tokens & Adaptive Shell

**Branch**: `001-phase0-project-foundation` | **Date**: 2026-08-05 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/001-phase0-project-foundation/spec.md`

## Summary

Phase 0 builds the ShopSpace app foundation every later phase renders inside: a single light theme derived from the `shop-space-ui` Figma design tokens, an adaptive app shell that switches a bottom nav bar (phone) for a side rail (medium/large tablet), day-one English + Arabic with full RTL, and one standardized dio network pipeline (auto-attach credentials, unwrap the `{ message, status, data }` envelope once, typed failures, single silent 401 refresh). It also lays secure storage (tokens) + preferences (locale, activeRole), dev/staging/prod build-time environment config, get_it/injectable DI registration, a go_router shell with placeholder routes and auth/role guards, shared breakpoint-aware loading/error/empty states, and local quality scripts. No feature UI is implemented — placeholder screens only.

## Technical Context

**Language/Version**: Dart 3.9.2, Flutter 3.35.7 stable (at `C:\flutter`; bare `C:\dart-sdk` is a different SDK — use the `flutter` tool).

**Primary Dependencies**: `flutter_bloc` 9.1.1 + `equatable` (Cubit-first) · `go_router` **17.2.3** (pin) · `dio` 5.11.0 · `get_it` 9.2.1 + `injectable` 3.0.0 (+ `injectable_generator` **3.0.2**, `build_runner` **2.15.1** — pins) · `freezed` 3.2.5 + `json_serializable` 6.14.1 · `flutter_secure_storage` 10.3.1 · `shared_preferences` 2.5.5 · `flutter_screenutil` 5.9.3 · `flutter_localizations` + `intl` 0.20.3 (gen_l10n) · `image_picker` **1.2.2** (pin) · `cached_network_image` 3.4.1 · `url_launcher` 6.3.2 · `google_sign_in` 7.2.0 (Phase 1 use). `flutter_adaptive_scaffold` is NOT used — see approved decision D1.

**Storage**: `flutter_secure_storage` 10.3.1 for tokens (v10 `AndroidOptions` API to verify, decision D5); `shared_preferences` 2.5.5 (`SharedPreferencesAsync`) for non-sensitive prefs (locale, `activeRole`). Wrapped in `core/storage/`.

**Testing**: `flutter_test` + `bloc_test` 10.0.0 + `mocktail` 1.0.5 (unit/Cubit), `widget_test` (shared state widgets, adaptive shell), `integration_test` (cross-feature flow smoke). Gates: `flutter analyze` clean + all tests green via `dart run tool/quality.dart`. Checked at all three breakpoints × English/Arabic.

**Target Platform**: iOS + Android; expanded layout verified on 10"+ tablets (FR-013).

**Project Type**: mobile-app (Flutter), single app project.

**Performance Goals**: launch renders immediately; session-expiry path (refresh + retry, or clean sign-out) completes within 5s (SC-004); no jank/overflow on rotation/resize.

**Constraints**: offline launch must not crash (shared offline/error state with manual Retry — recovery is user-triggered); zero hardcoded user-facing strings (SC-002); raw exceptions never reach the UI; light theme only, no dark mode (SC-008); tokens never invented — blocked/flagged if unavailable (FR-002).

**Scale/Scope**: 3 size classes (compact/medium/expanded) × 2 locales (en/ar); ~8 placeholder routes (home, auth login/signup/otp/reset, user profile, listings, search, advisor, inquiries); foundation consumed by Phases 1–6.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| # | Constitution principle | Status |
|---|------------------------|--------|
| 1 | Tech stack lock (no substitutions) | ✅ **APPROVED D1 (2026-08-05)**: `flutter_adaptive_scaffold` (locked) is discontinued upstream → replaced with hand-rolled `AppAdaptiveShell`; user-approved. No new package added (see Complexity Tracking). All other packages locked per plan. |
| 2 | Architecture: two layers, no `domain/`; feature-first; `core/` cross-cutting only; `auth/` vs `user/` split | Complies |
| 3 | API conventions: `/api/v1`, dev base `http://localhost:3000`, envelope unwrapped once in dio, typed `Failure`s in `core/errors/`, Bearer via interceptor, exactly one silent 401 refresh then force logout | Complies |
| 4 | Design source: Figma `shop-space-ui` is single source of truth; tokens pulled once into `core/theme/`; missing states → consistent inference + flag, never invented | Complies — connection verified; extraction is node/style-based (D7) |
| 5 | Product rules (WhatsApp contact, Inquiry records, advisor request→full response, signup→OTP) | Noted; enforced in later phases. No conflict. |
| 6 | Roles & sessions: dual-role, `activeRole` persisted, fresh token pair on `addRole`, clear session after password change | Complies (foundation laid in `core/storage/`; behavior consumed in Phase 1) |
| 7 | Testing & quality: Cubit `bloc_test`, 3 breakpoints × 2 locales, `flutter analyze` clean | Complies (FR-012 local scripts) |
| 8 | Process: one phase/spec at a time; new packages/patterns flagged | Complies — D1 approved by user |

**Deviation D1 approved (2026-08-05)** — hand-rolled `AppAdaptiveShell` replaces discontinued `flutter_adaptive_scaffold`; justification in Complexity Tracking below. Everything else is compliant.

### Phase 1 re-check (after data-model + contracts)

- Data model: all entities are plain/freezed Dart under `core/` — no `domain/`, no DTO→entity mapping (constitution §2) → **Complies**.
- Contracts: design tokens centralized in `core/theme/`, Figma-only sourcing, gaps flagged (constitution §Design source) → **Complies**.
- Adaptive shell contract replaces `flutter_adaptive_scaffold` with hand-rolled `AppAdaptiveShell` over Material `NavigationBar`/`NavigationRail` (constitution §Tech stack — locked package) → **APPROVED D1 (2026-08-05, user)**.
- Network pipeline: envelope unwrapped once in dio, typed `Failure`s, single silent 401 refresh then force logout (constitution §API conventions) → **Complies**.
- Storage/roles: `TokenStorage` + session-expiry signals prepared for `addRole`/password-change flows (constitution §Roles & sessions) → **Complies**.
- No new package, pattern, or folder convention introduced beyond the locked list (decision D1 is a *replacement*, not an addition). → **Complies**.

**Outcome**: Phase 1 design holds up; D1 approved. No remaining flagged deviations.

## Project Structure

### Documentation (this feature)

```text
specs/001-phase0-project-foundation/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
lib/
├── main.dart                      # entrypoint; runs bootstrap
├── bootstrap.dart                 # env select (--dart-define) + get_it init + runApp
├── core/
│   ├── env/                       # AppEnv: dev/staging/prod base URLs (dev: http://localhost:3000)
│   ├── di/                        # injectable setup (injectable_init.dart, module registration)
│   ├── router/                    # AppRouter (go_router), route names, auth/role redirect guards
│   ├── network/                   # dio client, interceptors (auth → envelope → retry → logging),
│   │                              #   token provider/refresher, single-flight 401 refresh, session signal
│   ├── errors/                    # typed Failure classes + ErrorMapper (localized friendly messages)
│   ├── storage/                   # TokenStorage (secure) + PreferencesService (prefs)
│   ├── theme/                     # design tokens: AppColors, AppTypography, AppSpacing,
│   │                              #   AppRadius, AppElevation + AppTheme (light only)
│   ├── responsive/                # AppBreakpoint enum + breakpointOf(); AppAdaptiveShell
│   ├── localization/              # l10n.yaml config, app_en.arb, app_ar.arb, LocalizationCubit
│   ├── widgets/                   # shared AppLoadingView, AppErrorView, AppEmptyView (Retry action)
│   └── utils/                     # shared non-feature helpers (e.g. validators)
└── features/
    ├── home/                      # placeholder home screen (renders inside shell)
    ├── auth/                      # placeholder routes (login/signup/otp/reset) — Phase 1
    ├── user/                      # placeholder routes (profile/roles) — Phase 1
    ├── listings/                  # placeholder route — Phase 2+
    ├── search/                    # placeholder route — Phase 3+
    ├── advisor/                   # placeholder route — Phase 4+
    └── inquiries/                 # placeholder route — Phase 5+

test/
├── unit/                          # envelope unwrap, Failure mapping, breakpoint helper,
│                                  #   token/prefs storage wrappers, env config
├── cubit/                         # bloc_test coverage: LocalizationCubit
├── widget/                        # shared state widgets, AppAdaptiveShell at 3 breakpoints × 2 locales
└── integration_test/              # app launch smoke (theme + shell + locale) — cross-feature
tool/
└── quality.dart                   # dart run tool/quality.dart → flutter analyze + flutter test (FR-012)

pubspec.yaml                       # deps + generate: true (gen_l10n)
l10n.yaml                          # arb-dir: lib/core/localization, template: app_en.arb
analysis_options.yaml              # flutter_lints baseline + strict rules
```

**Structure Decision**: single Flutter app project (no monorepo — one deliverable). Feature-first `lib/features/<feature>/` with `data/`/`repository/`/`presentation/` per constitution §2 (created per feature in later phases; Phase 0 keeps placeholder routes only). `core/` holds all cross-cutting concerns; `test/` mirrors unit/cubit/widget; `integration_test/` at repo root. Feature scaffolds (folders with `data/`, `repository/`, `presentation/`) are created as each phase lands — Phase 0 does not invent empty feature folders.

## Complexity Tracking

> Deviation D1 (hand-rolled `AppAdaptiveShell`) was **approved by the user on 2026-08-05**. Justification recorded below for traceability.

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| Replacing locked `flutter_adaptive_scaffold` with a hand-rolled `AppAdaptiveShell` (decision D1) | The locked package is **discontinued upstream** (deprecated Feb 2025, archived — flutter/flutter#162965). Shipping it locks the shell to an unmaintained pre-1.0 dependency that can break with future Flutter releases. | Pinning `flutter_adaptive_scaffold` 0.3.3+1 and using it as-is keeps the letter of the lock but ships a dead dependency. Hand-rolling is ~60 lines over Material's built-in `NavigationBar`/`NavigationRail`, switched by our own breakpoint helper — zero new packages, fully testable, no maintenance risk. |
