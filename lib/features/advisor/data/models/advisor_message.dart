import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../listing/data/models/browse_listing.dart';
import 'advisor_source.dart';

part 'advisor_message.freezed.dart';

/// Who produced a conversation turn.
enum AdvisorRole { user, assistant }

/// One conversation turn — the user's question or the assistant's answer
/// (data-model §1.3). **Locally constructed** by the cubit: there is no wire
/// shape (history loading is out of scope, Q2), so there is deliberately no
/// `fromJson`/`toJson`.
@freezed
abstract class AdvisorMessage with _$AdvisorMessage {
  const factory AdvisorMessage({
    required String id,
    required AdvisorRole role,
    required String content,
    @Default(<AdvisorSource>[]) List<AdvisorSource> sources,
    String? disclaimer,
    @Default(<BrowseListing>[]) List<BrowseListing> recommendedListings,
    required DateTime createdAt,
  }) = _AdvisorMessage;
}
