// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'active_role_update_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActiveRoleUpdateRequest {

 UserRole get role;
/// Create a copy of ActiveRoleUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActiveRoleUpdateRequestCopyWith<ActiveRoleUpdateRequest> get copyWith => _$ActiveRoleUpdateRequestCopyWithImpl<ActiveRoleUpdateRequest>(this as ActiveRoleUpdateRequest, _$identity);

  /// Serializes this ActiveRoleUpdateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActiveRoleUpdateRequest&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role);

@override
String toString() {
  return 'ActiveRoleUpdateRequest(role: $role)';
}


}

/// @nodoc
abstract mixin class $ActiveRoleUpdateRequestCopyWith<$Res>  {
  factory $ActiveRoleUpdateRequestCopyWith(ActiveRoleUpdateRequest value, $Res Function(ActiveRoleUpdateRequest) _then) = _$ActiveRoleUpdateRequestCopyWithImpl;
@useResult
$Res call({
 UserRole role
});




}
/// @nodoc
class _$ActiveRoleUpdateRequestCopyWithImpl<$Res>
    implements $ActiveRoleUpdateRequestCopyWith<$Res> {
  _$ActiveRoleUpdateRequestCopyWithImpl(this._self, this._then);

  final ActiveRoleUpdateRequest _self;
  final $Res Function(ActiveRoleUpdateRequest) _then;

/// Create a copy of ActiveRoleUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = null,}) {
  return _then(_self.copyWith(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,
  ));
}

}


/// Adds pattern-matching-related methods to [ActiveRoleUpdateRequest].
extension ActiveRoleUpdateRequestPatterns on ActiveRoleUpdateRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActiveRoleUpdateRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActiveRoleUpdateRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActiveRoleUpdateRequest value)  $default,){
final _that = this;
switch (_that) {
case _ActiveRoleUpdateRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActiveRoleUpdateRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ActiveRoleUpdateRequest() when $default != null:
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
case _ActiveRoleUpdateRequest() when $default != null:
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
case _ActiveRoleUpdateRequest():
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
case _ActiveRoleUpdateRequest() when $default != null:
return $default(_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActiveRoleUpdateRequest implements ActiveRoleUpdateRequest {
  const _ActiveRoleUpdateRequest({required this.role});
  factory _ActiveRoleUpdateRequest.fromJson(Map<String, dynamic> json) => _$ActiveRoleUpdateRequestFromJson(json);

@override final  UserRole role;

/// Create a copy of ActiveRoleUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActiveRoleUpdateRequestCopyWith<_ActiveRoleUpdateRequest> get copyWith => __$ActiveRoleUpdateRequestCopyWithImpl<_ActiveRoleUpdateRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActiveRoleUpdateRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActiveRoleUpdateRequest&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role);

@override
String toString() {
  return 'ActiveRoleUpdateRequest(role: $role)';
}


}

/// @nodoc
abstract mixin class _$ActiveRoleUpdateRequestCopyWith<$Res> implements $ActiveRoleUpdateRequestCopyWith<$Res> {
  factory _$ActiveRoleUpdateRequestCopyWith(_ActiveRoleUpdateRequest value, $Res Function(_ActiveRoleUpdateRequest) _then) = __$ActiveRoleUpdateRequestCopyWithImpl;
@override @useResult
$Res call({
 UserRole role
});




}
/// @nodoc
class __$ActiveRoleUpdateRequestCopyWithImpl<$Res>
    implements _$ActiveRoleUpdateRequestCopyWith<$Res> {
  __$ActiveRoleUpdateRequestCopyWithImpl(this._self, this._then);

  final _ActiveRoleUpdateRequest _self;
  final $Res Function(_ActiveRoleUpdateRequest) _then;

/// Create a copy of ActiveRoleUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = null,}) {
  return _then(_ActiveRoleUpdateRequest(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,
  ));
}


}

// dart format on
