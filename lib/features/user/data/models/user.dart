import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_role.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required List<UserRole> roles,
    required UserRole activeRole,
    required bool isVerified,
    String? avatarUrl,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
