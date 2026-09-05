import 'package:dio/dio.dart';

import '../../storage/token_storage.dart';
import '../session_controller.dart';
import '../token_refresher.dart';
import '../unauthenticated_endpoints.dart';

/// Single-flight 401 handling (contract `contracts/network-pipeline.md`):
///
/// - Concurrent 401s share ONE refresh future; the future stays cached for one
///   event-loop turn after completion so 401s from the same token wave reuse it.
/// - The original request is retried exactly once, gated by
///   `RequestOptions.extra['retried']` — it is never retried twice.
/// - A successful refresh persists the new pair exactly once via
///   [SessionController.onTokensUpdated] (FR-007); a failed refresh clears the
///   session and emits the session-expired signal; the US3 router guard
///   redirects to sign-in (FR-006).
class SessionInterceptor extends Interceptor {
  SessionInterceptor({
    required TokenRefresher refresher,
    required SessionController session,
  })  : _refresher = refresher,
        _session = session;

  static const String _retriedKey = 'retried';

  final TokenRefresher _refresher;
  final SessionController _session;

  Future<AuthTokens?>? _refreshFuture;
  Dio? _dio;

  /// Injected by [DioClient] after the [Dio] instance exists, avoiding a
  /// constructor cycle.
  void attachDio(Dio dio) {
    _dio = dio;
  }

  Future<AuthTokens?> _singleFlightRefresh() {
    final Future<AuthTokens?>? inFlight = _refreshFuture;
    if (inFlight != null) {
      return inFlight;
    }
    final Future<AuthTokens?> refresh = _refresher.refresh().then(
      (AuthTokens? tokens) async {
        if (tokens != null) {
          await _session.onTokensUpdated(tokens);
        }
        return tokens;
      },
    );
    _refreshFuture = refresh;
    refresh.whenComplete(() {
      // Clear on the next event-loop turn so concurrent 401 handlers already
      // queued for the same token wave can share this refresh future.
      Future<void>(() => _refreshFuture = null);
    });
    return refresh;
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401 ||
        err.requestOptions.extra[_retriedKey] == true ||
        UnauthenticatedEndpoints.contains(err.requestOptions.path) ||
        _isRefreshRequest(err.requestOptions.path)) {
      handler.next(err);
      return;
    }
    final AuthTokens? tokens = await _singleFlightRefresh();
    if (tokens == null) {
      await _session.onSessionExpired();
      handler.next(err);
      return;
    }
    err.requestOptions.extra[_retriedKey] = true;
    final Dio? dio = _dio;
    if (dio == null) {
      handler.next(err);
      return;
    }
    try {
      final Response<dynamic> response = await dio.fetch<dynamic>(
        err.requestOptions,
      );
      handler.resolve(response);
    } on DioException catch (retryError) {
      if (retryError.response?.statusCode == 401) {
        await _session.onSessionExpired();
      }
      handler.reject(retryError, true);
    } catch (retryError) {
      handler.next(err);
    }
  }

  /// The refresh call itself must never trigger another refresh when it 401s
  /// (expired refresh token) — that 401 is the force-logout signal (FR-006).
  bool _isRefreshRequest(String path) {
    final String normalized = path.replaceFirst(RegExp(r'^/+'), '');
    return normalized == 'auth/refresh-token' ||
        normalized.endsWith('auth/refresh-token');
  }
}
