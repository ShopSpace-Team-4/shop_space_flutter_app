// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'otp_verification_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OtpVerificationRequest {

 String get email; String get otpCode;
/// Create a copy of OtpVerificationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtpVerificationRequestCopyWith<OtpVerificationRequest> get copyWith => _$OtpVerificationRequestCopyWithImpl<OtpVerificationRequest>(this as OtpVerificationRequest, _$identity);

  /// Serializes this OtpVerificationRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpVerificationRequest&&(identical(other.email, email) || other.email == email)&&(identical(other.otpCode, otpCode) || other.otpCode == otpCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,otpCode);

@override
String toString() {
  return 'OtpVerificationRequest(email: $email, otpCode: $otpCode)';
}


}

/// @nodoc
abstract mixin class $OtpVerificationRequestCopyWith<$Res>  {
  factory $OtpVerificationRequestCopyWith(OtpVerificationRequest value, $Res Function(OtpVerificationRequest) _then) = _$OtpVerificationRequestCopyWithImpl;
@useResult
$Res call({
 String email, String otpCode
});




}
/// @nodoc
class _$OtpVerificationRequestCopyWithImpl<$Res>
    implements $OtpVerificationRequestCopyWith<$Res> {
  _$OtpVerificationRequestCopyWithImpl(this._self, this._then);

  final OtpVerificationRequest _self;
  final $Res Function(OtpVerificationRequest) _then;

/// Create a copy of OtpVerificationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? otpCode = null,}) {
  return _then(_self.copyWith(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,otpCode: null == otpCode ? _self.otpCode : otpCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OtpVerificationRequest].
extension OtpVerificationRequestPatterns on OtpVerificationRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OtpVerificationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OtpVerificationRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OtpVerificationRequest value)  $default,){
final _that = this;
switch (_that) {
case _OtpVerificationRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OtpVerificationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _OtpVerificationRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  String otpCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OtpVerificationRequest() when $default != null:
return $default(_that.email,_that.otpCode);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  String otpCode)  $default,) {final _that = this;
switch (_that) {
case _OtpVerificationRequest():
return $default(_that.email,_that.otpCode);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  String otpCode)?  $default,) {final _that = this;
switch (_that) {
case _OtpVerificationRequest() when $default != null:
return $default(_that.email,_that.otpCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OtpVerificationRequest implements OtpVerificationRequest {
  const _OtpVerificationRequest({required this.email, required this.otpCode});
  factory _OtpVerificationRequest.fromJson(Map<String, dynamic> json) => _$OtpVerificationRequestFromJson(json);

@override final  String email;
@override final  String otpCode;

/// Create a copy of OtpVerificationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OtpVerificationRequestCopyWith<_OtpVerificationRequest> get copyWith => __$OtpVerificationRequestCopyWithImpl<_OtpVerificationRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OtpVerificationRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OtpVerificationRequest&&(identical(other.email, email) || other.email == email)&&(identical(other.otpCode, otpCode) || other.otpCode == otpCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,otpCode);

@override
String toString() {
  return 'OtpVerificationRequest(email: $email, otpCode: $otpCode)';
}


}

/// @nodoc
abstract mixin class _$OtpVerificationRequestCopyWith<$Res> implements $OtpVerificationRequestCopyWith<$Res> {
  factory _$OtpVerificationRequestCopyWith(_OtpVerificationRequest value, $Res Function(_OtpVerificationRequest) _then) = __$OtpVerificationRequestCopyWithImpl;
@override @useResult
$Res call({
 String email, String otpCode
});




}
/// @nodoc
class __$OtpVerificationRequestCopyWithImpl<$Res>
    implements _$OtpVerificationRequestCopyWith<$Res> {
  __$OtpVerificationRequestCopyWithImpl(this._self, this._then);

  final _OtpVerificationRequest _self;
  final $Res Function(_OtpVerificationRequest) _then;

/// Create a copy of OtpVerificationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? otpCode = null,}) {
  return _then(_OtpVerificationRequest(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,otpCode: null == otpCode ? _self.otpCode : otpCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
