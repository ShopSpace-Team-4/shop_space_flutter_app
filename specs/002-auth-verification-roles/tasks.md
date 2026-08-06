---
description: "Task list for Phase 1 — Authentication, Verification & Roles (spec 002)."
---

# Tasks: Phase 1 — Auth, Verification & Account/Role Management

## Input

- `plan.md` — **required** (scope, ordering, file layout)
- `spec.md` — **required** for user stories (US1–US6, acceptance tests mandatory)
- `research.md` — decisions D1–D6 (Google, OTP, session, roles)
- `data-model.md` — **exact model names/fields**; do not rename
- `contracts/auth-api.md`, `contracts/google-signin-flow.md`, `contracts/otp-validation.md`, `contracts/role-session.md`
- `quickstart.md` — run commands, QA gate, session-authority map

## Prerequisites

- Phase 0 complete: `dart run tool/quality.dart` green.
- Read `.specify/memory/constitution.md` first. Its §5/§6 rules are non-negotiable.

## Scope decisions (approved; supersede spec Assumptions where they conflict)

- **Password change (`PUT /users/me/password`) IS in Phase 1** (plan/quickstart §5), even though spec Assumptions place it in Phase 4. Build it in US6; on success it reuses the single session-clearing mechanism (FR-013) and goes straight to `/login` (never waits for a 401).
- **Sign-out surface = a minimal account screen** at `/profile` (email + Change Password + Sign Out). Profile editing and landlord dashboard are later phases. The `/profile` Phase 0 placeholder is replaced now; the nav "Profile" destination gains a working route entry.
- **Google sign-in is its own user story (US4)** with a dedicated `AuthGoogleService`; the Google button appears on Login and Signup.

## Tests

- **Skipped for new work (approved 2026-08-06).** No unit/cubit/widget/
  integration tests are written in this spec — the per-task test clauses
  below were removed accordingly. Existing tests (Phase 0 + T001–T009)
  stay green; fix any failure caused by refactors or API drift.
- QA gate still runs `flutter analyze` + the existing test suite
  (`dart run tool/quality.dart`) before a task closes.
- Manual checks still apply: breakpoints and RTL (see T041).

## Organization

- Stages group dependency-ordered work. Foundation first, then US1 → US2 → US4 → US3 → US5 → US6, then final verification.
- Tasks marked `[P]` are parallelizable (independent files); run in any order. Run `dart run build_runner build -d` once after each stage that touches generated code (freezed/injectable/json_serializable).

## Format

- `- [ ] T### [P] [US#] Description` — exact file paths, no ambiguity. `[P]` only when genuinely parallelizable. The `[US#]` label matches `spec.md` story IDs.

## Environment Facts

- Run commands via `powershell -ExecutionPolicy Bypass -File <script>`; repo root `C:\rich_Sonic\shop_space_flutter_app`.
- **Flutter is at `C:\flutter` (3.35.7 / Dart 3.9.2).** Bare `C:\dart-sdk` on PATH is a DIFFERENT SDK (opencode's LSP) — never use it for tooling; always `flutter …` / `dart run …` from `C:\flutter`.
- After dep edits: `flutter pub get`. After freezed/injectable/json edits: `dart run build_runner build -d`. After ARB edits: `flutter gen-l10n` (l10n auto-generates on build; import `package:flutter_gen/gen_l10n/app_localizations.dart`).
- QA gate: `dart run tool/quality.dart` = `flutter analyze` + the existing test suite; exits non-zero on any failure.
- Dev run: `flutter run --dart-define=ENV=dev`; API base `http://localhost:3000`, path prefix `/api/v1`, envelope `{ message, status, data }` unwrapped exactly once in the dio layer.
- Token storage keys: `auth.accessToken` / `auth.refreshToken` (`flutter_secure_storage`); active-role pref key: `activeRole` (`shared_preferences`).
- Version pins (do NOT bump — newer majors need Flutter ≥3.38 / Dart ≥3.10): `go_router` 17.2.3, `injectable_generator` 3.0.2, `build_runner` 2.15.1, `image_picker` 1.2.2.
- Figma `shop-space-ui` is the design source; pull tokens from `core/theme/`; scale values with `flutter_screenutil` (`.sp/.w/.h/.r`) and pick layout with Material 3 breakpoints (compact <600dp, medium 600–839dp, expanded ≥840dp) via `AppAdaptiveShell`.
- No hardcoded user-facing strings, ever (English + Arabic RTL). Features never parse the envelope, never raise raw `DioException` to UI, never DTO-map.

---

## Stage 1 — Foundation (shared, cross-story)

- [x] T001 [US-] Extend `lib/core/errors/failures.dart` with typed auth Failure variants (each extends the sealed `Failure` with a `messageKey`): `EmailAlreadyRegistered`, `InvalidOtp`, `OtpAttemptsExceeded`, `InvalidCredentials`, `EmailNotVerified`, `GoogleSignInCancelled`, `RateLimited`. Extend `lib/core/errors/error_mapper.dart` so the dio layer maps 4xx auth business codes to these variants (generic `ValidationFailure` stays the fallback for other 4xx).
- [x] T002 [P] [US-] Add EN + AR strings to `lib/core/localization/app_en.arb` and `lib/core/localization/app_ar.arb` for every new failure `messageKey` plus all auth/user screen copy (login, signup, OTP, forgot/reset password, google button, profile/account, change password, sign out, active-role, validation messages per Q2, resend/cooldown, attempts-remaining, locked). Run `flutter gen-l10n`.
- [x] T003 [P] [US-] Create freezed auth models in `lib/features/auth/data/models/` exactly per `data-model.md` §1: `AuthTokens{accessToken, refreshToken}`, `SignupRequest{firstName, lastName, email, phone, password}`, `LoginRequest{email, password}`, `OtpVerificationRequest{email, otpCode}`, `ResendOtpRequest{email}`, `GoogleSignInRequest{idToken}`, `ForgotPasswordRequest{email}`, `ResetPasswordRequest{email, otpCode, newPassword}`, `RefreshTokenRequest{refreshToken}`. Requests are `toJson`-only; `AuthTokens` has `fromJson`+`toJson`. Run `dart run build_runner build -d`.
- [x] T004 [P] [US-] Create freezed user models in `lib/features/user/data/models/` exactly per `data-model.md` §2: `User{id, firstName, lastName, email, phone, roles: List<UserRole>, activeRole: UserRole, isVerified, avatarUrl?}`, `enum UserRole { tenant, landlord }` serialized as `"tenant"`/`"landlord"`, `PasswordChangeRequest{currentPassword, newPassword}`, `ActiveRoleUpdateRequest{role}`, `RoleChangeRequest{role}`, `RoleChangeResponse{tokens: AuthTokens, user: User}`. **Reconcile the role source of truth**: delete the Phase 0 `abstract final class UserRole` in `lib/core/router/route_guards.dart` and import the new enum (guards keep referencing `UserRole.tenant`/`UserRole.landlord`). Run build_runner.
- [x] T005 [P] [US-] Create `AuthDataSource` (abstract) + `AuthDataSourceImpl` in `lib/features/auth/data/auth_datasource.dart`: `signup(SignupRequest)`, `login(LoginRequest)→AuthTokens`, `googleSignIn(GoogleSignInRequest)→AuthTokens`, `verifyOtp(OtpVerificationRequest)`, `resendOtp(ResendOtpRequest)→bool` (reads `data.otpDelivered`), `logout()` (best-effort, `POST /auth/logout`), `refreshToken(RefreshTokenRequest)→AuthTokens`, `forgotPassword(ForgotPasswordRequest)`, `resetPassword(ResetPasswordRequest)`. Paths per `contracts/auth-api.md`. Register in DI (`@injectable`/`@Injectable(as: AuthDataSource)`).
- [x] T006 [P] [US-] Create `UserDataSource` (abstract) + `UserDataSourceImpl` in `lib/features/user/data/user_datasource.dart`: `getProfile()→User` (`GET /users/me`), `changePassword(PasswordChangeRequest)` (`PUT /users/me/password`; 401→`UnauthorizedFailure`, wrong current password→`InvalidCredentials`), `switchActiveRole(ActiveRoleUpdateRequest)→User` (`PATCH /users/me/active-role`), `addRole(RoleChangeRequest)→RoleChangeResponse` (`POST /users/me/roles`). Do NOT build `PUT /users/me` or `link-google` (later phases). Register in DI.
- [x] T007 [P] [US-] Refactor Phase 0 `TokenRefresher` (`lib/core/network/`) to call `AuthDataSource.refreshToken` as the single source for `/auth/refresh-token` (keep the denylist recursion guard). Keep `test/unit/session_refresh_test.dart` green.
- [x] T008 [P] [US-] Create `AuthRepository` (abstract) + `AuthRepositoryImpl` in `lib/features/auth/repository/auth_repository.dart` delegating to `AuthDataSource` (surface only typed `Failure`s; never raw exceptions). Create the abstract `AuthGoogleService` in `lib/features/auth/google/auth_google_service.dart`: `Future<void> initialize()`, `Future<AuthTokens?> signInAndGetTokens()`, `Future<void> signOut()` (interface only — impl is US4). Register repositories in DI.
- [x] T009 [P] [US-] Create `UserRepository` (abstract) + `UserRepositoryImpl` in `lib/features/user/repository/user_repository.dart`: `getProfile()→User`, `switchActiveRole(UserRole)→User`, `addRole(UserRole)→User` (impl: call datasource, then **write `RoleChangeResponse.tokens` through the single token-write path used by the refresh interceptor — the old access token may not carry the new role — BEFORE the returned `User`/roles are reflected anywhere**, constitution §6), `changePassword({currentPassword, newPassword})`. Register in DI.

## Stage 2 — US1 (P1): New user signs up and verifies email with OTP

- [ ] T010 [P] [US1] Create `OtpCubit` + `OtpState` in `lib/features/auth/presentation/cubits/otp_cubit.dart` per `data-model.md` §1.3: `isSubmitting`, `isResending`, `DateTime? resendCooldownUntil`, `attemptsRemaining` (5), `isLocked`, `Failure? failure`. Semantics per `contracts/otp-validation.md`: wrong code → `attemptsRemaining -= 1` (0 → `isLocked`); transport error → no deduction; successful resend → `attemptsRemaining = 5`, `resendCooldownUntil = now + 60s`, `isLocked = false`; resend while cooling down is blocked; the Cubit owns truth (widget Timer is presentation-only).
- [ ] T011 [P] [US1] Create `OtpInput` widget in `lib/features/auth/presentation/widgets/otp_input.dart`: ONE real `TextFormField` (numeric, `maxLength: 6`, `FilteringTextInputFormatter.digitsOnly`) overlaid under six display-only boxes; the six boxes are wrapped in `ExcludeSemantics` and the real field carries a single semantic label; paste/autofill work.
- [ ] T012 [P] [US1] Create `SignupCubit` in `lib/features/auth/presentation/cubits/signup_cubit.dart`: validate (name non-empty; email format; phone normalized to `+20…` per D4; password ≥8 with ≥1 letter + ≥1 digit per Q2), submit via `AuthRepository.signup`, map `EmailAlreadyRegistered` to its localized message.
- [ ] T013 [P] [US1] Create `LabeledInput` widget in `lib/features/auth/presentation/widgets/labeled_input.dart` (labeled `TextFormField` with validator + inline localized error + a11y label, ≥44dp).
- [ ] T014 [P] [US1] Create `SignupScreen` in `lib/features/auth/presentation/screens/signup_screen.dart`: first/last name, email, phone, password fields with the Q2/D4 validators; submit → success navigates to `/otp?email=<signup-email>` (signup NEVER navigates to login).
- [ ] T015 [P] [US1] Create `OtpScreen` in `lib/features/auth/presentation/screens/otp_screen.dart`: reads `email` from the route query param (graceful if missing), renders `OtpInput`, submit → `verifyOtp` → success navigates to `/login` (never auto-login); resend button with 1s countdown `Timer` (presentation-only) from `resendCooldownUntil`; when `isLocked` the field is disabled and UI prompts to resend.
- [ ] T016 [P] [US1] Replace the `/signup` and `/otp` placeholder routes in `lib/core/router/app_router.dart` with the real `SignupScreen`/`OtpScreen` (keep `/login`, `/reset-password`, `/profile`, `/listings`, `/search`, `/advisor`, `/inquiries` placeholders). Update `lib/core/widgets/placeholder_screen.dart` usage if needed so the placeholder set shrinks; keep `test/widget/unknown_route_test.dart` green (existing tests stay green).

## Stage 3 — US2 (P1): Returning user signs in and stays signed in across restarts

- [ ] T017 [P] [US2] Create `AuthSessionCubit` + sealed `AuthSessionState` in `lib/features/auth/presentation/cubits/auth_session_cubit.dart` per `data-model.md` §3.1 (`AuthSessionInitial` / `AuthSessionAuthenticated{User? user}` / `AuthSessionUnauthenticated`). It implements `SessionReader` (`isAuthenticated`, `roles`). Methods: `initialize()` reads stored access token → authenticated, then hydrates `UserRepository.getProfile()` in the background (populates `roles`, and `activeRole` server value wins over the pref per D3); `authenticate(AuthTokens)` (post-login/Google); `updateTokens(AuthTokens)`; `clearSession()` (FR-013 — the ONE local session-clearing mechanism: `TokenStorage.clear()` + unauthenticated, reused by sign-out AND password change); `signOut()` (best-effort `AuthRepository.logout()` + `AuthGoogleService.signOut()` + `clearSession()`, never throws).
- [ ] T018 [P] [US2] Create `LoginCubit` in `lib/features/auth/presentation/cubits/login_cubit.dart`: validate (email format, password non-empty), submit → `AuthRepository.login` → persist tokens → `AuthSessionCubit.authenticate` → authenticated; `InvalidCredentials` → localized inline error; `EmailNotVerified` → navigate to `/otp?email=<email>` (unverified users never reach login).
- [ ] T019 [P] [US2] Create `LoginScreen` in `lib/features/auth/presentation/screens/login_screen.dart`: email + password (`LabeledInput`), localized errors, submit → authenticated; include an `AuthSegmentedToggle` widget (`lib/features/auth/presentation/widgets/auth_segmented_toggle.dart`) switching between `/login` and `/signup`; reserve the Google-button slot (filled in US4).
- [ ] T020 [P] [US2] Replace the Phase 0 session reader: register `AuthSessionCubit` as `@LazySingleton(as: SessionReader)` and delete `DefaultSessionReader` from `lib/core/router/route_guards.dart` (guards and their consumers need no changes).
- [ ] T021 [P] [US2] Wire the router + bootstrap: inject `AuthSessionCubit` into `AppRouter` (`lib/core/router/app_router.dart`) and attach a `Listenable` adapter over the cubit stream (a small `ChangeNotifier` forwarding `AuthSessionCubit.stream`) as `GoRouter.refreshListenable` so redirects re-evaluate on session change; attach `AuthGuard` to protected routes (`/`, `/profile`, `/change-password`) with `signInPath: '/login'`; in `lib/bootstrap.dart` resolve `AuthSessionCubit` + `AuthGoogleService`, await `initialize()` on both before `runApp`; subscribe `SessionController.sessionExpired` → `AuthSessionCubit.clearSession()` (force-logout path).

## Stage 4 — US4 (P2): User signs in / creates an account with Google

- [ ] T022 [P] [US4] Implement `GoogleAuthServiceImpl` in `lib/features/auth/google/google_auth_service_impl.dart` (implements `AuthGoogleService`): `initialize()` runs once (awaited in bootstrap) with `serverClientId`; `signInAndGetTokens()` = Google sign-in → `idToken` from `account.authentication.idToken` → `AuthRepository` google → `AuthTokens` (raw `GoogleSignInAccount`/authentication types never leave this file, D1); cancel → `GoogleSignInCancelled`; password-account collision (`EmailAlreadyRegistered`) → clear localized message guiding to password login (no auto-link, Q3). Register in DI.
- [ ] T023 [P] [US4] Create `GoogleSignInCubit` in `lib/features/auth/presentation/cubits/google_sign_in_cubit.dart`: wraps `AuthGoogleService.signInAndGetTokens` → `AuthSessionCubit.authenticate` → authenticated.
- [ ] T024 [P] [US4] Create `SocialButton` widget in `lib/features/auth/presentation/widgets/social_button.dart`: Google icon + label, ≥44dp, loading state, disabled while submitting.
- [ ] T025 [P] [US4] Wire the Google button into `LoginScreen` and `SignupScreen` via `GoogleSignInCubit` → authenticated → `/`. Error (collision/cancel) surfaces a localized message; button disabled while loading.
- [ ] T026 [US4] iOS platform config: add the Google reversed-client-id URL scheme to `ios/Runner/Info.plist` (`CFBundleURLTypes`) per `contracts/google-signin-flow.md`; add a note in the repo docs that provisioning `GoogleService-Info.plist` (real client) is a dev/ops step — the app must still build and run without it in dev.

## Stage 5 — US3 (P2): User who forgot password resets it

- [ ] T027 [P] [US3] Create `ForgotPasswordCubit` in `lib/features/auth/presentation/cubits/forgot_password_cubit.dart`: validate email, submit → `AuthRepository.forgotPassword`.
- [ ] T028 [P] [US3] Create `ResetPasswordCubit` in `lib/features/auth/presentation/cubits/reset_password_cubit.dart`: email (prefilled) + OTP (reuses `OtpCubit`) + new password (Q2 rule) → `AuthRepository.resetPassword` → success navigates to `/login`.
- [ ] T029 [P] [US3] Create `ForgotPasswordScreen` in `lib/features/auth/presentation/screens/forgot_password_screen.dart`: email → success navigates to `/reset-password?email=<email>` with confirmation copy.
- [ ] T030 [P] [US3] Create `ResetPasswordScreen` in `lib/features/auth/presentation/screens/reset_password_screen.dart`: prefilled (read-only) email, `OtpInput` + cooldown/resend, new-password field; success → `/login`.
- [ ] T031 [P] [US3] Replace the `/reset-password` placeholder route in `lib/core/router/app_router.dart` with the real `ResetPasswordScreen`.

## Stage 6 — US5 (P2): Shared account/role-management capability (unit-tested, no screens)

- [ ] T032 [P] [US5] Create `RolesCubit` in `lib/features/user/presentation/cubits/roles_cubit.dart` exposing the shared capability (NO screen triggers it in Phase 1): `addRole(UserRole)` → `UserRepository.addRole` → reflect `roles += role` on `AuthSessionCubit` (guards re-evaluate; tokens already replaced inside the repository); `switchActiveRole(UserRole)` → `UserRepository.switchActiveRole` → persist `activeRole` to `shared_preferences` (key `activeRole`, via `SharedPreferencesService`) + emit `User`. Server truth wins on hydrate (D3).
- [ ] T033 [P] [US5] Add a `hydrateRoles`/`updateRoles` hook on `AuthSessionCubit` so `RolesCubit` changes reach `SessionReader` consumers (guards re-evaluate on `roles[]`).

## Stage 7 — US6 (P3): User signs out (+ minimal account screen + change password)

- [ ] T034 [P] [US6] Create `ProfileCubit` in `lib/features/user/presentation/cubits/profile_cubit.dart`: load `UserRepository.getProfile()` → loading/loaded/error states.
- [ ] T035 [P] [US6] Create `ChangePasswordCubit` in `lib/features/user/presentation/cubits/change_password_cubit.dart`: validate (current non-empty; new per Q2), submit → `UserRepository.changePassword` → **`AuthSessionCubit.clearSession()` and go to `/login` immediately** (constitution §6 — never wait for a 401).
- [ ] T036 [P] [US6] Create `ProfileScreen` in `lib/features/user/presentation/screens/profile_screen.dart` (the minimal account screen): shows signed-in email + name from `ProfileCubit`, a "Change Password" entry → `/change-password`, and a Sign Out button → `AuthSessionCubit.signOut()` → unauthenticated → router redirects to `/login`; localized, a11y labels, ≥44dp targets.
- [ ] T037 [P] [US6] Create `ChangePasswordScreen` in `lib/features/user/presentation/screens/change_password_screen.dart`: current + new password fields (`LabeledInput`), submit → success clears session → `/login`.
- [ ] T038 [P] [US6] Give `AppAdaptiveShell` (`lib/core/responsive/app_adaptive_shell.dart`) an optional `ValueChanged<int>? onDestinationSelected` callback (default keeps the current index-only behavior); in `AppRouter` pass a handler so the **Profile destination** navigates to `/profile` (other destinations stay index-only for later phases).
- [ ] T039 [P] [US6] Router: replace the `/profile` placeholder with the real protected `ProfileScreen`; add the protected `/change-password` route; attach `AuthGuard` to both. Keep `test/widget/unknown_route_test.dart` and any placeholder-route tests green (existing tests stay green).

## Stage 8 — Verification & quality gate

- [ ] T040 [P] [US-] Manual smoke test (no automated test): signup → OTP verify → login → profile shows email → change password → auto-logout to `/login` → sign in with the new password → sign out → back at `/login`. Also: pre-seed `auth.accessToken`/`auth.refreshToken` and relaunch → app opens authenticated (cold-start restore).
- [ ] T041 [P] [US-] Manual responsive/RTL check on the new auth + profile screens at all three Material breakpoints (compact/medium/expanded) in both English and Arabic (full RTL), verifying no overflow and correct mirroring (spec Q5).
- [ ] T042 [US-] Final gate: `flutter pub get`, `flutter gen-l10n`, `dart run build_runner build -d`, `flutter analyze`, existing `flutter test` suite, then `dart run tool/quality.dart` — all green. Sanity sweep: no hardcoded user-facing strings; features never parse the envelope; no raw `DioException` reaches UI; no DTO mapping; no `setState` business logic.
