// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'roles_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RolesState {

 bool get isAddingRole; bool get isSwitchingRole; bool get isSuccess; User? get user; String? get errorMessage;
/// Create a copy of RolesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RolesStateCopyWith<RolesState> get copyWith => _$RolesStateCopyWithImpl<RolesState>(this as RolesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RolesState&&(identical(other.isAddingRole, isAddingRole) || other.isAddingRole == isAddingRole)&&(identical(other.isSwitchingRole, isSwitchingRole) || other.isSwitchingRole == isSwitchingRole)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.user, user) || other.user == user)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isAddingRole,isSwitchingRole,isSuccess,user,errorMessage);

@override
String toString() {
  return 'RolesState(isAddingRole: $isAddingRole, isSwitchingRole: $isSwitchingRole, isSuccess: $isSuccess, user: $user, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $RolesStateCopyWith<$Res>  {
  factory $RolesStateCopyWith(RolesState value, $Res Function(RolesState) _then) = _$RolesStateCopyWithImpl;
@useResult
$Res call({
 bool isAddingRole, bool isSwitchingRole, bool isSuccess, User? user, String? errorMessage
});


$UserCopyWith<$Res>? get user;

}
/// @nodoc
class _$RolesStateCopyWithImpl<$Res>
    implements $RolesStateCopyWith<$Res> {
  _$RolesStateCopyWithImpl(this._self, this._then);

  final RolesState _self;
  final $Res Function(RolesState) _then;

/// Create a copy of RolesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isAddingRole = null,Object? isSwitchingRole = null,Object? isSuccess = null,Object? user = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
isAddingRole: null == isAddingRole ? _self.isAddingRole : isAddingRole // ignore: cast_nullable_to_non_nullable
as bool,isSwitchingRole: null == isSwitchingRole ? _self.isSwitchingRole : isSwitchingRole // ignore: cast_nullable_to_non_nullable
as bool,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of RolesState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [RolesState].
extension RolesStatePatterns on RolesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RolesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RolesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RolesState value)  $default,){
final _that = this;
switch (_that) {
case _RolesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RolesState value)?  $default,){
final _that = this;
switch (_that) {
case _RolesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isAddingRole,  bool isSwitchingRole,  bool isSuccess,  User? user,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RolesState() when $default != null:
return $default(_that.isAddingRole,_that.isSwitchingRole,_that.isSuccess,_that.user,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isAddingRole,  bool isSwitchingRole,  bool isSuccess,  User? user,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _RolesState():
return $default(_that.isAddingRole,_that.isSwitchingRole,_that.isSuccess,_that.user,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isAddingRole,  bool isSwitchingRole,  bool isSuccess,  User? user,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _RolesState() when $default != null:
return $default(_that.isAddingRole,_that.isSwitchingRole,_that.isSuccess,_that.user,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _RolesState implements RolesState {
  const _RolesState({this.isAddingRole = false, this.isSwitchingRole = false, this.isSuccess = false, this.user, this.errorMessage});
  

@override@JsonKey() final  bool isAddingRole;
@override@JsonKey() final  bool isSwitchingRole;
@override@JsonKey() final  bool isSuccess;
@override final  User? user;
@override final  String? errorMessage;

/// Create a copy of RolesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RolesStateCopyWith<_RolesState> get copyWith => __$RolesStateCopyWithImpl<_RolesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RolesState&&(identical(other.isAddingRole, isAddingRole) || other.isAddingRole == isAddingRole)&&(identical(other.isSwitchingRole, isSwitchingRole) || other.isSwitchingRole == isSwitchingRole)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.user, user) || other.user == user)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isAddingRole,isSwitchingRole,isSuccess,user,errorMessage);

@override
String toString() {
  return 'RolesState(isAddingRole: $isAddingRole, isSwitchingRole: $isSwitchingRole, isSuccess: $isSuccess, user: $user, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$RolesStateCopyWith<$Res> implements $RolesStateCopyWith<$Res> {
  factory _$RolesStateCopyWith(_RolesState value, $Res Function(_RolesState) _then) = __$RolesStateCopyWithImpl;
@override @useResult
$Res call({
 bool isAddingRole, bool isSwitchingRole, bool isSuccess, User? user, String? errorMessage
});


@override $UserCopyWith<$Res>? get user;

}
/// @nodoc
class __$RolesStateCopyWithImpl<$Res>
    implements _$RolesStateCopyWith<$Res> {
  __$RolesStateCopyWithImpl(this._self, this._then);

  final _RolesState _self;
  final $Res Function(_RolesState) _then;

/// Create a copy of RolesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isAddingRole = null,Object? isSwitchingRole = null,Object? isSuccess = null,Object? user = freezed,Object? errorMessage = freezed,}) {
  return _then(_RolesState(
isAddingRole: null == isAddingRole ? _self.isAddingRole : isAddingRole // ignore: cast_nullable_to_non_nullable
as bool,isSwitchingRole: null == isSwitchingRole ? _self.isSwitchingRole : isSwitchingRole // ignore: cast_nullable_to_non_nullable
as bool,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of RolesState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
