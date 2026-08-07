# Quickstart — Phase 0 (Project Foundation)

Branch `001-phase0-project-foundation` · Spec `spec.md` · Plan `plan.md`

Local run + validation for the Phase 0 foundation (theme, adaptive shell, l10n, network pipeline, storage, env config, DI, router shell).

## Prerequisites

- Flutter stable 3.35.7 at `C:\flutter`. **Use `flutter` for all Dart tooling** — bare `C:\dart-sdk` is a different SDK (AGENTS.md).
- An Android emulator or physical device / iOS simulator (target platforms: iOS + Android; expanded layout verified on 10"+ tablets).
- Backend for network-path checks: `https://shopspace-backend-production.up.railway.app` (SC-006); network-pipeline unit tests stub the base URL locally. Not required to boot the app — offline states are part of the foundation.
- Figma `shop-space-ui` connection via Composio (only needed when re-pulling tokens; not needed for run).

## Environment selection (SC-006)

```powershell
# dev (default; local backend)
flutter run -d <device>

# staging / prod
flutter run --dart-define=APP_ENV=staging -d <device>
flutter run --dart-define=APP_ENV=prod -d <device>
```

Env switch selects `lib/core/env/AppEnv` (base URL, logging on/off). All three must build and run.

## Commands

```powershell
# install deps
flutter pub get

# codegen (freezed / json_serializable / injectable) after model or DI edits
dart run build_runner build --delete-conflicting-outputs

# regenerate l10n (auto on build via "generate: true")
#   manual: flutter gen-l10n

# quality gate (FR-012) — analyze + all tests
dart run tool/quality.dart
```

## Validation scenarios (map to success criteria)

1. **SC-002 / SC-003 — Localization:** switch locale EN ⇄ AR in the app; all chrome strings translate; UI mirrors for Arabic (RTL) with no hardcoded text anywhere.
2. **SC-005 — Design tokens:** placeholder home renders using token-derived styles; spot-check primary/background/heading tokens against Figma.
3. **SC-007 — Adaptive shell:** run at 360dp (compact → bottom nav), 768dp (medium → rail), 1280dp (expanded → extended rail). Resize across classes preserves selected destination and content state; no overflow.
4. **SC-004 — Network pipeline:** with backend down → offline `AppErrorView` with Retry; with backend up and an expired access token → one silent refresh + retry, then clean sign-out redirect on repeated 401.
5. **FR-007 — Token storage:** after a mock sign-in, tokens persist in secure storage across app restarts; clear works.
6. **FR-013 — Tablet:** expanded layout verified on a 10"+ tablet.
7. **Edge cases:** rotation/resize mid-session; cold start offline (no crash); rapid locale toggling.

## File map (what to look at)

| Concern | Location |
|---|---|
| Entrypoint/bootstrap | `lib/main.dart`, `lib/bootstrap.dart` |
| Env config | `lib/core/env/` |
| DI | `lib/core/di/` (injectable) |
| Router shell + guards | `lib/core/router/` |
| Network pipeline | `lib/core/network/`, `lib/core/errors/` |
| Storage | `lib/core/storage/` |
| Design tokens + theme | `lib/core/theme/` |
| Responsive + shell | `lib/core/responsive/` |
| Localization | `lib/core/localization/` |
| Shared states | `lib/core/widgets/` |
| Placeholder screens | `lib/features/*/presentation/` |
| Tests | `test/` (unit/cubit/widget), `test/integration_test/` |

## Notes / known gaps

- `flutter_adaptive_scaffold` is replaced by a hand-rolled `AppAdaptiveShell` (approved deviation D1, see `plan.md` Constitution Check).
- Error/empty state frames are missing in Figma → built consistently from existing tokens and flagged (contracts/design-tokens.md).
- Phase 0 ships no feature UI; only placeholder routes.
