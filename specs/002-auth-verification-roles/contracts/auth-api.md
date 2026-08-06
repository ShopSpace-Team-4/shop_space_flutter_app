# Contract: Auth API

Branch `002-auth-verification-roles` · Spec `spec.md` · Plan `plan.md` · Model `data-model.md`

## Purpose

Defines the exact `features/auth/` + `features/user/` → backend surface for Phase 1. Pairs each
endpoint with its payload, its unwrapped `data` shape, and the typed `Failure` that must reach the
UI. Source of truth for payloads: §3.1 of `ShopSpace_Flutter_Implementation_Plan.md` and the
envelope `{ message, status, data }` convention (Phase 0, `core/network/`).

## Rules (inherited, non-negotiable)

1. Envelope is unwrapped exactly once in the dio layer. These contracts describe the `data` field.
2. Bearer token attached via interceptor; 401 → one silent refresh, retry once, then force logout
   (`SessionController.sessionExpired`). The `refresh-token` call itself must never recurse.
3. Every non-2xx maps to a typed `Failure` (`core/errors/failures.dart`). New auth-specific
   variants extend the sealed hierarchy: `EmailAlreadyRegistered`, `InvalidOtp`, `OtpAttemptsExceeded`,
   `InvalidCredentials`, `EmailNotVerified`, `GoogleSignInCancelled`.
4. Requests carry no envelope — only the body below.

## Auth endpoints — `AuthDataSource` (`features/auth/data/`)

| Method & Path | Request body | Success `data` | Error → `Failure` |
|---|---|---|---|
| `POST /auth/signup` | `SignupRequest` | `{}` (empty; next step is OTP) | `EmailAlreadyRegistered`, `ValidationFailure`, `NetworkFailure`/`TimeoutFailure`/`OfflineFailure`/`ServerFailure` |
| `POST /auth/login` | `LoginRequest` | `AuthTokens` | `InvalidCredentials`; `EmailNotVerified` (login fails until verified — spec); others per pipeline |
| `POST /auth/google` | `GoogleSignInRequest{idToken}` | `AuthTokens` | `EmailAlreadyRegistered` (password-account collision → guide to password login; no auto-link), `GoogleSignInCancelled`, others per pipeline |
| `POST /auth/verify` | `OtpVerificationRequest` | `{}` (account now verified; caller proceeds to login) | `InvalidOtp`, `OtpAttemptsExceeded`, `ValidationFailure` |
| `POST /auth/resend-otp` | `ResendOtpRequest` | `{ otpDelivered: bool }` | `RateLimited` (if returned), per pipeline |
| `POST /auth/logout` | — | `{}` | Best-effort: local session is cleared regardless of network result |
| `POST /auth/refresh-token` | `RefreshTokenRequest` | `AuthTokens` | Only used by the dio refresh interceptor; `UnauthorizedFailure` → force logout |
| `POST /auth/forgot-password` | `ForgotPasswordRequest` | `{}` (OTP sent to email) | per pipeline |
| `POST /auth/reset-password` | `ResetPasswordRequest` | `{}` (caller navigates to login) | `InvalidOtp`, `ValidationFailure` |

## User endpoints — `UserDataSource` (`features/user/data/`)

| Method & Path | Request body | Success `data` | Error → `Failure` |
|---|---|---|---|
| `GET /users/me` | — | `User` (roles[], activeRole, isVerified) | `UnauthorizedFailure` → session-expired path |
| `PUT /users/me` | `UpdateProfileRequest` | `User` | per pipeline |
| `PUT /users/me/password` | `PasswordChangeRequest` | `{}` → **clear session now, go to login** | `ValidationFailure` (current password wrong → `InvalidCredentials`) |
| `PATCH /users/me/active-role` | `ActiveRoleUpdateRequest` | `User` | per pipeline |
| `POST /users/me/roles` | `RoleChangeRequest{role}` | `RoleChangeResponse{tokens, user}` → **replace stored tokens immediately** | `ValidationFailure` |
| `POST /users/me/link-google` | `LinkGoogleRequest` | `User` | later phase — not built now |

## State-transition guarantees

- **Signup → OTP**: a successful signup never navigates to login; it navigates to the OTP screen
  with the signup email prefilled.
- **Verify → login**: successful verify navigates to login; the user logs in with credentials
  (never auto-login).
- **Password change**: on success, stored tokens are cleared and the app redirects to `/login`
  immediately (constitution §6) — do not wait for a 401.
- **addRole**: on success, `RoleChangeResponse.tokens` overwrites the stored pair before the UI
  reflects the new `roles[]` (old access token may not carry the new role's permissions).
