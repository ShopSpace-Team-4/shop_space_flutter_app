import 'dart:async';

import '../storage/token_storage.dart';

/// Owns the session lifecycle signals (contract `contracts/network-pipeline.md`).
///
/// [onTokensUpdated] persists a refreshed token pair (FR-007). [onSessionExpired]
/// clears storage and emits the [sessionExpired] signal, which the US3 router
/// guard consumes to redirect to sign-in (FR-006).
class SessionController {
  SessionController(this._storage);

  final TokenStorage _storage;

  final StreamController<void> _sessionExpired =
      StreamController<void>.broadcast();

  Stream<void> get sessionExpired => _sessionExpired.stream;

  Future<void> onTokensUpdated(AuthTokens tokens) => _storage.write(tokens);

  Future<void> onSessionExpired() async {
    await _storage.clear();
    _sessionExpired.add(null);
  }

  void dispose() {
    _sessionExpired.close();
  }
}
