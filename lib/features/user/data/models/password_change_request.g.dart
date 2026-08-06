// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_change_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PasswordChangeRequest _$PasswordChangeRequestFromJson(
  Map<String, dynamic> json,
) => _PasswordChangeRequest(
  currentPassword: json['currentPassword'] as String,
  newPassword: json['newPassword'] as String,
);

Map<String, dynamic> _$PasswordChangeRequestToJson(
  _PasswordChangeRequest instance,
) => <String, dynamic>{
  'currentPassword': instance.currentPassword,
  'newPassword': instance.newPassword,
};
