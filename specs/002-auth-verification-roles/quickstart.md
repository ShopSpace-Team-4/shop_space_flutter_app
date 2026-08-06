# Quickstart — Phase 1 (Auth Verification & Roles)

Branch `002-auth-verification-roles` · Spec `spec.md` · Plan `plan.md`

Scenarios for running, testing, and extending the Phase 1 auth + user/role features. Read
`../001-phase0-project-foundation/quickstart.md` first for the Phase 0 baseline (bootstrap, DI,
router, network pipeline).

## Run

```powershell
# Flutter at C:\flutter (bare C:\dart-sdk on PATH is a DIFFERENT SDK — prefer `flutter`)
flutter pub get
dart run build_runner build -d          # after adding/editing freezed / injectable / json_serializable
flutter run --dart-define=ENV=dev        # dev base: http://localhost:3000
```

Quality gate (must stay green; exits non-zero on failure):

```powershell
dart run tool/quality.dart               # flutter analyze + full flutter test (incl. integration_test)
```

## Key files

| Concern | Location |
|---|---|
| Auth datasource / models | `lib/features/auth/data/` |
| Auth repository (interface + impl) | `lib/features/auth/repository/` |
| Google wrapper seam | `lib/features/auth/google/auth_google_service.dart` |
| Auth screens/cubits | `lib/features/auth/presentation/` |
| User datasource / models / repo | `lib/features/user/data|repository/` |
| User screens/cubits | `lib/features/user/presentation/` |
| Session authority (was static stub) | `lib/features/auth/presentation/cubits/auth_session_cubit.dart` |
| Router guards | `lib/core/router/route_guards.dart` (now consumes `AuthSessionCubit`) |
| Token storage | `lib/core/storage/token_storage.dart` (keys `auth.accessToken`/`auth.refreshToken`) |
| API + role contracts | `specs/002-auth-verification-roles/contracts/` |
| Data model | `specs/002-auth-verification-roles/data-model.md` |

## Core flows (walkthrough)

### 1. Signup → OTP → login

1. `SignupScreen` (first/last name, email, phone, password) → `SignupCubit.signUp(...)`.
   Phone normalized to `+20…` (D4); password ≥8, ≥1 letter + ≥1 digit (Q2).
2. `POST /auth/signup` 2xx → navigate to `OtpScreen` with the email prefilled (**never** login).
3. `POST /auth/verify { email, otpCode }` — 6 digits, one real field (D2). Wrong code decrements
   the 5-attempt counter; at 0 the field locks until a resend. `POST /auth/resend-otp` resets the
   counter to 5 and restarts the 60s cooldown (contract `otp-validation.md`).
4. On verified → login screen → `POST /auth/login { email, password }` → `AuthTokens` stored →
   `AuthSessionCubit` authenticated → dashboard shell by `activeRole` (default `tenant`).

### 2. Google sign-in

1. `AuthGoogleService.initialize()` ran once at bootstrap (D1).
2. Tap "Continue with Google" → `authenticate()` → `idToken` → `POST /auth/google`.
3. New account → tokens stored → dashboard. Existing **password** account (409) → localized
   "sign in with your password" message (never auto-link). User cancel → stay on login, no toast.

### 3. Forgot / reset password

1. `POST /auth/forgot-password { email }` → OTP to email → `ResetPasswordScreen`.
2. `POST /auth/reset-password { email, otpCode, newPassword }` (same password rule) → login.

### 4. Become landlord (addRole) — the ordering that matters

1. `UserRepository.addRole('landlord')` → `POST /users/me/roles`.
2. `RoleChangeResponse { tokens, user }` → **write `tokens` to storage first**, then emit `user`
   with `roles: [tenant, landlord]` (constitution §6). Old token may not carry the new role.
3. Switch `activeRole` (`PATCH /users/me/active-role`) to render the landlord dashboard; persisted
   to `shared_preferences` so the app reopens on it.

### 5. Password change & logout

- `PUT /users/me/password` success → clear tokens → `AuthSessionCubit` unauthenticated → `/login`
  immediately (don't wait for a 401).
- Logout → `AuthGoogleService.signOut()` (if Google) → `POST /auth/logout` (best-effort) → clear
  tokens → `/login`.

### 6. Session hydration (cold start)

- `AuthSessionCubit.initialize()`: stored token present → guard unblocks, `GET /users/me`
  hydrates `User` in the background; hydration 401 runs the standard single-refresh-then-logout
  pipeline. No token → `/login` (contract `role-session.md`).

## Testing

```powershell
flutter test test/features/auth test/features/user    # datasource/repo/cubit (mocktail + bloc_test)
flutter test test/widget                             # 3 breakpoints × EN/AR
flutter test test/integration_test                   # signup→verify→login→switch-role flow
```

New typed failures live in `core/errors/failures.dart` (`EmailAlreadyRegistered`, `InvalidOtp`,
`OtpAttemptsExceeded`, `InvalidCredentials`, `EmailNotVerified`, `GoogleSignInCancelled`) and get
l10n keys + `ErrorMapper` entries. Every user-facing string is externalized (EN + AR).

## Gotchas

- `flutter_secure_storage`: keys `auth.accessToken`/`auth.refreshToken`, namespace `shop_space`,
  iOS account `com.shopspace.shopspace` (Phase 0) — keep them.
- Google iOS: reversed-client-ID must be in `CFBundleURLTypes`; Android: pass the web client ID as
  `serverClientId` (no `google-services.json`).
- Never parse the envelope in features; never touch dio outside datasources; never decide
  permissions from `activeRole` alone.
- OTP cooldown: Cubit holds the absolute deadline; the widget's 1s `Timer` dies in `dispose()`.
