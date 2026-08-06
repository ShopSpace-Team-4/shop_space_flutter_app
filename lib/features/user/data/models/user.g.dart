// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  roles: (json['roles'] as List<dynamic>)
      .map((e) => $enumDecode(_$UserRoleEnumMap, e))
      .toList(),
  activeRole: $enumDecode(_$UserRoleEnumMap, json['activeRole']),
  isVerified: json['isVerified'] as bool,
  avatarUrl: json['avatarUrl'] as String?,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'phone': instance.phone,
  'roles': instance.roles.map((e) => _$UserRoleEnumMap[e]!).toList(),
  'activeRole': _$UserRoleEnumMap[instance.activeRole]!,
  'isVerified': instance.isVerified,
  'avatarUrl': instance.avatarUrl,
};

const _$UserRoleEnumMap = {
  UserRole.tenant: 'tenant',
  UserRole.landlord: 'landlord',
};
