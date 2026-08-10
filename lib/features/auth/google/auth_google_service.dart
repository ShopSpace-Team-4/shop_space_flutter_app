import '../data/models/auth_tokens.dart';

/// Google identity seam — the ONLY place that touches `GoogleSignIn` /
/// `GoogleSignInAccount` types (contract `contracts/google-signin-flow.md`).
///
/// Interface only; the implementation is US4. Returns the exchanged
/// [AuthTokens] pair after `POST /auth/google`, or — for the link-google
/// flow — just the raw ID token so the caller can `PATCH /users/me/link-google`
/// against an existing password account. Throws a typed
/// [GoogleSignInCancelled] when the user dismisses the Google sheet (no
/// network call, stay on page with no error toast) and other typed `Failure`s
/// for collisions / transport errors.
abstract class AuthGoogleService {
  Future<void> initialize();

  Future<AuthTokens> signInAndGetTokens();

  /// Authenticates the Google account and returns its raw ID token WITHOUT
  /// calling any backend endpoint. Used by the link-google flow
  /// (`PATCH /users/me/link-google`, contract `contracts/google-signin-flow.md`)
  /// where the account is already password-authenticated.
  Future<String> signInAndGetIdToken();

  Future<void> signOut();
}
