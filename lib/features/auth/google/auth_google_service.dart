import '../data/models/auth_tokens.dart';

/// Google identity seam — the ONLY place that touches `GoogleSignIn` /
/// `GoogleSignInAccount` types (contract `contracts/google-signin-flow.md`).
///
/// Interface only; the implementation is US4. Returns the exchanged
/// [AuthTokens] pair after `POST /auth/google`. Throws a typed
/// [GoogleSignInCancelled] when the user dismisses the Google sheet (no
/// network call, stay on login with no error toast) and other typed `Failure`s
/// for collisions / transport errors.
abstract class AuthGoogleService {
  Future<void> initialize();

  Future<AuthTokens> signInAndGetTokens();

  Future<void> signOut();
}
