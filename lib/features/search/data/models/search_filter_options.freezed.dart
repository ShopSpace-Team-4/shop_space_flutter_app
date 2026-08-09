// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_filter_options.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchFilterOptions {

 List<String> get categories; List<String> get amenities; List<String> get cities;
/// Create a copy of SearchFilterOptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchFilterOptionsCopyWith<SearchFilterOptions> get copyWith => _$SearchFilterOptionsCopyWithImpl<SearchFilterOptions>(this as SearchFilterOptions, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchFilterOptions&&const DeepCollectionEquality().equals(other.categories, categories)&&const DeepCollectionEquality().equals(other.amenities, amenities)&&const DeepCollectionEquality().equals(other.cities, cities));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(categories),const DeepCollectionEquality().hash(amenities),const DeepCollectionEquality().hash(cities));

@override
String toString() {
  return 'SearchFilterOptions(categories: $categories, amenities: $amenities, cities: $cities)';
}


}

/// @nodoc
abstract mixin class $SearchFilterOptionsCopyWith<$Res>  {
  factory $SearchFilterOptionsCopyWith(SearchFilterOptions value, $Res Function(SearchFilterOptions) _then) = _$SearchFilterOptionsCopyWithImpl;
@useResult
$Res call({
 List<String> categories, List<String> amenities, List<String> cities
});




}
/// @nodoc
class _$SearchFilterOptionsCopyWithImpl<$Res>
    implements $SearchFilterOptionsCopyWith<$Res> {
  _$SearchFilterOptionsCopyWithImpl(this._self, this._then);

  final SearchFilterOptions _self;
  final $Res Function(SearchFilterOptions) _then;

/// Create a copy of SearchFilterOptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categories = null,Object? amenities = null,Object? cities = null,}) {
  return _then(_self.copyWith(
categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,amenities: null == amenities ? _self.amenities : amenities // ignore: cast_nullable_to_non_nullable
as List<String>,cities: null == cities ? _self.cities : cities // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchFilterOptions].
extension SearchFilterOptionsPatterns on SearchFilterOptions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchFilterOptions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchFilterOptions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchFilterOptions value)  $default,){
final _that = this;
switch (_that) {
case _SearchFilterOptions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchFilterOptions value)?  $default,){
final _that = this;
switch (_that) {
case _SearchFilterOptions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> categories,  List<String> amenities,  List<String> cities)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchFilterOptions() when $default != null:
return $default(_that.categories,_that.amenities,_that.cities);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> categories,  List<String> amenities,  List<String> cities)  $default,) {final _that = this;
switch (_that) {
case _SearchFilterOptions():
return $default(_that.categories,_that.amenities,_that.cities);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> categories,  List<String> amenities,  List<String> cities)?  $default,) {final _that = this;
switch (_that) {
case _SearchFilterOptions() when $default != null:
return $default(_that.categories,_that.amenities,_that.cities);case _:
  return null;

}
}

}

/// @nodoc


class _SearchFilterOptions implements SearchFilterOptions {
  const _SearchFilterOptions({required final  List<String> categories, required final  List<String> amenities, required final  List<String> cities}): _categories = categories,_amenities = amenities,_cities = cities;
  

 final  List<String> _categories;
@override List<String> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

 final  List<String> _amenities;
@override List<String> get amenities {
  if (_amenities is EqualUnmodifiableListView) return _amenities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_amenities);
}

 final  List<String> _cities;
@override List<String> get cities {
  if (_cities is EqualUnmodifiableListView) return _cities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cities);
}


/// Create a copy of SearchFilterOptions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchFilterOptionsCopyWith<_SearchFilterOptions> get copyWith => __$SearchFilterOptionsCopyWithImpl<_SearchFilterOptions>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchFilterOptions&&const DeepCollectionEquality().equals(other._categories, _categories)&&const DeepCollectionEquality().equals(other._amenities, _amenities)&&const DeepCollectionEquality().equals(other._cities, _cities));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_amenities),const DeepCollectionEquality().hash(_cities));

@override
String toString() {
  return 'SearchFilterOptions(categories: $categories, amenities: $amenities, cities: $cities)';
}


}

/// @nodoc
abstract mixin class _$SearchFilterOptionsCopyWith<$Res> implements $SearchFilterOptionsCopyWith<$Res> {
  factory _$SearchFilterOptionsCopyWith(_SearchFilterOptions value, $Res Function(_SearchFilterOptions) _then) = __$SearchFilterOptionsCopyWithImpl;
@override @useResult
$Res call({
 List<String> categories, List<String> amenities, List<String> cities
});




}
/// @nodoc
class __$SearchFilterOptionsCopyWithImpl<$Res>
    implements _$SearchFilterOptionsCopyWith<$Res> {
  __$SearchFilterOptionsCopyWithImpl(this._self, this._then);

  final _SearchFilterOptions _self;
  final $Res Function(_SearchFilterOptions) _then;

/// Create a copy of SearchFilterOptions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categories = null,Object? amenities = null,Object? cities = null,}) {
  return _then(_SearchFilterOptions(
categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,amenities: null == amenities ? _self._amenities : amenities // ignore: cast_nullable_to_non_nullable
as List<String>,cities: null == cities ? _self._cities : cities // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
