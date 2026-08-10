# Contract: Google Sign-In Flow

Branch `002-auth-verification-roles` · Research D1 · Plan `plan.md`

## Purpose

Defines how `features/auth/google/` wraps the `google_sign_in` 7.2.0 singleton so Cubits stay
mocktail-testable and the ID-token contract to `POST /auth/google` holds on both platforms.

## The seam — `AuthGoogleService`

```dart
// features/auth/google/auth_google_service.dart
abstract interface class AuthGoogleService {
  Future<void> initialize();                       // called ONCE at bootstrap
  Future<AuthTokens> signInAndGetTokens();         // throws typed Failure on collision/cancel
  Future<String> signInAndGetIdToken();            // raw ID token, NO backend call (link-google flow)
  Future<void> signOut();                          // local Google sign-out (does not logout session)
}
```

- `AuthGoogleService` is the only place that touches `GoogleSignIn`/`GoogleSignInAccount`
  directly. Cubits depend on this interface via get_it; tests mock it.
- The raw `GoogleSignInAccount`/`GoogleSignInAuthentication` never leaves this file; only
  `authentication.idToken` is forwarded to the datasource.

## Singleton init rules (7.x-specific)

1. `GoogleSignIn.instance.initialize(...)` must be **awaited exactly once** before any other call —
   done in bootstrap (`main.dart`), before the router builds. Guard the double-init.
2. Pass `serverClientId` (Android web client ID — used when `google-services.json` is absent) and,
   where needed, `clientId` (iOS); Dart-side values take precedence over plist/JSON.
3. iOS requires the reversed-client-ID in `CFBundleURLTypes` — platform config task, verified in
   the Phase 1 checklist.

## Flow

1. User taps "Continue with Google" → `GoogleSignInCubit.signInWithGoogle()`.
2. `AuthGoogleService.signInAndGetTokens()`: `authenticate()` → `account.authentication.idToken`.
3. Datasource `POST /auth/google { idToken }`.
4. Success → `AuthTokens` replaces stored pair → `AuthSessionCubit` marks authenticated → route to
   dashboard shell (activeRole).
5. `AuthGoogleService.signOut()` is invoked on local app logout to clear the Google account; the
   server session is terminated via `POST /auth/logout`.

## Failure semantics (distinct, never conflated)

| Case | Detection | UI |
|---|---|---|
| User cancels the Google sheet | `GoogleSignInCancelled` (typed `Failure` from the service, no network call) | stay on login, no error toast |
| Email exists as password account (409) | `EmailAlreadyRegistered` from `/auth/google` | localized message: use your password to sign in |
| Google account signed-out / init missing | typed `Failure` from service | localized retry surface |

No sign-in-time auto-link: a password-account collision on `POST /auth/google` never links
automatically — the user signs in with their password, then opts into linking via Profile.

## Link flow (`PATCH /users/me/link-google`, §5.6 of the Phase 1 API guide)

- Entry: Profile screen "Link Google account" tile → `ProfileCubit.linkGoogle()`.
- `AuthGoogleService.signInAndGetIdToken()` runs the SAME sheet as
  `signInAndGetTokens()` (shared `_authenticateAndGetIdToken()` helper) but returns the raw ID
  token WITHOUT calling `/auth/google` — the account is already password-authenticated.
- The ID token is forwarded to `UserRepository.linkGoogle(idToken)` →
  `UserDataSource` `PATCH /users/me/link-google { idToken }` (envelope already unwrapped by the
  dio layer). Response carries no tokens — the current session is left untouched (unlike
  `addRole`, which writes a fresh pair).
- Failure semantics are the same as sign-in: dismissed sheet → `GoogleSignInCancelled` (silent
  no-op, no toast); any other platform failure → `GoogleSignInFailed`; a non-2xx on the link
  endpoint → `GoogleLinkFailed` (`errorGoogleLinkFailed`). Success → localized SnackBar
  `profileLinkGoogleSuccess`.

## Test seam

- `AuthGoogleService` mocked with mocktail: success (`AuthTokens`), cancel, collision, and
  transport-failure cases each get a `bloc_test`.
- No real Google APIs in unit/widget tests; `initialize()` guarded so tests never hit the plugin.
