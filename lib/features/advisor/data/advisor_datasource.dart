import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/dio_failure.dart';
import '../../../core/errors/error_mapper.dart';
import '../../../core/errors/failures.dart';
import 'models/advisor_response.dart';

/// Raw network surface for `POST /advisor/chat` (contract
/// `contracts/advisor-chat-api.md`). This is the ONLY advisor code that touches
/// dio. Methods throw typed [Failure]s only — never raw [DioException]s.
///
/// The envelope `{ message, status, data }` is unwrapped once by the shared
/// dio layer, so [sendChat] reads the response `data` object directly. The
/// advisor call overrides the global 5s dio timeout with a per-request 90s
/// `Options(receiveTimeout:)` plus 15s connect/send timeouts (Q6, D4). The
/// wider window accounts for LLM answer generation and a Railway cold start;
/// the global client is left untouched.
abstract class AdvisorDataSource {
  /// `POST /advisor/chat` — first message body `{ message }`, follow-up body
  /// `{ message, sessionId }` (guide §4.1/4.2); Bearer auth attached by the
  /// shared interceptor.
  Future<AdvisorResponse> sendChat({
    required String message,
    String? sessionId,
  });
}

@Injectable(as: AdvisorDataSource)
class AdvisorDataSourceImpl implements AdvisorDataSource {
  AdvisorDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<AdvisorResponse> sendChat({
    required String message,
    String? sessionId,
  }) async {
    final Response<dynamic> response = await _request<Response<dynamic>>(
      () => _dio.post<dynamic>(
        '/advisor/chat',
        data: sessionId == null
            ? <String, dynamic>{'message': message}
            : <String, dynamic>{'message': message, 'sessionId': sessionId},
        options: Options(
          connectTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 90),
        ),
      ),
    );
    return _parseResponse(response.data);
  }

  /// [response.data] is the unwrapped envelope `data` object. A non-map payload
  /// or an `answer` that is missing/unparseable is treated as a failed response
  /// → [AdvisorChatFailed] (contract §Tolerance). Everything else assembles via
  /// the tolerant [AdvisorResponse.fromApiData] factory.
  AdvisorResponse _parseResponse(dynamic data) {
    if (data is! Map<String, dynamic>) {
      throw const AdvisorChatFailed(ErrorMapper.advisorChatFailedMessageKey);
    }
    try {
      return AdvisorResponse.fromApiData(data);
    } on FormatException {
      throw const AdvisorChatFailed(ErrorMapper.advisorChatFailedMessageKey);
    }
  }

  /// Runs [call] and rethrows the typed [Failure] the pipeline attached to any
  /// [DioException] (see `lib/core/errors/dio_failure.dart`).
  Future<T> _request<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (error) {
      throw error.failure;
    }
  }
}
