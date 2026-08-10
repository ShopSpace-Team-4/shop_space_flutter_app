// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileState {

 bool get isLoading; User? get user; String? get errorMessage; bool get isLinking; bool get linkSuccess; String? get linkError; bool get isUpdating; bool get updateSuccess; String? get updateError;
/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileStateCopyWith<ProfileState> get copyWith => _$ProfileStateCopyWithImpl<ProfileState>(this as ProfileState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.user, user) || other.user == user)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isLinking, isLinking) || other.isLinking == isLinking)&&(identical(other.linkSuccess, linkSuccess) || other.linkSuccess == linkSuccess)&&(identical(other.linkError, linkError) || other.linkError == linkError)&&(identical(other.isUpdating, isUpdating) || other.isUpdating == isUpdating)&&(identical(other.updateSuccess, updateSuccess) || other.updateSuccess == updateSuccess)&&(identical(other.updateError, updateError) || other.updateError == updateError));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,user,errorMessage,isLinking,linkSuccess,linkError,isUpdating,updateSuccess,updateError);

@override
String toString() {
  return 'ProfileState(isLoading: $isLoading, user: $user, errorMessage: $errorMessage, isLinking: $isLinking, linkSuccess: $linkSuccess, linkError: $linkError, isUpdating: $isUpdating, updateSuccess: $updateSuccess, updateError: $updateError)';
}


}

/// @nodoc
abstract mixin class $ProfileStateCopyWith<$Res>  {
  factory $ProfileStateCopyWith(ProfileState value, $Res Function(ProfileState) _then) = _$ProfileStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, User? user, String? errorMessage, bool isLinking, bool linkSuccess, String? linkError, bool isUpdating, bool updateSuccess, String? updateError
});


$UserCopyWith<$Res>? get user;

}
/// @nodoc
class _$ProfileStateCopyWithImpl<$Res>
    implements $ProfileStateCopyWith<$Res> {
  _$ProfileStateCopyWithImpl(this._self, this._then);

  final ProfileState _self;
  final $Res Function(ProfileState) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? user = freezed,Object? errorMessage = freezed,Object? isLinking = null,Object? linkSuccess = null,Object? linkError = freezed,Object? isUpdating = null,Object? updateSuccess = null,Object? updateError = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isLinking: null == isLinking ? _self.isLinking : isLinking // ignore: cast_nullable_to_non_nullable
as bool,linkSuccess: null == linkSuccess ? _self.linkSuccess : linkSuccess // ignore: cast_nullable_to_non_nullable
as bool,linkError: freezed == linkError ? _self.linkError : linkError // ignore: cast_nullable_to_non_nullable
as String?,isUpdating: null == isUpdating ? _self.isUpdating : isUpdating // ignore: cast_nullable_to_non_nullable
as bool,updateSuccess: null == updateSuccess ? _self.updateSuccess : updateSuccess // ignore: cast_nullable_to_non_nullable
as bool,updateError: freezed == updateError ? _self.updateError : updateError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ProfileState
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


/// Adds pattern-matching-related methods to [ProfileState].
extension ProfileStatePatterns on ProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileState value)  $default,){
final _that = this;
switch (_that) {
case _ProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  User? user,  String? errorMessage,  bool isLinking,  bool linkSuccess,  String? linkError,  bool isUpdating,  bool updateSuccess,  String? updateError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
return $default(_that.isLoading,_that.user,_that.errorMessage,_that.isLinking,_that.linkSuccess,_that.linkError,_that.isUpdating,_that.updateSuccess,_that.updateError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  User? user,  String? errorMessage,  bool isLinking,  bool linkSuccess,  String? linkError,  bool isUpdating,  bool updateSuccess,  String? updateError)  $default,) {final _that = this;
switch (_that) {
case _ProfileState():
return $default(_that.isLoading,_that.user,_that.errorMessage,_that.isLinking,_that.linkSuccess,_that.linkError,_that.isUpdating,_that.updateSuccess,_that.updateError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  User? user,  String? errorMessage,  bool isLinking,  bool linkSuccess,  String? linkError,  bool isUpdating,  bool updateSuccess,  String? updateError)?  $default,) {final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
return $default(_that.isLoading,_that.user,_that.errorMessage,_that.isLinking,_that.linkSuccess,_that.linkError,_that.isUpdating,_that.updateSuccess,_that.updateError);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileState implements ProfileState {
  const _ProfileState({this.isLoading = false, this.user, this.errorMessage, this.isLinking = false, this.linkSuccess = false, this.linkError, this.isUpdating = false, this.updateSuccess = false, this.updateError});
  

@override@JsonKey() final  bool isLoading;
@override final  User? user;
@override final  String? errorMessage;
@override@JsonKey() final  bool isLinking;
@override@JsonKey() final  bool linkSuccess;
@override final  String? linkError;
@override@JsonKey() final  bool isUpdating;
@override@JsonKey() final  bool updateSuccess;
@override final  String? updateError;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileStateCopyWith<_ProfileState> get copyWith => __$ProfileStateCopyWithImpl<_ProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.user, user) || other.user == user)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isLinking, isLinking) || other.isLinking == isLinking)&&(identical(other.linkSuccess, linkSuccess) || other.linkSuccess == linkSuccess)&&(identical(other.linkError, linkError) || other.linkError == linkError)&&(identical(other.isUpdating, isUpdating) || other.isUpdating == isUpdating)&&(identical(other.updateSuccess, updateSuccess) || other.updateSuccess == updateSuccess)&&(identical(other.updateError, updateError) || other.updateError == updateError));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,user,errorMessage,isLinking,linkSuccess,linkError,isUpdating,updateSuccess,updateError);

@override
String toString() {
  return 'ProfileState(isLoading: $isLoading, user: $user, errorMessage: $errorMessage, isLinking: $isLinking, linkSuccess: $linkSuccess, linkError: $linkError, isUpdating: $isUpdating, updateSuccess: $updateSuccess, updateError: $updateError)';
}


}

/// @nodoc
abstract mixin class _$ProfileStateCopyWith<$Res> implements $ProfileStateCopyWith<$Res> {
  factory _$ProfileStateCopyWith(_ProfileState value, $Res Function(_ProfileState) _then) = __$ProfileStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, User? user, String? errorMessage, bool isLinking, bool linkSuccess, String? linkError, bool isUpdating, bool updateSuccess, String? updateError
});


@override $UserCopyWith<$Res>? get user;

}
/// @nodoc
class __$ProfileStateCopyWithImpl<$Res>
    implements _$ProfileStateCopyWith<$Res> {
  __$ProfileStateCopyWithImpl(this._self, this._then);

  final _ProfileState _self;
  final $Res Function(_ProfileState) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? user = freezed,Object? errorMessage = freezed,Object? isLinking = null,Object? linkSuccess = null,Object? linkError = freezed,Object? isUpdating = null,Object? updateSuccess = null,Object? updateError = freezed,}) {
  return _then(_ProfileState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isLinking: null == isLinking ? _self.isLinking : isLinking // ignore: cast_nullable_to_non_nullable
as bool,linkSuccess: null == linkSuccess ? _self.linkSuccess : linkSuccess // ignore: cast_nullable_to_non_nullable
as bool,linkError: freezed == linkError ? _self.linkError : linkError // ignore: cast_nullable_to_non_nullable
as String?,isUpdating: null == isUpdating ? _self.isUpdating : isUpdating // ignore: cast_nullable_to_non_nullable
as bool,updateSuccess: null == updateSuccess ? _self.updateSuccess : updateSuccess // ignore: cast_nullable_to_non_nullable
as bool,updateError: freezed == updateError ? _self.updateError : updateError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ProfileState
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
