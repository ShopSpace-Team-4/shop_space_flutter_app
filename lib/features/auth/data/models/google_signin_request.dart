import 'package:freezed_annotation/freezed_annotation.dart';

part 'google_signin_request.freezed.dart';
part 'google_signin_request.g.dart';

@freezed
abstract class GoogleSignInRequest with _$GoogleSignInRequest {
  const factory GoogleSignInRequest({
    required String idToken,
  }) = _GoogleSignInRequest;

  factory GoogleSignInRequest.fromJson(Map<String, dynamic> json) =>
      _$GoogleSignInRequestFromJson(json);
}
