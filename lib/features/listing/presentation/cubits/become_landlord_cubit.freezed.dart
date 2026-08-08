// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'become_landlord_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BecomeLandlordState {

 bool get isSubmitting; bool get isSuccess; Failure? get failure;
/// Create a copy of BecomeLandlordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BecomeLandlordStateCopyWith<BecomeLandlordState> get copyWith => _$BecomeLandlordStateCopyWithImpl<BecomeLandlordState>(this as BecomeLandlordState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BecomeLandlordState&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,isSubmitting,isSuccess,failure);

@override
String toString() {
  return 'BecomeLandlordState(isSubmitting: $isSubmitting, isSuccess: $isSuccess, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $BecomeLandlordStateCopyWith<$Res>  {
  factory $BecomeLandlordStateCopyWith(BecomeLandlordState value, $Res Function(BecomeLandlordState) _then) = _$BecomeLandlordStateCopyWithImpl;
@useResult
$Res call({
 bool isSubmitting, bool isSuccess, Failure? failure
});




}
/// @nodoc
class _$BecomeLandlordStateCopyWithImpl<$Res>
    implements $BecomeLandlordStateCopyWith<$Res> {
  _$BecomeLandlordStateCopyWithImpl(this._self, this._then);

  final BecomeLandlordState _self;
  final $Res Function(BecomeLandlordState) _then;

/// Create a copy of BecomeLandlordState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isSubmitting = null,Object? isSuccess = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [BecomeLandlordState].
extension BecomeLandlordStatePatterns on BecomeLandlordState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BecomeLandlordState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BecomeLandlordState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BecomeLandlordState value)  $default,){
final _that = this;
switch (_that) {
case _BecomeLandlordState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BecomeLandlordState value)?  $default,){
final _that = this;
switch (_that) {
case _BecomeLandlordState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isSubmitting,  bool isSuccess,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BecomeLandlordState() when $default != null:
return $default(_that.isSubmitting,_that.isSuccess,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isSubmitting,  bool isSuccess,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _BecomeLandlordState():
return $default(_that.isSubmitting,_that.isSuccess,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isSubmitting,  bool isSuccess,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _BecomeLandlordState() when $default != null:
return $default(_that.isSubmitting,_that.isSuccess,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _BecomeLandlordState implements BecomeLandlordState {
  const _BecomeLandlordState({this.isSubmitting = false, this.isSuccess = false, this.failure});
  

@override@JsonKey() final  bool isSubmitting;
@override@JsonKey() final  bool isSuccess;
@override final  Failure? failure;

/// Create a copy of BecomeLandlordState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BecomeLandlordStateCopyWith<_BecomeLandlordState> get copyWith => __$BecomeLandlordStateCopyWithImpl<_BecomeLandlordState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BecomeLandlordState&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,isSubmitting,isSuccess,failure);

@override
String toString() {
  return 'BecomeLandlordState(isSubmitting: $isSubmitting, isSuccess: $isSuccess, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$BecomeLandlordStateCopyWith<$Res> implements $BecomeLandlordStateCopyWith<$Res> {
  factory _$BecomeLandlordStateCopyWith(_BecomeLandlordState value, $Res Function(_BecomeLandlordState) _then) = __$BecomeLandlordStateCopyWithImpl;
@override @useResult
$Res call({
 bool isSubmitting, bool isSuccess, Failure? failure
});




}
/// @nodoc
class __$BecomeLandlordStateCopyWithImpl<$Res>
    implements _$BecomeLandlordStateCopyWith<$Res> {
  __$BecomeLandlordStateCopyWithImpl(this._self, this._then);

  final _BecomeLandlordState _self;
  final $Res Function(_BecomeLandlordState) _then;

/// Create a copy of BecomeLandlordState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isSubmitting = null,Object? isSuccess = null,Object? failure = freezed,}) {
  return _then(_BecomeLandlordState(
isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
