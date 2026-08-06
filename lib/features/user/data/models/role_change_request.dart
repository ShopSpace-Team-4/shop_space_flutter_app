import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_role.dart';

part 'role_change_request.freezed.dart';
part 'role_change_request.g.dart';

@freezed
abstract class RoleChangeRequest with _$RoleChangeRequest {
  const factory RoleChangeRequest({
    required UserRole role,
  }) = _RoleChangeRequest;

  factory RoleChangeRequest.fromJson(Map<String, dynamic> json) =>
      _$RoleChangeRequestFromJson(json);
}
