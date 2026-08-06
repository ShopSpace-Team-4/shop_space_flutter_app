// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_verification_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OtpVerificationRequest _$OtpVerificationRequestFromJson(
  Map<String, dynamic> json,
) => _OtpVerificationRequest(
  email: json['email'] as String,
  otpCode: json['otpCode'] as String,
);

Map<String, dynamic> _$OtpVerificationRequestToJson(
  _OtpVerificationRequest instance,
) => <String, dynamic>{'email': instance.email, 'otpCode': instance.otpCode};
