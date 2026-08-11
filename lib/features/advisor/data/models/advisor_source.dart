import 'package:freezed_annotation/freezed_annotation.dart';

part 'advisor_source.freezed.dart';
part 'advisor_source.g.dart';

/// One knowledge-base citation an advisor answer is grounded in (data-model
/// §1.2, FRONTEND_PHASE3_ADVISOR_SEARCH_GUIDE.md §4.1). All fields are optional
/// and **snake_case** on the wire → mapped with `@JsonKey(name:)` (a dedicated
/// model — not a reuse of any listing model). The app renders what the backend
/// returns (e.g. a title-only citation).
@freezed
abstract class AdvisorSource with _$AdvisorSource {
  const factory AdvisorSource({
    @JsonKey(name: 'document_id') String? documentId,
    String? title,
    String? category,
    @JsonKey(name: 'business_type') String? businessType,
  }) = _AdvisorSource;

  factory AdvisorSource.fromJson(Map<String, dynamic> json) =>
      _$AdvisorSourceFromJson(json);
}
