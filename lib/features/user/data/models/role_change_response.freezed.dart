// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'role_change_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RoleChangeResponse {

 AuthTokens get tokens; User get profile;
/// Create a copy of RoleChangeResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoleChangeResponseCopyWith<RoleChangeResponse> get copyWith => _$RoleChangeResponseCopyWithImpl<RoleChangeResponse>(this as RoleChangeResponse, _$identity);

  /// Serializes this RoleChangeResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoleChangeResponse&&(identical(other.tokens, tokens) || other.tokens == tokens)&&(identical(other.profile, profile) || other.profile == profile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tokens,profile);

@override
String toString() {
  return 'RoleChangeResponse(tokens: $tokens, profile: $profile)';
}


}

/// @nodoc
abstract mixin class $RoleChangeResponseCopyWith<$Res>  {
  factory $RoleChangeResponseCopyWith(RoleChangeResponse value, $Res Function(RoleChangeResponse) _then) = _$RoleChangeResponseCopyWithImpl;
@useResult
$Res call({
 AuthTokens tokens, User profile
});


$AuthTokensCopyWith<$Res> get tokens;$UserCopyWith<$Res> get profile;

}
/// @nodoc
class _$RoleChangeResponseCopyWithImpl<$Res>
    implements $RoleChangeResponseCopyWith<$Res> {
  _$RoleChangeResponseCopyWithImpl(this._self, this._then);

  final RoleChangeResponse _self;
  final $Res Function(RoleChangeResponse) _then;

/// Create a copy of RoleChangeResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tokens = null,Object? profile = null,}) {
  return _then(_self.copyWith(
tokens: null == tokens ? _self.tokens : tokens // ignore: cast_nullable_to_non_nullable
as AuthTokens,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as User,
  ));
}
/// Create a copy of RoleChangeResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthTokensCopyWith<$Res> get tokens {
  
  return $AuthTokensCopyWith<$Res>(_self.tokens, (value) {
    return _then(_self.copyWith(tokens: value));
  });
}/// Create a copy of RoleChangeResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get profile {
  
  return $UserCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// Adds pattern-matching-related methods to [RoleChangeResponse].
extension RoleChangeResponsePatterns on RoleChangeResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoleChangeResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoleChangeResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoleChangeResponse value)  $default,){
final _that = this;
switch (_that) {
case _RoleChangeResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoleChangeResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RoleChangeResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AuthTokens tokens,  User profile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoleChangeResponse() when $default != null:
return $default(_that.tokens,_that.profile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AuthTokens tokens,  User profile)  $default,) {final _that = this;
switch (_that) {
case _RoleChangeResponse():
return $default(_that.tokens,_that.profile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AuthTokens tokens,  User profile)?  $default,) {final _that = this;
switch (_that) {
case _RoleChangeResponse() when $default != null:
return $default(_that.tokens,_that.profile);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoleChangeResponse implements RoleChangeResponse {
  const _RoleChangeResponse({required this.tokens, required this.profile});
  factory _RoleChangeResponse.fromJson(Map<String, dynamic> json) => _$RoleChangeResponseFromJson(json);

@override final  AuthTokens tokens;
@override final  User profile;

/// Create a copy of RoleChangeResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoleChangeResponseCopyWith<_RoleChangeResponse> get copyWith => __$RoleChangeResponseCopyWithImpl<_RoleChangeResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoleChangeResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoleChangeResponse&&(identical(other.tokens, tokens) || other.tokens == tokens)&&(identical(other.profile, profile) || other.profile == profile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tokens,profile);

@override
String toString() {
  return 'RoleChangeResponse(tokens: $tokens, profile: $profile)';
}


}

/// @nodoc
abstract mixin class _$RoleChangeResponseCopyWith<$Res> implements $RoleChangeResponseCopyWith<$Res> {
  factory _$RoleChangeResponseCopyWith(_RoleChangeResponse value, $Res Function(_RoleChangeResponse) _then) = __$RoleChangeResponseCopyWithImpl;
@override @useResult
$Res call({
 AuthTokens tokens, User profile
});


@override $AuthTokensCopyWith<$Res> get tokens;@override $UserCopyWith<$Res> get profile;

}
/// @nodoc
class __$RoleChangeResponseCopyWithImpl<$Res>
    implements _$RoleChangeResponseCopyWith<$Res> {
  __$RoleChangeResponseCopyWithImpl(this._self, this._then);

  final _RoleChangeResponse _self;
  final $Res Function(_RoleChangeResponse) _then;

/// Create a copy of RoleChangeResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tokens = null,Object? profile = null,}) {
  return _then(_RoleChangeResponse(
tokens: null == tokens ? _self.tokens : tokens // ignore: cast_nullable_to_non_nullable
as AuthTokens,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as User,
  ));
}

/// Create a copy of RoleChangeResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthTokensCopyWith<$Res> get tokens {
  
  return $AuthTokensCopyWith<$Res>(_self.tokens, (value) {
    return _then(_self.copyWith(tokens: value));
  });
}/// Create a copy of RoleChangeResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get profile {
  
  return $UserCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}

// dart format on
