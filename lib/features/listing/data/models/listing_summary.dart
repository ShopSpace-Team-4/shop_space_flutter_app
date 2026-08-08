import 'package:freezed_annotation/freezed_annotation.dart';

import 'listing_status.dart';

part 'listing_summary.freezed.dart';
part 'listing_summary.g.dart';

/// Lightweight list item returned by `GET /listings/my-listings` (a bare array
/// with no pagination meta, data-model.md §1.4).
@freezed
abstract class ListingSummary with _$ListingSummary {
  const factory ListingSummary({
    required String id,
    required String title,
    required String category,
    required double areaSqm,
    required double annualRent,
    required String currency,
    @ListingStatusConverter() required ListingStatus status,
    String? thumbnailUrl,
  }) = _ListingSummary;

  factory ListingSummary.fromJson(Map<String, dynamic> json) =>
      _$ListingSummaryFromJson(json);
}
