import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_verification_request.freezed.dart';
part 'otp_verification_request.g.dart';

@freezed
abstract class OtpVerificationRequest with _$OtpVerificationRequest {
  const factory OtpVerificationRequest({
    required String email,
    required String otpCode,
  }) = _OtpVerificationRequest;

  factory OtpVerificationRequest.fromJson(Map<String, dynamic> json) =>
      _$OtpVerificationRequestFromJson(json);
}
