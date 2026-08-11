import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../data/models/advisor_message.dart';

part 'advisor_chat_state.freezed.dart';

/// The advisor conversation thread (data-model §3.1, contract
/// `contracts/advisor-chat-state.md`).
///
/// [messages] is the in-memory thread retained for the life of the app run
/// (Q5): the [AdvisorChatCubit] is a get_it lazy singleton, so leaving the
/// Advisor never clears it. [sessionId] is stored on first success and reused
/// by every follow-up so the backend keeps one conversation (FR-004).
/// [failedMessageId] points at the user message whose request failed — it stays
/// in the thread with an inline localized error + retry; [failure] carries the
/// typed error so the UI resolves copy via `failureMessage` (FR-012) and raw
/// technical text never reaches the user.
@freezed
abstract class AdvisorChatState with _$AdvisorChatState {
  const factory AdvisorChatState({
    @Default(<AdvisorMessage>[]) List<AdvisorMessage> messages,
    String? sessionId,
    @Default(false) bool isSending,
    String? failedMessageId,
    Failure? failure,
  }) = _AdvisorChatState;
}
