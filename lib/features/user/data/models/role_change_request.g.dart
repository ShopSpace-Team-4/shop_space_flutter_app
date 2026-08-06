// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_change_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoleChangeRequest _$RoleChangeRequestFromJson(Map<String, dynamic> json) =>
    _RoleChangeRequest(role: $enumDecode(_$UserRoleEnumMap, json['role']));

Map<String, dynamic> _$RoleChangeRequestToJson(_RoleChangeRequest instance) =>
    <String, dynamic>{'role': _$UserRoleEnumMap[instance.role]!};

const _$UserRoleEnumMap = {
  UserRole.tenant: 'tenant',
  UserRole.landlord: 'landlord',
};
