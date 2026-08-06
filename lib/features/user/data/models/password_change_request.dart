import 'package:freezed_annotation/freezed_annotation.dart';

part 'password_change_request.freezed.dart';
part 'password_change_request.g.dart';

@freezed
abstract class PasswordChangeRequest with _$PasswordChangeRequest {
  const factory PasswordChangeRequest({
    required String currentPassword,
    required String newPassword,
  }) = _PasswordChangeRequest;

  factory PasswordChangeRequest.fromJson(Map<String, dynamic> json) =>
      _$PasswordChangeRequestFromJson(json);
}
