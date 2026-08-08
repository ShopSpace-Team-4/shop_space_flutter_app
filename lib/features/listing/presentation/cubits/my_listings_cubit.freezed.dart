// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_listings_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MyListingsState {

 bool get isLoading; List<ListingSummary> get listings; Failure? get listFailure; bool get isSubmitting; Failure? get statusFailure; Failure? get deleteFailure; bool get detailLoading; ShopListing? get detail; Failure? get detailFailure;
/// Create a copy of MyListingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyListingsStateCopyWith<MyListingsState> get copyWith => _$MyListingsStateCopyWithImpl<MyListingsState>(this as MyListingsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyListingsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.listings, listings)&&(identical(other.listFailure, listFailure) || other.listFailure == listFailure)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.statusFailure, statusFailure) || other.statusFailure == statusFailure)&&(identical(other.deleteFailure, deleteFailure) || other.deleteFailure == deleteFailure)&&(identical(other.detailLoading, detailLoading) || other.detailLoading == detailLoading)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.detailFailure, detailFailure) || other.detailFailure == detailFailure));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(listings),listFailure,isSubmitting,statusFailure,deleteFailure,detailLoading,detail,detailFailure);

@override
String toString() {
  return 'MyListingsState(isLoading: $isLoading, listings: $listings, listFailure: $listFailure, isSubmitting: $isSubmitting, statusFailure: $statusFailure, deleteFailure: $deleteFailure, detailLoading: $detailLoading, detail: $detail, detailFailure: $detailFailure)';
}


}

/// @nodoc
abstract mixin class $MyListingsStateCopyWith<$Res>  {
  factory $MyListingsStateCopyWith(MyListingsState value, $Res Function(MyListingsState) _then) = _$MyListingsStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, List<ListingSummary> listings, Failure? listFailure, bool isSubmitting, Failure? statusFailure, Failure? deleteFailure, bool detailLoading, ShopListing? detail, Failure? detailFailure
});


$ShopListingCopyWith<$Res>? get detail;

}
/// @nodoc
class _$MyListingsStateCopyWithImpl<$Res>
    implements $MyListingsStateCopyWith<$Res> {
  _$MyListingsStateCopyWithImpl(this._self, this._then);

  final MyListingsState _self;
  final $Res Function(MyListingsState) _then;

/// Create a copy of MyListingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? listings = null,Object? listFailure = freezed,Object? isSubmitting = null,Object? statusFailure = freezed,Object? deleteFailure = freezed,Object? detailLoading = null,Object? detail = freezed,Object? detailFailure = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,listings: null == listings ? _self.listings : listings // ignore: cast_nullable_to_non_nullable
as List<ListingSummary>,listFailure: freezed == listFailure ? _self.listFailure : listFailure // ignore: cast_nullable_to_non_nullable
as Failure?,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,statusFailure: freezed == statusFailure ? _self.statusFailure : statusFailure // ignore: cast_nullable_to_non_nullable
as Failure?,deleteFailure: freezed == deleteFailure ? _self.deleteFailure : deleteFailure // ignore: cast_nullable_to_non_nullable
as Failure?,detailLoading: null == detailLoading ? _self.detailLoading : detailLoading // ignore: cast_nullable_to_non_nullable
as bool,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as ShopListing?,detailFailure: freezed == detailFailure ? _self.detailFailure : detailFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of MyListingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShopListingCopyWith<$Res>? get detail {
    if (_self.detail == null) {
    return null;
  }

  return $ShopListingCopyWith<$Res>(_self.detail!, (value) {
    return _then(_self.copyWith(detail: value));
  });
}
}


/// Adds pattern-matching-related methods to [MyListingsState].
extension MyListingsStatePatterns on MyListingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyListingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyListingsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyListingsState value)  $default,){
final _that = this;
switch (_that) {
case _MyListingsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyListingsState value)?  $default,){
final _that = this;
switch (_that) {
case _MyListingsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  List<ListingSummary> listings,  Failure? listFailure,  bool isSubmitting,  Failure? statusFailure,  Failure? deleteFailure,  bool detailLoading,  ShopListing? detail,  Failure? detailFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyListingsState() when $default != null:
return $default(_that.isLoading,_that.listings,_that.listFailure,_that.isSubmitting,_that.statusFailure,_that.deleteFailure,_that.detailLoading,_that.detail,_that.detailFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  List<ListingSummary> listings,  Failure? listFailure,  bool isSubmitting,  Failure? statusFailure,  Failure? deleteFailure,  bool detailLoading,  ShopListing? detail,  Failure? detailFailure)  $default,) {final _that = this;
switch (_that) {
case _MyListingsState():
return $default(_that.isLoading,_that.listings,_that.listFailure,_that.isSubmitting,_that.statusFailure,_that.deleteFailure,_that.detailLoading,_that.detail,_that.detailFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  List<ListingSummary> listings,  Failure? listFailure,  bool isSubmitting,  Failure? statusFailure,  Failure? deleteFailure,  bool detailLoading,  ShopListing? detail,  Failure? detailFailure)?  $default,) {final _that = this;
switch (_that) {
case _MyListingsState() when $default != null:
return $default(_that.isLoading,_that.listings,_that.listFailure,_that.isSubmitting,_that.statusFailure,_that.deleteFailure,_that.detailLoading,_that.detail,_that.detailFailure);case _:
  return null;

}
}

}

/// @nodoc


class _MyListingsState implements MyListingsState {
  const _MyListingsState({this.isLoading = false, final  List<ListingSummary> listings = const [], this.listFailure, this.isSubmitting = false, this.statusFailure, this.deleteFailure, this.detailLoading = false, this.detail, this.detailFailure}): _listings = listings;
  

@override@JsonKey() final  bool isLoading;
 final  List<ListingSummary> _listings;
@override@JsonKey() List<ListingSummary> get listings {
  if (_listings is EqualUnmodifiableListView) return _listings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_listings);
}

@override final  Failure? listFailure;
@override@JsonKey() final  bool isSubmitting;
@override final  Failure? statusFailure;
@override final  Failure? deleteFailure;
@override@JsonKey() final  bool detailLoading;
@override final  ShopListing? detail;
@override final  Failure? detailFailure;

/// Create a copy of MyListingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyListingsStateCopyWith<_MyListingsState> get copyWith => __$MyListingsStateCopyWithImpl<_MyListingsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyListingsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._listings, _listings)&&(identical(other.listFailure, listFailure) || other.listFailure == listFailure)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.statusFailure, statusFailure) || other.statusFailure == statusFailure)&&(identical(other.deleteFailure, deleteFailure) || other.deleteFailure == deleteFailure)&&(identical(other.detailLoading, detailLoading) || other.detailLoading == detailLoading)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.detailFailure, detailFailure) || other.detailFailure == detailFailure));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_listings),listFailure,isSubmitting,statusFailure,deleteFailure,detailLoading,detail,detailFailure);

@override
String toString() {
  return 'MyListingsState(isLoading: $isLoading, listings: $listings, listFailure: $listFailure, isSubmitting: $isSubmitting, statusFailure: $statusFailure, deleteFailure: $deleteFailure, detailLoading: $detailLoading, detail: $detail, detailFailure: $detailFailure)';
}


}

/// @nodoc
abstract mixin class _$MyListingsStateCopyWith<$Res> implements $MyListingsStateCopyWith<$Res> {
  factory _$MyListingsStateCopyWith(_MyListingsState value, $Res Function(_MyListingsState) _then) = __$MyListingsStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<ListingSummary> listings, Failure? listFailure, bool isSubmitting, Failure? statusFailure, Failure? deleteFailure, bool detailLoading, ShopListing? detail, Failure? detailFailure
});


@override $ShopListingCopyWith<$Res>? get detail;

}
/// @nodoc
class __$MyListingsStateCopyWithImpl<$Res>
    implements _$MyListingsStateCopyWith<$Res> {
  __$MyListingsStateCopyWithImpl(this._self, this._then);

  final _MyListingsState _self;
  final $Res Function(_MyListingsState) _then;

/// Create a copy of MyListingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? listings = null,Object? listFailure = freezed,Object? isSubmitting = null,Object? statusFailure = freezed,Object? deleteFailure = freezed,Object? detailLoading = null,Object? detail = freezed,Object? detailFailure = freezed,}) {
  return _then(_MyListingsState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,listings: null == listings ? _self._listings : listings // ignore: cast_nullable_to_non_nullable
as List<ListingSummary>,listFailure: freezed == listFailure ? _self.listFailure : listFailure // ignore: cast_nullable_to_non_nullable
as Failure?,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,statusFailure: freezed == statusFailure ? _self.statusFailure : statusFailure // ignore: cast_nullable_to_non_nullable
as Failure?,deleteFailure: freezed == deleteFailure ? _self.deleteFailure : deleteFailure // ignore: cast_nullable_to_non_nullable
as Failure?,detailLoading: null == detailLoading ? _self.detailLoading : detailLoading // ignore: cast_nullable_to_non_nullable
as bool,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as ShopListing?,detailFailure: freezed == detailFailure ? _self.detailFailure : detailFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of MyListingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShopListingCopyWith<$Res>? get detail {
    if (_self.detail == null) {
    return null;
  }

  return $ShopListingCopyWith<$Res>(_self.detail!, (value) {
    return _then(_self.copyWith(detail: value));
  });
}
}

// dart format on
