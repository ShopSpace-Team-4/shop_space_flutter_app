/// Single source of truth for the auth endpoints that never carry a bearer
/// token (login, signup, OTP, password reset, token refresh). Their 401s are
/// business responses (e.g. invalid credentials, unverified email), NOT session
/// expiry — so the session/refresh pipeline must never act on them.
/// Consumed by [AuthInterceptor] (skip the Authorization header) and
/// [SessionInterceptor] (skip refresh / force-logout) and [ErrorMapper] (map
/// the 401 body truthfully).
abstract final class UnauthenticatedEndpoints {
  static const List<String> paths = [
    'auth/login',
    'auth/signup',
    'auth/refresh-token',
    'auth/verify',
    'auth/resend-otp',
    'auth/forgot-password',
    'auth/reset-password',
    'auth/google',
  ];

  /// True when [path] targets an unauthenticated endpoint. Mirrors the header
  /// denylist matcher: a leading slash is ignored and sub-paths (e.g.
  /// `/auth/verify/...`) count as the same endpoint.
  static bool contains(String path) {
    final String normalized = path.replaceFirst(RegExp(r'^/+'), '');
    return paths.any(
      (String entry) =>
          normalized == entry || normalized.startsWith('$entry/'),
    );
  }
}
