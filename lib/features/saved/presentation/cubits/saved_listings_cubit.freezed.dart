// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_listings_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SavedListingsState {

 bool get isLoading; bool get loaded; List<SavedListing> get items; Failure? get failure; Failure? get transientFailure;
/// Create a copy of SavedListingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedListingsStateCopyWith<SavedListingsState> get copyWith => _$SavedListingsStateCopyWithImpl<SavedListingsState>(this as SavedListingsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedListingsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.loaded, loaded) || other.loaded == loaded)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.transientFailure, transientFailure) || other.transientFailure == transientFailure));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,loaded,const DeepCollectionEquality().hash(items),failure,transientFailure);

@override
String toString() {
  return 'SavedListingsState(isLoading: $isLoading, loaded: $loaded, items: $items, failure: $failure, transientFailure: $transientFailure)';
}


}

/// @nodoc
abstract mixin class $SavedListingsStateCopyWith<$Res>  {
  factory $SavedListingsStateCopyWith(SavedListingsState value, $Res Function(SavedListingsState) _then) = _$SavedListingsStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool loaded, List<SavedListing> items, Failure? failure, Failure? transientFailure
});




}
/// @nodoc
class _$SavedListingsStateCopyWithImpl<$Res>
    implements $SavedListingsStateCopyWith<$Res> {
  _$SavedListingsStateCopyWithImpl(this._self, this._then);

  final SavedListingsState _self;
  final $Res Function(SavedListingsState) _then;

/// Create a copy of SavedListingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? loaded = null,Object? items = null,Object? failure = freezed,Object? transientFailure = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as bool,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<SavedListing>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,transientFailure: freezed == transientFailure ? _self.transientFailure : transientFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [SavedListingsState].
extension SavedListingsStatePatterns on SavedListingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavedListingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavedListingsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavedListingsState value)  $default,){
final _that = this;
switch (_that) {
case _SavedListingsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavedListingsState value)?  $default,){
final _that = this;
switch (_that) {
case _SavedListingsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool loaded,  List<SavedListing> items,  Failure? failure,  Failure? transientFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavedListingsState() when $default != null:
return $default(_that.isLoading,_that.loaded,_that.items,_that.failure,_that.transientFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool loaded,  List<SavedListing> items,  Failure? failure,  Failure? transientFailure)  $default,) {final _that = this;
switch (_that) {
case _SavedListingsState():
return $default(_that.isLoading,_that.loaded,_that.items,_that.failure,_that.transientFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool loaded,  List<SavedListing> items,  Failure? failure,  Failure? transientFailure)?  $default,) {final _that = this;
switch (_that) {
case _SavedListingsState() when $default != null:
return $default(_that.isLoading,_that.loaded,_that.items,_that.failure,_that.transientFailure);case _:
  return null;

}
}

}

/// @nodoc


class _SavedListingsState implements SavedListingsState {
  const _SavedListingsState({this.isLoading = false, this.loaded = false, final  List<SavedListing> items = const <SavedListing>[], this.failure, this.transientFailure}): _items = items;
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool loaded;
 final  List<SavedListing> _items;
@override@JsonKey() List<SavedListing> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  Failure? failure;
@override final  Failure? transientFailure;

/// Create a copy of SavedListingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavedListingsStateCopyWith<_SavedListingsState> get copyWith => __$SavedListingsStateCopyWithImpl<_SavedListingsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavedListingsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.loaded, loaded) || other.loaded == loaded)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.transientFailure, transientFailure) || other.transientFailure == transientFailure));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,loaded,const DeepCollectionEquality().hash(_items),failure,transientFailure);

@override
String toString() {
  return 'SavedListingsState(isLoading: $isLoading, loaded: $loaded, items: $items, failure: $failure, transientFailure: $transientFailure)';
}


}

/// @nodoc
abstract mixin class _$SavedListingsStateCopyWith<$Res> implements $SavedListingsStateCopyWith<$Res> {
  factory _$SavedListingsStateCopyWith(_SavedListingsState value, $Res Function(_SavedListingsState) _then) = __$SavedListingsStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool loaded, List<SavedListing> items, Failure? failure, Failure? transientFailure
});




}
/// @nodoc
class __$SavedListingsStateCopyWithImpl<$Res>
    implements _$SavedListingsStateCopyWith<$Res> {
  __$SavedListingsStateCopyWithImpl(this._self, this._then);

  final _SavedListingsState _self;
  final $Res Function(_SavedListingsState) _then;

/// Create a copy of SavedListingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? loaded = null,Object? items = null,Object? failure = freezed,Object? transientFailure = freezed,}) {
  return _then(_SavedListingsState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as bool,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SavedListing>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,transientFailure: freezed == transientFailure ? _self.transientFailure : transientFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
