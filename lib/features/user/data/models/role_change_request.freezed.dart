// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'role_change_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RoleChangeRequest {

 UserRole get role;
/// Create a copy of RoleChangeRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoleChangeRequestCopyWith<RoleChangeRequest> get copyWith => _$RoleChangeRequestCopyWithImpl<RoleChangeRequest>(this as RoleChangeRequest, _$identity);

  /// Serializes this RoleChangeRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoleChangeRequest&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role);

@override
String toString() {
  return 'RoleChangeRequest(role: $role)';
}


}

/// @nodoc
abstract mixin class $RoleChangeRequestCopyWith<$Res>  {
  factory $RoleChangeRequestCopyWith(RoleChangeRequest value, $Res Function(RoleChangeRequest) _then) = _$RoleChangeRequestCopyWithImpl;
@useResult
$Res call({
 UserRole role
});




}
/// @nodoc
class _$RoleChangeRequestCopyWithImpl<$Res>
    implements $RoleChangeRequestCopyWith<$Res> {
  _$RoleChangeRequestCopyWithImpl(this._self, this._then);

  final RoleChangeRequest _self;
  final $Res Function(RoleChangeRequest) _then;

/// Create a copy of RoleChangeRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = null,}) {
  return _then(_self.copyWith(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,
  ));
}

}


/// Adds pattern-matching-related methods to [RoleChangeRequest].
extension RoleChangeRequestPatterns on RoleChangeRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoleChangeRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoleChangeRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoleChangeRequest value)  $default,){
final _that = this;
switch (_that) {
case _RoleChangeRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoleChangeRequest value)?  $default,){
final _that = this;
switch (_that) {
case _RoleChangeRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserRole role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoleChangeRequest() when $default != null:
return $default(_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserRole role)  $default,) {final _that = this;
switch (_that) {
case _RoleChangeRequest():
return $default(_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserRole role)?  $default,) {final _that = this;
switch (_that) {
case _RoleChangeRequest() when $default != null:
return $default(_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoleChangeRequest implements RoleChangeRequest {
  const _RoleChangeRequest({required this.role});
  factory _RoleChangeRequest.fromJson(Map<String, dynamic> json) => _$RoleChangeRequestFromJson(json);

@override final  UserRole role;

/// Create a copy of RoleChangeRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoleChangeRequestCopyWith<_RoleChangeRequest> get copyWith => __$RoleChangeRequestCopyWithImpl<_RoleChangeRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoleChangeRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoleChangeRequest&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role);

@override
String toString() {
  return 'RoleChangeRequest(role: $role)';
}


}

/// @nodoc
abstract mixin class _$RoleChangeRequestCopyWith<$Res> implements $RoleChangeRequestCopyWith<$Res> {
  factory _$RoleChangeRequestCopyWith(_RoleChangeRequest value, $Res Function(_RoleChangeRequest) _then) = __$RoleChangeRequestCopyWithImpl;
@override @useResult
$Res call({
 UserRole role
});




}
/// @nodoc
class __$RoleChangeRequestCopyWithImpl<$Res>
    implements _$RoleChangeRequestCopyWith<$Res> {
  __$RoleChangeRequestCopyWithImpl(this._self, this._then);

  final _RoleChangeRequest _self;
  final $Res Function(_RoleChangeRequest) _then;

/// Create a copy of RoleChangeRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = null,}) {
  return _then(_RoleChangeRequest(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,
  ));
}


}

// dart format on
