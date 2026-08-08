import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

/// Lifecycle status of a listing (source of truth: the backend enum surfaced
/// by `GET /listings/meta`). Status transitions are backend-authoritative (D4) —
/// the app renders whatever value the server returns and never validates a
/// transition client-side.
enum ListingStatus {
  pending,
  available,
  rented,
  expired;

  /// Maps the backend's wire values (`"PENDING" | "AVAILABLE" | "RENTED" |
  /// "EXPIRED"`). Unknown values fall back to [ListingStatus.pending] with a
  /// data-integrity log so forward-compatible statuses never crash the app.
  static ListingStatus fromApi(String value) {
    final ListingStatus? status = switch (value.toUpperCase()) {
      'PENDING' => ListingStatus.pending,
      'AVAILABLE' => ListingStatus.available,
      'RENTED' => ListingStatus.rented,
      'EXPIRED' => ListingStatus.expired,
      _ => null,
    };
    if (status == null) {
      debugPrint('ListingStatus: unknown API value "$value", fell back to pending.');
      return ListingStatus.pending;
    }
    return status;
  }

  /// The uppercase wire value used verbatim in `PATCH /listings/:id/status`.
  String get apiValue => switch (this) {
        ListingStatus.pending => 'PENDING',
        ListingStatus.available => 'AVAILABLE',
        ListingStatus.rented => 'RENTED',
        ListingStatus.expired => 'EXPIRED',
      };
}

/// `json_serializable` converter mapping [ListingStatus] to/from its wire value
/// on the listing models (and the status update request body).
class ListingStatusConverter implements JsonConverter<ListingStatus, String> {
  const ListingStatusConverter();

  @override
  ListingStatus fromJson(String json) => ListingStatus.fromApi(json);

  @override
  String toJson(ListingStatus status) => status.apiValue;
}
