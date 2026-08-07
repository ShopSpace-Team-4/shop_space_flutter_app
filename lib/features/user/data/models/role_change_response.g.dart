// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_change_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoleChangeResponse _$RoleChangeResponseFromJson(Map<String, dynamic> json) =>
    _RoleChangeResponse(
      tokens: AuthTokens.fromJson(json['tokens'] as Map<String, dynamic>),
      profile: User.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RoleChangeResponseToJson(_RoleChangeResponse instance) =>
    <String, dynamic>{'tokens': instance.tokens, 'profile': instance.profile};
