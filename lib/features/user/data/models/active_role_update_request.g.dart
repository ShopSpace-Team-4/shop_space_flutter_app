// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_role_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActiveRoleUpdateRequest _$ActiveRoleUpdateRequestFromJson(
  Map<String, dynamic> json,
) => _ActiveRoleUpdateRequest(
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
);

Map<String, dynamic> _$ActiveRoleUpdateRequestToJson(
  _ActiveRoleUpdateRequest instance,
) => <String, dynamic>{'role': _$UserRoleEnumMap[instance.role]!};

const _$UserRoleEnumMap = {
  UserRole.tenant: 'tenant',
  UserRole.landlord: 'landlord',
};
