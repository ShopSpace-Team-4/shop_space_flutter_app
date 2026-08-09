// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchState {

 bool get isLoadingOptions; SearchFilterOptions? get options; Failure? get optionsFailure; SearchFilters get filters; List<BrowseListing> get items; bool get isLoading; bool get isLoadingMore; bool get hasMore; bool get loaded; Failure? get failure;/// Set when an optimistic heart mutation fails (D8) — the screen surfaces
/// it as a localized message and then calls [SearchCubit.clearTransientFailure].
 Failure? get transientFailure;
/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchStateCopyWith<SearchState> get copyWith => _$SearchStateCopyWithImpl<SearchState>(this as SearchState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchState&&(identical(other.isLoadingOptions, isLoadingOptions) || other.isLoadingOptions == isLoadingOptions)&&(identical(other.options, options) || other.options == options)&&(identical(other.optionsFailure, optionsFailure) || other.optionsFailure == optionsFailure)&&(identical(other.filters, filters) || other.filters == filters)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.loaded, loaded) || other.loaded == loaded)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.transientFailure, transientFailure) || other.transientFailure == transientFailure));
}


@override
int get hashCode => Object.hash(runtimeType,isLoadingOptions,options,optionsFailure,filters,const DeepCollectionEquality().hash(items),isLoading,isLoadingMore,hasMore,loaded,failure,transientFailure);

@override
String toString() {
  return 'SearchState(isLoadingOptions: $isLoadingOptions, options: $options, optionsFailure: $optionsFailure, filters: $filters, items: $items, isLoading: $isLoading, isLoadingMore: $isLoadingMore, hasMore: $hasMore, loaded: $loaded, failure: $failure, transientFailure: $transientFailure)';
}


}

/// @nodoc
abstract mixin class $SearchStateCopyWith<$Res>  {
  factory $SearchStateCopyWith(SearchState value, $Res Function(SearchState) _then) = _$SearchStateCopyWithImpl;
@useResult
$Res call({
 bool isLoadingOptions, SearchFilterOptions? options, Failure? optionsFailure, SearchFilters filters, List<BrowseListing> items, bool isLoading, bool isLoadingMore, bool hasMore, bool loaded, Failure? failure, Failure? transientFailure
});


$SearchFilterOptionsCopyWith<$Res>? get options;$SearchFiltersCopyWith<$Res> get filters;

}
/// @nodoc
class _$SearchStateCopyWithImpl<$Res>
    implements $SearchStateCopyWith<$Res> {
  _$SearchStateCopyWithImpl(this._self, this._then);

  final SearchState _self;
  final $Res Function(SearchState) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoadingOptions = null,Object? options = freezed,Object? optionsFailure = freezed,Object? filters = null,Object? items = null,Object? isLoading = null,Object? isLoadingMore = null,Object? hasMore = null,Object? loaded = null,Object? failure = freezed,Object? transientFailure = freezed,}) {
  return _then(_self.copyWith(
isLoadingOptions: null == isLoadingOptions ? _self.isLoadingOptions : isLoadingOptions // ignore: cast_nullable_to_non_nullable
as bool,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as SearchFilterOptions?,optionsFailure: freezed == optionsFailure ? _self.optionsFailure : optionsFailure // ignore: cast_nullable_to_non_nullable
as Failure?,filters: null == filters ? _self.filters : filters // ignore: cast_nullable_to_non_nullable
as SearchFilters,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<BrowseListing>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,transientFailure: freezed == transientFailure ? _self.transientFailure : transientFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchFilterOptionsCopyWith<$Res>? get options {
    if (_self.options == null) {
    return null;
  }

  return $SearchFilterOptionsCopyWith<$Res>(_self.options!, (value) {
    return _then(_self.copyWith(options: value));
  });
}/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchFiltersCopyWith<$Res> get filters {
  
  return $SearchFiltersCopyWith<$Res>(_self.filters, (value) {
    return _then(_self.copyWith(filters: value));
  });
}
}


/// Adds pattern-matching-related methods to [SearchState].
extension SearchStatePatterns on SearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchState value)  $default,){
final _that = this;
switch (_that) {
case _SearchState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchState value)?  $default,){
final _that = this;
switch (_that) {
case _SearchState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoadingOptions,  SearchFilterOptions? options,  Failure? optionsFailure,  SearchFilters filters,  List<BrowseListing> items,  bool isLoading,  bool isLoadingMore,  bool hasMore,  bool loaded,  Failure? failure,  Failure? transientFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchState() when $default != null:
return $default(_that.isLoadingOptions,_that.options,_that.optionsFailure,_that.filters,_that.items,_that.isLoading,_that.isLoadingMore,_that.hasMore,_that.loaded,_that.failure,_that.transientFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoadingOptions,  SearchFilterOptions? options,  Failure? optionsFailure,  SearchFilters filters,  List<BrowseListing> items,  bool isLoading,  bool isLoadingMore,  bool hasMore,  bool loaded,  Failure? failure,  Failure? transientFailure)  $default,) {final _that = this;
switch (_that) {
case _SearchState():
return $default(_that.isLoadingOptions,_that.options,_that.optionsFailure,_that.filters,_that.items,_that.isLoading,_that.isLoadingMore,_that.hasMore,_that.loaded,_that.failure,_that.transientFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoadingOptions,  SearchFilterOptions? options,  Failure? optionsFailure,  SearchFilters filters,  List<BrowseListing> items,  bool isLoading,  bool isLoadingMore,  bool hasMore,  bool loaded,  Failure? failure,  Failure? transientFailure)?  $default,) {final _that = this;
switch (_that) {
case _SearchState() when $default != null:
return $default(_that.isLoadingOptions,_that.options,_that.optionsFailure,_that.filters,_that.items,_that.isLoading,_that.isLoadingMore,_that.hasMore,_that.loaded,_that.failure,_that.transientFailure);case _:
  return null;

}
}

}

/// @nodoc


class _SearchState implements SearchState {
  const _SearchState({this.isLoadingOptions = false, this.options, this.optionsFailure, this.filters = const SearchFilters(), final  List<BrowseListing> items = const <BrowseListing>[], this.isLoading = false, this.isLoadingMore = false, this.hasMore = false, this.loaded = false, this.failure, this.transientFailure}): _items = items;
  

@override@JsonKey() final  bool isLoadingOptions;
@override final  SearchFilterOptions? options;
@override final  Failure? optionsFailure;
@override@JsonKey() final  SearchFilters filters;
 final  List<BrowseListing> _items;
@override@JsonKey() List<BrowseListing> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  bool hasMore;
@override@JsonKey() final  bool loaded;
@override final  Failure? failure;
/// Set when an optimistic heart mutation fails (D8) — the screen surfaces
/// it as a localized message and then calls [SearchCubit.clearTransientFailure].
@override final  Failure? transientFailure;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchStateCopyWith<_SearchState> get copyWith => __$SearchStateCopyWithImpl<_SearchState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchState&&(identical(other.isLoadingOptions, isLoadingOptions) || other.isLoadingOptions == isLoadingOptions)&&(identical(other.options, options) || other.options == options)&&(identical(other.optionsFailure, optionsFailure) || other.optionsFailure == optionsFailure)&&(identical(other.filters, filters) || other.filters == filters)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.loaded, loaded) || other.loaded == loaded)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.transientFailure, transientFailure) || other.transientFailure == transientFailure));
}


@override
int get hashCode => Object.hash(runtimeType,isLoadingOptions,options,optionsFailure,filters,const DeepCollectionEquality().hash(_items),isLoading,isLoadingMore,hasMore,loaded,failure,transientFailure);

@override
String toString() {
  return 'SearchState(isLoadingOptions: $isLoadingOptions, options: $options, optionsFailure: $optionsFailure, filters: $filters, items: $items, isLoading: $isLoading, isLoadingMore: $isLoadingMore, hasMore: $hasMore, loaded: $loaded, failure: $failure, transientFailure: $transientFailure)';
}


}

/// @nodoc
abstract mixin class _$SearchStateCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory _$SearchStateCopyWith(_SearchState value, $Res Function(_SearchState) _then) = __$SearchStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoadingOptions, SearchFilterOptions? options, Failure? optionsFailure, SearchFilters filters, List<BrowseListing> items, bool isLoading, bool isLoadingMore, bool hasMore, bool loaded, Failure? failure, Failure? transientFailure
});


@override $SearchFilterOptionsCopyWith<$Res>? get options;@override $SearchFiltersCopyWith<$Res> get filters;

}
/// @nodoc
class __$SearchStateCopyWithImpl<$Res>
    implements _$SearchStateCopyWith<$Res> {
  __$SearchStateCopyWithImpl(this._self, this._then);

  final _SearchState _self;
  final $Res Function(_SearchState) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoadingOptions = null,Object? options = freezed,Object? optionsFailure = freezed,Object? filters = null,Object? items = null,Object? isLoading = null,Object? isLoadingMore = null,Object? hasMore = null,Object? loaded = null,Object? failure = freezed,Object? transientFailure = freezed,}) {
  return _then(_SearchState(
isLoadingOptions: null == isLoadingOptions ? _self.isLoadingOptions : isLoadingOptions // ignore: cast_nullable_to_non_nullable
as bool,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as SearchFilterOptions?,optionsFailure: freezed == optionsFailure ? _self.optionsFailure : optionsFailure // ignore: cast_nullable_to_non_nullable
as Failure?,filters: null == filters ? _self.filters : filters // ignore: cast_nullable_to_non_nullable
as SearchFilters,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<BrowseListing>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,transientFailure: freezed == transientFailure ? _self.transientFailure : transientFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchFilterOptionsCopyWith<$Res>? get options {
    if (_self.options == null) {
    return null;
  }

  return $SearchFilterOptionsCopyWith<$Res>(_self.options!, (value) {
    return _then(_self.copyWith(options: value));
  });
}/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchFiltersCopyWith<$Res> get filters {
  
  return $SearchFiltersCopyWith<$Res>(_self.filters, (value) {
    return _then(_self.copyWith(filters: value));
  });
}
}

// dart format on
