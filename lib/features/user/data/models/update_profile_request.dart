import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_profile_request.freezed.dart';
part 'update_profile_request.g.dart';

@freezed
abstract class UpdateProfileRequest with _$UpdateProfileRequest {
  const factory UpdateProfileRequest({
    required String firstName,
    required String lastName,
    required String phone,
  }) = _UpdateProfileRequest;

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestFromJson(json);
}
