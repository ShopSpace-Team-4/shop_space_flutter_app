import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_role.dart';

part 'active_role_update_request.freezed.dart';
part 'active_role_update_request.g.dart';

@freezed
abstract class ActiveRoleUpdateRequest with _$ActiveRoleUpdateRequest {
  const factory ActiveRoleUpdateRequest({
    required UserRole role,
  }) = _ActiveRoleUpdateRequest;

  factory ActiveRoleUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$ActiveRoleUpdateRequestFromJson(json);
}
