import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import '../../../core/env/app_env.dart';
import '../../../core/errors/failures.dart';
import '../data/models/auth_tokens.dart';
import '../data/models/google_signin_request.dart';
import '../repository/auth_repository.dart';
import 'auth_google_service.dart';

/// `dart:developer`'s `log()` takes an `int` level (it has no `Level` class —
/// that lives in `package:logging`). 900 is that package's WARNING severity,
/// kept as a named constant to avoid a magic number.
const int _logWarningLevel = 900;

/// Google identity implementation (T022, US4) — the ONLY place that touches
/// `GoogleSignIn`/`GoogleSignInAccount` types (contract
/// `contracts/google-signin-flow.md`, D1). Raw account/authentication objects
/// never leave this file; only `authentication.idToken` is forwarded.
///
/// Cancel semantics follow the contract: a dismissed Google sheet throws a
/// typed [GoogleSignInCancelled] (stay on login, no error toast); every other
/// platform exception is mapped to a typed [GoogleSignInFailed] and never
/// rethrown (the exception-code enum can grow, so a default fallback is kept).
@Injectable(as: AuthGoogleService)
class GoogleAuthServiceImpl implements AuthGoogleService {
  GoogleAuthServiceImpl(this._authRepository);

  final AuthRepository _authRepository;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _initialized = false;

  @override
  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    final String serverClientId = AppEnv.googleServerClientId;
    final String iosClientId = AppEnv.googleIosClientId;
    if (serverClientId.isEmpty && !kReleaseMode) {
      // Escalated to a Level.WARNING log so a debug run with APP_ENV=prod (or
      // any env) but no client ID prints a loud, unmissable banner instead of
      // a mystery failure. Guards on kReleaseMode, not AppEnv.isRelease, so the
      // warning also fires for prod-env debug builds.
      developer.log(
        'GoogleAuthServiceImpl: GOOGLE_SERVER_CLIENT_ID is empty — Google '
        'sign-in falls back to platform provisioning (google-services.json on '
        'Android, GoogleService-Info.plist on iOS). On Android this means '
        'sign-in will fail until you set GOOGLE_SERVER_CLIENT_ID in .env (see '
        '.env.example) or ship google-services.json.',
        name: 'ShopSpace.auth.google',
        level: _logWarningLevel,
      );
    }
    try {
      await _googleSignIn.initialize(
        clientId: iosClientId.isEmpty ? null : iosClientId,
        serverClientId: serverClientId.isEmpty ? null : serverClientId,
      );
      _initialized = true;
    } catch (e) {
      // Platform init failure (missing/unsupported plugin, bad provisioning):
      // log clearly and continue so bootstrap() never hangs. `_initialized`
      // stays false, so a later initialize() retries.
      debugPrint(
        'GoogleAuthServiceImpl: GoogleSignIn.initialize() failed — Google '
        'sign-in will surface a typed failure on first use: $e',
      );
    }
  }

  @override
  Future<AuthTokens> signInAndGetTokens() async {
    final String idToken = await _authenticateAndGetIdToken();
    return _authRepository.googleSignIn(GoogleSignInRequest(idToken: idToken));
  }

  @override
  Future<String> signInAndGetIdToken() => _authenticateAndGetIdToken();

  /// Runs the Google sheet and resolves the authenticated ID token. Shared by
  /// [signInAndGetTokens] (which then exchanges it via `POST /auth/google`)
  /// and [signInAndGetIdToken] (which returns it raw for the link-google
  /// flow). Same cancel/failure semantics in both paths.
  Future<String> _authenticateAndGetIdToken() async {
    final GoogleSignInAccount account;
    try {
      account = await _googleSignIn.authenticate();
    } on GoogleSignInException catch (e) {
      switch (e.code) {
        case GoogleSignInExceptionCode.canceled:
        case GoogleSignInExceptionCode.interrupted:
        case GoogleSignInExceptionCode.uiUnavailable:
          // User cancelled the Google sheet: stay on page, no toast.
          throw const GoogleSignInCancelled('errorGoogleSignInCancelled');
        default:
          // Non-cancel platform failure (client misconfiguration, provider
          // error, unknown code): typed Failure, never rethrow. The platform
          // code + description are debug-printed (all envs) so a plain run
          // shows the real reason — e.g. "serverClientId must be provided on
          // Android" — instead of a mystery. End users still get the generic
          // localized toast.
          debugPrint(
            'GoogleAuthServiceImpl: Google sign-in failed '
            '(code=${e.code})'
            '${e.description == null ? '' : ', description=${e.description}'}'
            '${e.details == null ? '' : ', details=${e.details}'}',
          );
          throw GoogleSignInFailed(
            'errorGoogleSignInFailed',
            description: e.description,
            details: e.details,
          );
      }
    }
    final String? idToken = account.authentication.idToken;
    if (idToken == null) {
      throw const GoogleSignInCancelled('errorGoogleSignInCancelled');
    }
    return idToken;
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
