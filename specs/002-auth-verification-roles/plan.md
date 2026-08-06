# Implementation Plan: Auth Verification & Roles

**Branch**: `002-auth-verification-roles` | **Date**: 2026-08-06 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/002-auth-verification-roles/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command; its definition describes the execution workflow.

## Summary

Deliver Phase 1 of ShopSpace: full authentication (signup → OTP verification, login, Google
sign-in, forgot/reset password) in `lib/features/auth/` and session-scoped account & role
management (profile, change password, roles, activeRole switch, become landlord) in
`lib/features/user/`. Both features build on the Phase 0 network pipeline (envelope unwrapped in
dio, single silent 401 refresh → force logout via `SessionController`), router guards
(`SessionReader`/`AuthGuard`), token storage, typed failures, and the Figma-derived design tokens.
Auth flow contract: signup always routes to OTP, Google sign-in sends an ID token to
`POST /auth/google`, `addRole` returns a fresh token pair that replaces stored tokens immediately,
and permission-sensitive UI reads the full `roles[]` set (never `activeRole` alone). UI is
responsive at all three Material breakpoints and localized English + Arabic (RTL), with no
hardcoded user-facing strings.

## Technical Context

**Language/Version**: Dart 3.9.2 / Flutter 3.35.7 stable (`C:\flutter`; the bare `C:\dart-sdk` on
PATH is a different SDK and is only used by opencode's LSP — use `flutter` for all tooling).

**Primary Dependencies** (locked stack, no substitutions):
- `flutter_bloc` 9.1.1 (+ `equatable`) — Cubit-first; full BLoC only if discrete events warrant.
- `go_router` **17.2.3** (pin) — route wiring + `AuthGuard`; `SessionReader` seam.
- `dio` 5.11.0 — HTTP; Phase 0 interceptors reused as-is.
- `get_it` 9.2.1 + `injectable` 3.0.0 — DI (repositories registered against interfaces).
- `freezed` 3.2.5 + `json_serializable` — auth/user request & response models.
- `flutter_secure_storage` 10.3.1 — access/refresh tokens.
- `shared_preferences` 2.5.5 — `activeRole` (last-used dashboard) + locale.
- `google_sign_in` **7.2.0** — Google sign-in (ID token → `POST /auth/google`); singleton init at
  bootstrap (D1).
- `flutter_screenutil` 5.9.3 — scales values (`.sp`/`.w`/`.h`/`.r`); Material 3 window size
  classes (compact <600dp / medium 600–839dp / expanded ≥840dp) decide layout structure only.
- `intl` 0.20.3 + `flutter_localizations` (`generate: true`, ARB/JSON under `core/localization/`).
- Tests: `bloc_test` + `mocktail` (Cubits), `integration_test` (cross-feature flows).
- `image_picker`/`cached_network_image`/`url_launcher` available for later profile/contact needs
  (avatar upload is out of Phase 1 scope).

**Storage**: `flutter_secure_storage` for tokens (keys `auth.accessToken` / `auth.refreshToken`,
namespace `shop_space` / `accountName com.shopspace.shopspace`, as defined in Phase 0
`token_storage.dart`); `shared_preferences` for `activeRole` and locale. No local database.

**Testing**: `dart run tool/quality.dart` (runs `flutter analyze` + full `flutter test` incl.
`test/integration_test/`, exits non-zero on failure). Every auth/user Cubit gets `bloc_test`
coverage of its core transitions; a critical cross-feature flow (signup → verify → login → switch
role) gets an `integration_test`. Widgets checked at all three breakpoints and in EN + AR (RTL).

**Target Platform**: iOS + Android (mobile-first Flutter app). Layout adaptive compact/medium/
expanded via `AppAdaptiveShell`; auth screens are compact-first with medium/expanded centering.

**Project Type**: mobile-app (Flutter).

**Performance Goals**: Auth transitions render without jank (≤60 fps); OTP resend countdown driven
by a single 1s `Timer` owned by the widget (disposed with it); no per-frame rebuilds beyond the
countdown tick; `/users/me` hydration on launch is non-blocking (D3).

**Constraints**:
- Signup always routes to OTP verification, never straight to login (product rule).
- Envelope `{ message, status, data }` unwrapped exactly once, in the dio layer — features never
  parse it. Non-2xx → typed `Failure` (`core/errors/`), never raw exceptions to the UI.
- Exactly ONE silent 401 refresh, retry once, then force logout (reuse `SessionController`
  `sessionExpired` stream).
- `addRole` replaces the stored token pair immediately; after a successful password change, clear
  the session and go to login right away (don't wait for a 401).
- Google collision (email exists as password account) → localized message guiding to password
  sign-in; never auto-links.
- No hardcoded user-facing strings; full Arabic RTL. Design tokens from Figma only (see D5 for
  flagged gaps: no OTP/reset/profile frames; Sign-up frame omits password — intentional deviation
  per the finalized API).

**Scale/Scope**: 9 auth/user API endpoints (`/auth/signup|login|google|verify|resend-otp|logout|
refresh-token|forgot-password|reset-password`; `/users/me`, `/users/me/password`,
`/users/me/active-role`, `/users/me/roles`). Screens: Login, Sign up, OTP, Forgot password, Reset
password, Profile, Change password, Become landlord (role switch surface). Two repositories
(`AuthRepository`, `UserRepository`) + datasources + ~8 Cubits.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| # | Constitution rule | Status |
|---|---|---|
| 1 | Feature-first: `features/<feature>/{data,repository,presentation}`; **no `domain/`, no entities, no standalone use-case classes** (repository method = use case) | PASS — `auth/` + `user/` exactly this shape |
| 2 | Same freezed models flow unchanged data → repository → presentation (no DTO mapping) | PASS — single model set per feature |
| 3 | Cubits depend on repository **interfaces** via get_it; never impl/datasource/dio directly | PASS — abstract repos registered in DI |
| 4 | Cross-feature reuse (Become a Landlord adds a role) injects the same `UserRepository` | PASS — one `UserRepository`, no duplicated role logic |
| 5 | Envelope unwrapped once in dio; typed `Failure` only to UI; raw exceptions never reach UI | PASS — reuses Phase 0 pipeline untouched |
| 6 | 401 → exactly one silent refresh, retry once, force logout | PASS — reuses `SessionController.sessionExpired` |
| 7 | Dual-role: default `tenant`; `landlord` via one shared `UserRepository.addRole('landlord')`; `activeRole` persisted (`shared_preferences`) and only picks the dashboard; permission UI reads `roles[]` | PASS — by design (D6) |
| 8 | `addRole` returns fresh tokens → replace stored pair immediately | PASS — by design |
| 9 | Password change → clear session, go to login immediately | PASS — by design |
| 10 | Signup always routes to OTP, never login; Google sign-in uses ID token for `/auth/google` | PASS — by design (D1/D2) |
| 11 | Landlord contact = WhatsApp deep link + Inquiry (not in-app chat) | N/A Phase 1 — later feature; no contact surfaces introduced |
| 12 | No package/pattern/folder beyond the locked list without approval | PASS — google_sign_in 7.2.0 was already on the Phase 0 locked list |
| 13 | Design tokens only from Figma; missing frames built consistently + flagged | PASS — D5 documents extraction + 2 flagged gaps |
| 14 | Localization: EN + AR full RTL; no hardcoded strings, ever | PASS — by design |
| 15 | Every Cubit `bloc_test`-covered; critical flow has `integration_test`; checked at 3 breakpoints × 2 languages; `flutter analyze` clean | PASS — by plan |

No violations → Complexity Tracking below is intentionally empty.

## Project Structure

### Documentation (this feature)

```text
specs/002-auth-verification-roles/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command) — D1–D6 decisions
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
│   ├── auth-api.md              # endpoint × payload × typed failure contract
│   ├── google-signin-flow.md    # singleton init + idToken flow + collision handling
│   ├── otp-validation.md        # OTP semantics: cooldown, 5-attempt cap, reset
│   └── role-session.md          # roles[], activeRole, token replacement rules
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

Single Flutter project (matches Phase 0 layout; Option 1 below, actual tree):

```text
lib/
├── main.dart                      # bootstrap: init GoogleSignIn, DI, router
├── app.dart
├── core/                          # Phase 0 — unchanged
│   ├── network/                   # dio_client, interceptors, session_controller
│   ├── router/                    # app_router (placeholder auth routes → real screens)
│   ├── storage/                   # token_storage, preferences_service
│   ├── errors/                    # failures (typed Failure surface)
│   ├── theme/                     # AppColors/Typography/Spacing/Radius/Elevation
│   ├── localization/              # ARB + generated AppLocalizations
│   ├── responsive/                # window-size-class helpers
│   └── widgets/                   # shared AppLoadingView/AppErrorView/AppEmptyView
└── features/
    ├── auth/                      # Phase 1 — unauthenticated flows + token lifecycle
    │   ├── data/
    │   │   ├── models/            # AuthTokens, SignupRequest, LoginRequest, OtpRequest,
    │   │   │                      #   GoogleSignInRequest, ResetPasswordRequest, ... (freezed)
    │   │   └── auth_datasource.dart        # dio calls to /auth/*
    │   ├── repository/
    │   │   ├── auth_repository.dart         # abstract interface (methods = use cases)
    │   │   └── auth_repository_impl.dart
    │   ├── google/                # AuthGoogleService (GoogleSignIn singleton wrapper)
    │   └── presentation/
    │       ├── cubits/            # auth_session, login, signup, otp, forgot_password,
    │       │                      #   reset_password, google_sign_in
    │       ├── widgets/           # auth_segmented_toggle, labeled_input, social_button,
    │       │                      #   otp_input
    │       └── screens/           # login, signup, otp, forgot_password, reset_password
    └── user/                      # Phase 1 — everything behind a valid session
        ├── data/
        │   ├── models/            # User (roles[], activeRole, isVerified), RoleChange,
        │   │                      #   PasswordChange, ActiveRoleUpdate (freezed)
        │   └── user_datasource.dart          # dio calls to /users/me*
        ├── repository/
        │   ├── user_repository.dart
        │   └── user_repository_impl.dart
        └── presentation/
            ├── cubits/            # profile, change_password, roles/active_role
            └── screens/           # profile, change_password, become_landlord (role switch)

test/
├── features/
│   ├── auth/                      # datasource tests (mocktail), repo tests, per-Cubit bloc_test
│   └── user/                      # datasource/repo/cubit tests
├── widget/                        # auth + user widget tests (3 breakpoints, EN/AR)
├── integration_test/              # auth_flow_test.dart: signup→verify→login→switch role
└── helpers/                       # mock repositories, pumps, l10n fixtures
```

**Structure Decision**: Single Flutter project (as established in Phase 0 — no new packages or
monorepo). Feature boundary follows the session rule: `auth/` owns unauthenticated flows + token
lifecycle; `user/` owns everything behind a valid session. `AuthRepository` and `UserRepository`
are each an abstract interface + one impl, injected via get_it against the interface, Cubits never
see datasources or dio. `AuthGoogleService` is a thin wrapper around the `GoogleSignIn` singleton
so Cubits remain mocktail-testable (D1). This preserves the Phase 0 folder conventions exactly —
no new top-level directories are introduced.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

No violations recorded; table intentionally left empty.
