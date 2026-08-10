import 'package:freezed_annotation/freezed_annotation.dart';

part 'link_google_request.freezed.dart';
part 'link_google_request.g.dart';

@freezed
abstract class LinkGoogleRequest with _$LinkGoogleRequest {
  const factory LinkGoogleRequest({
    required String idToken,
  }) = _LinkGoogleRequest;

  factory LinkGoogleRequest.fromJson(Map<String, dynamic> json) =>
      _$LinkGoogleRequestFromJson(json);
}
