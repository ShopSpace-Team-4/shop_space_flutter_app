import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import '../../../core/env/app_env.dart';
import '../../../core/errors/failures.dart';
import '../data/models/auth_tokens.dart';
import '../data/models/google_signin_request.dart';
import '../repository/auth_repository.dart';
import 'auth_google_service.dart';
/// Google identity implementation (T022, US4) — the ONLY place that touches
/// `GoogleSignIn`/`GoogleSignInAccount` types (contract
/// `contracts/google-signin-flow.md`, D1). Raw account/authentication objects
/// never leave this file; only `authentication.idToken` is forwarded.
///
/// Cancel semantics follow the contract: a dismissed Google sheet throws a
/// typed [GoogleSignInCancelled] (stay on login, no error toast); collisions
/// and other errors throw typed [Failure]s for the UI to localize.
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
    const String serverClientId = AppEnv.googleServerClientId;
    await _googleSignIn.initialize(
      serverClientId: serverClientId.isEmpty ? null : serverClientId,
    );
    _initialized = true;
  }

  @override
  Future<AuthTokens> signInAndGetTokens() async {
    final GoogleSignInAccount account;
    try {
      account = await _googleSignIn.authenticate();
    } on GoogleSignInException catch (e) {
      switch (e.code) {
        case GoogleSignInExceptionCode.canceled:
        case GoogleSignInExceptionCode.interrupted:
        case GoogleSignInExceptionCode.uiUnavailable:
          // User cancelled the Google sheet: stay on login, no toast.
          throw const GoogleSignInCancelled('errorGoogleSignInCancelled');
        default:
          rethrow;
      }
    }
    final String? idToken = account.authentication.idToken;
    if (idToken == null) {
      throw const GoogleSignInCancelled('errorGoogleSignInCancelled');
    }
    return _authRepository.googleSignIn(GoogleSignInRequest(idToken: idToken));
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
