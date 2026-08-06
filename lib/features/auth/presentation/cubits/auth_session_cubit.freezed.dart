// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_session_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthSessionState {

 bool get isBootstrapping;
/// Create a copy of AuthSessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthSessionStateCopyWith<AuthSessionState> get copyWith => _$AuthSessionStateCopyWithImpl<AuthSessionState>(this as AuthSessionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthSessionState&&(identical(other.isBootstrapping, isBootstrapping) || other.isBootstrapping == isBootstrapping));
}


@override
int get hashCode => Object.hash(runtimeType,isBootstrapping);

@override
String toString() {
  return 'AuthSessionState(isBootstrapping: $isBootstrapping)';
}


}

/// @nodoc
abstract mixin class $AuthSessionStateCopyWith<$Res>  {
  factory $AuthSessionStateCopyWith(AuthSessionState value, $Res Function(AuthSessionState) _then) = _$AuthSessionStateCopyWithImpl;
@useResult
$Res call({
 bool isBootstrapping
});




}
/// @nodoc
class _$AuthSessionStateCopyWithImpl<$Res>
    implements $AuthSessionStateCopyWith<$Res> {
  _$AuthSessionStateCopyWithImpl(this._self, this._then);

  final AuthSessionState _self;
  final $Res Function(AuthSessionState) _then;

/// Create a copy of AuthSessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isBootstrapping = null,}) {
  return _then(_self.copyWith(
isBootstrapping: null == isBootstrapping ? _self.isBootstrapping : isBootstrapping // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthSessionState].
extension AuthSessionStatePatterns on AuthSessionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthSessionUnauthenticated value)?  unauthenticated,TResult Function( AuthSessionAuthenticated value)?  authenticated,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthSessionUnauthenticated() when unauthenticated != null:
return unauthenticated(_that);case AuthSessionAuthenticated() when authenticated != null:
return authenticated(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthSessionUnauthenticated value)  unauthenticated,required TResult Function( AuthSessionAuthenticated value)  authenticated,}){
final _that = this;
switch (_that) {
case AuthSessionUnauthenticated():
return unauthenticated(_that);case AuthSessionAuthenticated():
return authenticated(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthSessionUnauthenticated value)?  unauthenticated,TResult? Function( AuthSessionAuthenticated value)?  authenticated,}){
final _that = this;
switch (_that) {
case AuthSessionUnauthenticated() when unauthenticated != null:
return unauthenticated(_that);case AuthSessionAuthenticated() when authenticated != null:
return authenticated(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool isBootstrapping)?  unauthenticated,TResult Function( Set<String> roles,  UserRole activeRole,  bool isVerified,  bool isHydrating,  bool isBootstrapping)?  authenticated,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthSessionUnauthenticated() when unauthenticated != null:
return unauthenticated(_that.isBootstrapping);case AuthSessionAuthenticated() when authenticated != null:
return authenticated(_that.roles,_that.activeRole,_that.isVerified,_that.isHydrating,_that.isBootstrapping);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool isBootstrapping)  unauthenticated,required TResult Function( Set<String> roles,  UserRole activeRole,  bool isVerified,  bool isHydrating,  bool isBootstrapping)  authenticated,}) {final _that = this;
switch (_that) {
case AuthSessionUnauthenticated():
return unauthenticated(_that.isBootstrapping);case AuthSessionAuthenticated():
return authenticated(_that.roles,_that.activeRole,_that.isVerified,_that.isHydrating,_that.isBootstrapping);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool isBootstrapping)?  unauthenticated,TResult? Function( Set<String> roles,  UserRole activeRole,  bool isVerified,  bool isHydrating,  bool isBootstrapping)?  authenticated,}) {final _that = this;
switch (_that) {
case AuthSessionUnauthenticated() when unauthenticated != null:
return unauthenticated(_that.isBootstrapping);case AuthSessionAuthenticated() when authenticated != null:
return authenticated(_that.roles,_that.activeRole,_that.isVerified,_that.isHydrating,_that.isBootstrapping);case _:
  return null;

}
}

}

/// @nodoc


class AuthSessionUnauthenticated implements AuthSessionState {
  const AuthSessionUnauthenticated({this.isBootstrapping = false});
  

@override@JsonKey() final  bool isBootstrapping;

/// Create a copy of AuthSessionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthSessionUnauthenticatedCopyWith<AuthSessionUnauthenticated> get copyWith => _$AuthSessionUnauthenticatedCopyWithImpl<AuthSessionUnauthenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthSessionUnauthenticated&&(identical(other.isBootstrapping, isBootstrapping) || other.isBootstrapping == isBootstrapping));
}


@override
int get hashCode => Object.hash(runtimeType,isBootstrapping);

@override
String toString() {
  return 'AuthSessionState.unauthenticated(isBootstrapping: $isBootstrapping)';
}


}

/// @nodoc
abstract mixin class $AuthSessionUnauthenticatedCopyWith<$Res> implements $AuthSessionStateCopyWith<$Res> {
  factory $AuthSessionUnauthenticatedCopyWith(AuthSessionUnauthenticated value, $Res Function(AuthSessionUnauthenticated) _then) = _$AuthSessionUnauthenticatedCopyWithImpl;
@override @useResult
$Res call({
 bool isBootstrapping
});




}
/// @nodoc
class _$AuthSessionUnauthenticatedCopyWithImpl<$Res>
    implements $AuthSessionUnauthenticatedCopyWith<$Res> {
  _$AuthSessionUnauthenticatedCopyWithImpl(this._self, this._then);

  final AuthSessionUnauthenticated _self;
  final $Res Function(AuthSessionUnauthenticated) _then;

/// Create a copy of AuthSessionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isBootstrapping = null,}) {
  return _then(AuthSessionUnauthenticated(
isBootstrapping: null == isBootstrapping ? _self.isBootstrapping : isBootstrapping // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class AuthSessionAuthenticated implements AuthSessionState {
  const AuthSessionAuthenticated({final  Set<String> roles = const <String>{}, this.activeRole = UserRole.tenant, this.isVerified = false, this.isHydrating = true, this.isBootstrapping = false}): _roles = roles;
  

 final  Set<String> _roles;
@JsonKey() Set<String> get roles {
  if (_roles is EqualUnmodifiableSetView) return _roles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_roles);
}

@JsonKey() final  UserRole activeRole;
@JsonKey() final  bool isVerified;
@JsonKey() final  bool isHydrating;
@override@JsonKey() final  bool isBootstrapping;

/// Create a copy of AuthSessionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthSessionAuthenticatedCopyWith<AuthSessionAuthenticated> get copyWith => _$AuthSessionAuthenticatedCopyWithImpl<AuthSessionAuthenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthSessionAuthenticated&&const DeepCollectionEquality().equals(other._roles, _roles)&&(identical(other.activeRole, activeRole) || other.activeRole == activeRole)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.isHydrating, isHydrating) || other.isHydrating == isHydrating)&&(identical(other.isBootstrapping, isBootstrapping) || other.isBootstrapping == isBootstrapping));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_roles),activeRole,isVerified,isHydrating,isBootstrapping);

@override
String toString() {
  return 'AuthSessionState.authenticated(roles: $roles, activeRole: $activeRole, isVerified: $isVerified, isHydrating: $isHydrating, isBootstrapping: $isBootstrapping)';
}


}

/// @nodoc
abstract mixin class $AuthSessionAuthenticatedCopyWith<$Res> implements $AuthSessionStateCopyWith<$Res> {
  factory $AuthSessionAuthenticatedCopyWith(AuthSessionAuthenticated value, $Res Function(AuthSessionAuthenticated) _then) = _$AuthSessionAuthenticatedCopyWithImpl;
@override @useResult
$Res call({
 Set<String> roles, UserRole activeRole, bool isVerified, bool isHydrating, bool isBootstrapping
});




}
/// @nodoc
class _$AuthSessionAuthenticatedCopyWithImpl<$Res>
    implements $AuthSessionAuthenticatedCopyWith<$Res> {
  _$AuthSessionAuthenticatedCopyWithImpl(this._self, this._then);

  final AuthSessionAuthenticated _self;
  final $Res Function(AuthSessionAuthenticated) _then;

/// Create a copy of AuthSessionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? roles = null,Object? activeRole = null,Object? isVerified = null,Object? isHydrating = null,Object? isBootstrapping = null,}) {
  return _then(AuthSessionAuthenticated(
roles: null == roles ? _self._roles : roles // ignore: cast_nullable_to_non_nullable
as Set<String>,activeRole: null == activeRole ? _self.activeRole : activeRole // ignore: cast_nullable_to_non_nullable
as UserRole,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,isHydrating: null == isHydrating ? _self.isHydrating : isHydrating // ignore: cast_nullable_to_non_nullable
as bool,isBootstrapping: null == isBootstrapping ? _self.isBootstrapping : isBootstrapping // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
