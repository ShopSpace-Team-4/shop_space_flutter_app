import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../auth/data/models/auth_tokens.dart';
import 'user.dart';

part 'role_change_response.freezed.dart';
part 'role_change_response.g.dart';

@freezed
abstract class RoleChangeResponse with _$RoleChangeResponse {
  const factory RoleChangeResponse({
    required AuthTokens tokens,
    required User profile,
  }) = _RoleChangeResponse;

  factory RoleChangeResponse.fromJson(Map<String, dynamic> json) =>
      _$RoleChangeResponseFromJson(json);
}
