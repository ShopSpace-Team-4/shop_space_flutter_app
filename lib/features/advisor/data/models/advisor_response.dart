import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../listing/data/models/browse_listing.dart';
import 'advisor_source.dart';

part 'advisor_response.freezed.dart';

/// The response `data` object of `POST /advisor/chat` (guide §4.1, data-model
/// §1.1). Assembled by the datasource via the tolerant [AdvisorResponse.fromApiData]
/// factory — freezed's strict `fromJson` is deliberately NOT used because
/// tolerance is mandated (FR-006/007): absent/null/empty/malformed fields never
/// crash and never hide the answer.
@freezed
abstract class AdvisorResponse with _$AdvisorResponse {
  const factory AdvisorResponse({
    String? sessionId,
    required String answer,
    @Default(<AdvisorSource>[]) List<AdvisorSource> sources,
    String? disclaimer,
    @Default(<BrowseListing>[]) List<BrowseListing> recommendedListings,
  }) = _AdvisorResponse;

  /// Tolerant assembly from the raw response `data` map (contract
  /// `contracts/advisor-chat-api.md` §Tolerance):
  /// - `answer` missing/unparseable → throws [FormatException] (the datasource
  ///   maps it to `AdvisorChatFailed`).
  /// - `sources` absent/null → `[]` (no sources disclosure).
  /// - `disclaimer` absent/null → null (fixed localized fallback in the UI).
  /// - `recommendedListings` absent/null/empty/non-array → `[]`; each list
  ///   entry is parsed in isolation and malformed entries are skipped.
  factory AdvisorResponse.fromApiData(Map<String, dynamic> data) {
    final dynamic rawAnswer = data['answer'];
    if (rawAnswer is! String) {
      throw const FormatException(
        'POST /advisor/chat response data is missing a String `answer`.',
      );
    }
    return AdvisorResponse(
      sessionId: _readNullableString(data['sessionId']),
      answer: rawAnswer,
      sources: _readSources(data['sources']),
      disclaimer: _readNullableString(data['disclaimer']),
      recommendedListings: _readRecommendedListings(
        data['recommendedListings'],
      ),
    );
  }

  static String? _readNullableString(dynamic value) =>
      value is String ? value : null;

  static List<AdvisorSource> _readSources(dynamic value) {
    if (value is! List) {
      return const <AdvisorSource>[];
    }
    final List<AdvisorSource> sources = <AdvisorSource>[];
    for (final dynamic entry in value) {
      if (entry is Map<String, dynamic>) {
        try {
          sources.add(AdvisorSource.fromJson(entry));
        } on Object {
          // A malformed source must never crash the answer (FR-006).
        }
      }
    }
    return sources;
  }

  static List<BrowseListing> _readRecommendedListings(dynamic value) {
    if (value is! List) {
      return const <BrowseListing>[];
    }
    final List<BrowseListing> listings = <BrowseListing>[];
    for (final dynamic entry in value) {
      if (entry is Map<String, dynamic>) {
        try {
          listings.add(BrowseListing.fromJson(entry));
        } on Object {
          // A malformed entry is skipped in isolation; valid ones are kept
          // (FR-006).
        }
      }
    }
    return listings;
  }
}
