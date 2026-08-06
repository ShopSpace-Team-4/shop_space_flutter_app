import '../data/models/auth_tokens.dart';

/// Google identity seam — the ONLY place that touches `GoogleSignIn` /
/// `GoogleSignInAccount` types (contract `contracts/google-signin-flow.md`).
///
/// Interface only; the implementation is US4. Returns the exchanged
/// [AuthTokens] pair after `POST /auth/google`, or `null` when the user
/// cancels the flow.
abstract class AuthGoogleService {
  Future<void> initialize();

  Future<AuthTokens?> signInAndGetTokens();

  Future<void> signOut();
}
