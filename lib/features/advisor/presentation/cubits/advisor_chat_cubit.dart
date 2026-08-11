import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../data/models/advisor_message.dart';
import '../../data/models/advisor_response.dart';
import '../../repository/advisor_repository.dart';
import 'advisor_chat_state.dart';

/// Drives the advisor conversation thread (contract
/// `contracts/advisor-chat-state.md`, data-model §3.1).
///
/// Registered as a get_it **lazy singleton** (Q5, D3): the conversation is
/// retained in memory for the life of the app run — leaving/returning to the
/// Advisor never clears it; only an app restart or logout does ([reset]).
/// Cubits depend only on the [AdvisorRepository] interface (constitution §2).
@LazySingleton()
class AdvisorChatCubit extends Cubit<AdvisorChatState> {
  AdvisorChatCubit({required AdvisorRepository repository})
      : _repository = repository,
        super(const AdvisorChatState());

  /// Hard input cap (Q7): input beyond this length cannot send.
  static const int maxMessageLength = 500;

  final AdvisorRepository _repository;
  int _messageCounter = 0;

  String _nextMessageId() => 'advisor-${_messageCounter++}';

  /// Appends the trimmed user question and requests an answer. Blank /
  /// whitespace-only input is ignored, input over [maxMessageLength] is
  /// ignored, and a send while one request is already in flight is ignored
  /// (Q4/Q7 — exactly one request at a time, no queueing).
  Future<void> sendMessage(String rawInput) async {
    final String message = rawInput.trim();
    if (message.isEmpty) return;
    if (message.length > maxMessageLength) return;
    if (state.isSending) return;
    await _performSend(
      userMessage: AdvisorMessage(
        id: _nextMessageId(),
        role: AdvisorRole.user,
        content: message,
        createdAt: DateTime.now(),
      ),
    );
  }

  /// Re-sends the failed user message through the same path (FR-012, Q6). The
  /// failed message stays in the thread as the pending question — it is not
  /// duplicated.
  Future<void> retry() async {
    final String? failedId = state.failedMessageId;
    if (failedId == null || state.isSending) return;
    final AdvisorMessage? failed = _messageById(failedId);
    if (failed == null || failed.role != AdvisorRole.user) return;
    await _performSend(userMessage: failed);
  }

  /// Clears the thread + session. Called on logout (T030) so a different user
  /// never sees the previous conversation (D3); app restart rebuilds get_it so
  /// the cubit starts fresh anyway.
  void reset() {
    emit(const AdvisorChatState());
  }

  Future<void> _performSend({required AdvisorMessage userMessage}) async {
    final bool isRetry = userMessage.id == state.failedMessageId;
    emit(state.copyWith(
      isSending: true,
      failedMessageId: null,
      failure: null,
      messages: isRetry ? state.messages : [...state.messages, userMessage],
    ));
    try {
      final AdvisorResponse response = await _repository.sendChat(
        message: userMessage.content,
        sessionId: state.sessionId,
      );
      emit(state.copyWith(
        isSending: false,
        messages: [
          ...state.messages,
          AdvisorMessage(
            id: _nextMessageId(),
            role: AdvisorRole.assistant,
            content: response.answer,
            sources: response.sources,
            disclaimer: response.disclaimer,
            recommendedListings: response.recommendedListings,
            createdAt: DateTime.now(),
          ),
        ],
        sessionId: response.sessionId ?? state.sessionId,
      ));
    } on Failure catch (failure) {
      emit(state.copyWith(
        isSending: false,
        failedMessageId: userMessage.id,
        failure: failure,
      ));
    } catch (_) {
      // Defensive: the datasource surfaces only typed failures, but a bug
      // must never crash the chat — fall back to a friendly generic error
      // with the same retry path (FR-012).
      emit(state.copyWith(
        isSending: false,
        failedMessageId: userMessage.id,
        failure: const GenericFailure(''),
      ));
    }
  }

  AdvisorMessage? _messageById(String id) {
    for (final AdvisorMessage message in state.messages) {
      if (message.id == id) return message;
    }
    return null;
  }
}
