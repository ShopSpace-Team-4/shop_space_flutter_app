import '../data/models/advisor_response.dart';

/// Application use-case surface for the AI business advisor chat (contract
/// `contracts/advisor-chat-api.md`). A repository interface method IS the use
/// case (constitution §2). Methods surface only typed failures — never raw
/// exceptions (guaranteed by [AdvisorDataSource]).
abstract class AdvisorRepository {
  /// `POST /advisor/chat` — the first message starts a session implicitly;
  /// every later message passes the stored [sessionId] as a follow-up
  /// (`{ message }` vs `{ message, sessionId }`, guide §4.1/4.2). Returns the
  /// tolerated `AdvisorResponse` (`sessionId`, `answer`, `sources`,
  /// `disclaimer`, `recommendedListings`).
  Future<AdvisorResponse> sendChat({
    required String message,
    String? sessionId,
  });
}
