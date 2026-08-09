// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'listing_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ListingDetailState {

 bool get isLoading; ShopListing? get listing;/// Set when `GET /listings/:id` surfaces [ListingNotFound] — the shop was
/// deleted or is no longer AVAILABLE (data-model §3.4).
 bool get isUnavailable; Failure? get failure;/// Set when an optimistic heart mutation fails (D8) — the surface surfaces
/// it as a localized message and then calls
/// [ListingDetailCubit.clearTransientFailure].
 Failure? get transientFailure;
/// Create a copy of ListingDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListingDetailStateCopyWith<ListingDetailState> get copyWith => _$ListingDetailStateCopyWithImpl<ListingDetailState>(this as ListingDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListingDetailState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.listing, listing) || other.listing == listing)&&(identical(other.isUnavailable, isUnavailable) || other.isUnavailable == isUnavailable)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.transientFailure, transientFailure) || other.transientFailure == transientFailure));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,listing,isUnavailable,failure,transientFailure);

@override
String toString() {
  return 'ListingDetailState(isLoading: $isLoading, listing: $listing, isUnavailable: $isUnavailable, failure: $failure, transientFailure: $transientFailure)';
}


}

/// @nodoc
abstract mixin class $ListingDetailStateCopyWith<$Res>  {
  factory $ListingDetailStateCopyWith(ListingDetailState value, $Res Function(ListingDetailState) _then) = _$ListingDetailStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, ShopListing? listing, bool isUnavailable, Failure? failure, Failure? transientFailure
});


$ShopListingCopyWith<$Res>? get listing;

}
/// @nodoc
class _$ListingDetailStateCopyWithImpl<$Res>
    implements $ListingDetailStateCopyWith<$Res> {
  _$ListingDetailStateCopyWithImpl(this._self, this._then);

  final ListingDetailState _self;
  final $Res Function(ListingDetailState) _then;

/// Create a copy of ListingDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? listing = freezed,Object? isUnavailable = null,Object? failure = freezed,Object? transientFailure = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,listing: freezed == listing ? _self.listing : listing // ignore: cast_nullable_to_non_nullable
as ShopListing?,isUnavailable: null == isUnavailable ? _self.isUnavailable : isUnavailable // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,transientFailure: freezed == transientFailure ? _self.transientFailure : transientFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of ListingDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShopListingCopyWith<$Res>? get listing {
    if (_self.listing == null) {
    return null;
  }

  return $ShopListingCopyWith<$Res>(_self.listing!, (value) {
    return _then(_self.copyWith(listing: value));
  });
}
}


/// Adds pattern-matching-related methods to [ListingDetailState].
extension ListingDetailStatePatterns on ListingDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListingDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListingDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListingDetailState value)  $default,){
final _that = this;
switch (_that) {
case _ListingDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListingDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _ListingDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  ShopListing? listing,  bool isUnavailable,  Failure? failure,  Failure? transientFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListingDetailState() when $default != null:
return $default(_that.isLoading,_that.listing,_that.isUnavailable,_that.failure,_that.transientFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  ShopListing? listing,  bool isUnavailable,  Failure? failure,  Failure? transientFailure)  $default,) {final _that = this;
switch (_that) {
case _ListingDetailState():
return $default(_that.isLoading,_that.listing,_that.isUnavailable,_that.failure,_that.transientFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  ShopListing? listing,  bool isUnavailable,  Failure? failure,  Failure? transientFailure)?  $default,) {final _that = this;
switch (_that) {
case _ListingDetailState() when $default != null:
return $default(_that.isLoading,_that.listing,_that.isUnavailable,_that.failure,_that.transientFailure);case _:
  return null;

}
}

}

/// @nodoc


class _ListingDetailState implements ListingDetailState {
  const _ListingDetailState({this.isLoading = false, this.listing, this.isUnavailable = false, this.failure, this.transientFailure});
  

@override@JsonKey() final  bool isLoading;
@override final  ShopListing? listing;
/// Set when `GET /listings/:id` surfaces [ListingNotFound] — the shop was
/// deleted or is no longer AVAILABLE (data-model §3.4).
@override@JsonKey() final  bool isUnavailable;
@override final  Failure? failure;
/// Set when an optimistic heart mutation fails (D8) — the surface surfaces
/// it as a localized message and then calls
/// [ListingDetailCubit.clearTransientFailure].
@override final  Failure? transientFailure;

/// Create a copy of ListingDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListingDetailStateCopyWith<_ListingDetailState> get copyWith => __$ListingDetailStateCopyWithImpl<_ListingDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListingDetailState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.listing, listing) || other.listing == listing)&&(identical(other.isUnavailable, isUnavailable) || other.isUnavailable == isUnavailable)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.transientFailure, transientFailure) || other.transientFailure == transientFailure));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,listing,isUnavailable,failure,transientFailure);

@override
String toString() {
  return 'ListingDetailState(isLoading: $isLoading, listing: $listing, isUnavailable: $isUnavailable, failure: $failure, transientFailure: $transientFailure)';
}


}

/// @nodoc
abstract mixin class _$ListingDetailStateCopyWith<$Res> implements $ListingDetailStateCopyWith<$Res> {
  factory _$ListingDetailStateCopyWith(_ListingDetailState value, $Res Function(_ListingDetailState) _then) = __$ListingDetailStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, ShopListing? listing, bool isUnavailable, Failure? failure, Failure? transientFailure
});


@override $ShopListingCopyWith<$Res>? get listing;

}
/// @nodoc
class __$ListingDetailStateCopyWithImpl<$Res>
    implements _$ListingDetailStateCopyWith<$Res> {
  __$ListingDetailStateCopyWithImpl(this._self, this._then);

  final _ListingDetailState _self;
  final $Res Function(_ListingDetailState) _then;

/// Create a copy of ListingDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? listing = freezed,Object? isUnavailable = null,Object? failure = freezed,Object? transientFailure = freezed,}) {
  return _then(_ListingDetailState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,listing: freezed == listing ? _self.listing : listing // ignore: cast_nullable_to_non_nullable
as ShopListing?,isUnavailable: null == isUnavailable ? _self.isUnavailable : isUnavailable // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,transientFailure: freezed == transientFailure ? _self.transientFailure : transientFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of ListingDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShopListingCopyWith<$Res>? get listing {
    if (_self.listing == null) {
    return null;
  }

  return $ShopListingCopyWith<$Res>(_self.listing!, (value) {
    return _then(_self.copyWith(listing: value));
  });
}
}

// dart format on
