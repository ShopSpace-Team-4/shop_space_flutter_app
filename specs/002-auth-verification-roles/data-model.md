# Data Model — Phase 1 (Auth Verification & Roles)

Branch `002-auth-verification-roles` · Date 2026-08-06 · Spec `spec.md` · Plan `plan.md`

Covers the request/response models for the finalized Auth & User API (§3.1 of
`ShopSpace_Flutter_Implementation_Plan.md`) and the OTP/role state machines. All models are freezed
Dart under `lib/features/auth/data/models/` and `lib/features/user/data/models/` and flow unchanged
into `repository/` and `presentation/` (constitution §2 — same models everywhere, no DTO mapping).

> Transport rules inherited from Phase 0: the envelope `{ message, status, data }` is unwrapped once
> in `core/network/`; every model below is the **unwrapped `data` payload**. Non-2xx → typed
> `Failure` (Phase 0 set), never raw exceptions.

## 1. Auth models — `lib/features/auth/data/models/`

### 1.1 `AuthTokens` (response)

Returned by `/auth/login`, `/auth/google`, `/auth/refresh-token`, and `POST /users/me/roles`.

```dart
@freezed
abstract class AuthTokens with _$AuthTokens {
  const factory AuthTokens({required String accessToken, required String refreshToken}) = _AuthTokens;
  factory AuthTokens.fromJson(Map<String, dynamic> json) => _$AuthTokensFromJson(json);
}
```

Replaces the stored pair in `flutter_secure_storage` (keys `auth.accessToken`/`auth.refreshToken`)
immediately on arrival — including the pair returned by `addRole` (constitution §6). Mirrors the
Phase 0 `AuthTokens` shape in `core/storage/token_storage.dart`; the network `TokenProvider` is the
only writer.

### 1.2 Request payloads (bodies sent to `/auth/*`)

| Model | Endpoint | Fields | Validation (client-side) |
|---|---|---|---|
| `SignupRequest` | `POST /auth/signup` | `firstName`, `lastName`, `email`, `phone`, `password` | name non-empty; email format; phone normalized to `+20…` (D4); password ≥8 with ≥1 letter + ≥1 digit (Q2) |
| `LoginRequest` | `POST /auth/login` | `email`, `password` | email format; password non-empty |
| `OtpVerificationRequest` | `POST /auth/verify` | `email`, `otpCode` | `otpCode` exactly 6 digits (D2) |
| `ResendOtpRequest` | `POST /auth/resend-otp` | `email` | — |
| `GoogleSignInRequest` | `POST /auth/google` | `idToken` | non-empty; from `AuthGoogleService` (D1) |
| `ForgotPasswordRequest` | `POST /auth/forgot-password` | `email` | email format |
| `ResetPasswordRequest` | `POST /auth/reset-password` | `email`, `otpCode`, `newPassword` | same password rule as signup |
| `RefreshTokenRequest` | `POST /auth/refresh-token` | `refreshToken` | — (dio refresh interceptor only) |

All are freezed + `fromJson`-optional for requests (`toJson` only). Validation lives in the Cubit
or form layer, not the model.

### 1.3 OTP domain state (Cubit-level, not transport)

Owned by `OtpCubit` per D2/D4:

```dart
class OtpState {
  final bool isSubmitting;
  final bool isResending;
  final DateTime? resendCooldownUntil;   // now + 60s after emit or resend
  final int attemptsRemaining;           // 5 → 0 (Q4); reset to 5 on new code
  final bool isLocked;                   // true when attemptsRemaining == 0
  final Failure? failure;
}
```

Semantics (contract `otp-validation.md`): each wrong code decrements `attemptsRemaining`;
`isLocked` disables the field and prompts for a new code; a successful resend resets attempts to 5
and restarts the cooldown. Widget owns the 1s `Timer` for the countdown; the Cubit owns truth.

## 2. User models — `lib/features/user/data/models/`

### 2.1 `User` (response, `GET /users/me`)

```dart
@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required List<UserRole> roles,
    required UserRole activeRole,
    required bool isVerified,
    String? avatarUrl,
  }) = _User;
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

**Rules**: `roles` holds the **full** role set — permission-sensitive UI reads `roles`, never
`activeRole` alone (constitution §6). `activeRole` only picks which dashboard renders. `phone` is the
canonical `+20…` form returned by the server. `isVerified` gates certain flows (unverified users are
routed to OTP, never straight to login).

### 2.2 `UserRole` enum

```dart
enum UserRole { tenant, landlord }
```

Serialized as `"tenant"` / `"landlord"` strings. Accounts default to `tenant`; `landlord` is added
via the shared `UserRepository.addRole('landlord')` (constitution §6).

### 2.3 Request payloads (bodies sent to `/users/me*`)

| Model | Endpoint | Fields |
|---|---|---|
| `PasswordChangeRequest` | `PUT /users/me/password` | `currentPassword`, `newPassword` |
| `ActiveRoleUpdateRequest` | `PATCH /users/me/active-role` | `role` (`UserRole`) |
| `RoleChangeRequest` | `POST /users/me/roles` | `role` (`UserRole`) |
| `LinkGoogleRequest` | `POST /users/me/link-google` | `idToken` — **later phase, not in scope** |

`RoleChangeResponse` for `POST /users/me/roles` = `{ tokens: AuthTokens, user: User }` (freezed
composition). The returned `tokens` MUST replace the stored pair immediately (constitution §6).

## 3. Session & role state machines

### 3.1 `AuthSessionState` (auth-side; replaces the Phase 0 static `SessionReader`)

```dart
sealed class AuthSessionState {
  const AuthSessionState();
}
class AuthSessionInitial extends AuthSessionState {}
class AuthSessionAuthenticated extends AuthSessionState { final User? user; } // user hydrates lazily
class AuthSessionUnauthenticated extends AuthSessionState {}
```

`AuthSessionCubit.initialize()` reads stored access token → authenticated (D3), then hydrates
`GET /users/me` in the background. Router `AuthGuard` consumes this stream instead of the Phase 0
`DefaultSessionReader` stub (which returns `isAuthenticated=false`).

### 3.2 Role switch semantics

- `activeRole` selection updates the dashboard shell only; it does **not** change `roles`.
- Persisted to `shared_preferences` (key `activeRole`) so the app reopens on the last-used
  dashboard; server truth wins once `GET /users/me` hydrates (D3).

## 4. Anti-patterns to avoid (extended)

- No envelope parsing, no DTO→entity mapping, no raw `DioException` (Phase 0 rules).
- No `setState` business logic; Cubits own all state transitions.
- OTP cooldown/counter never held in the widget (`Timer` is presentation-only, D2).
- Google identity data (`GoogleSignInAccount`/`GoogleSignInAuthentication`) is never stored; only
  the `idToken` is forwarded to `/auth/google` (D1).
- `activeRole` never gates permissions by itself; `roles[]` is the permission source.
