// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_filters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchFilters {

 String? get city; String? get district; String? get category; double? get priceMin; double? get priceMax; double? get areaMin; double? get areaMax; List<String> get amenities; String? get sort; int get page; int get limit;
/// Create a copy of SearchFilters
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchFiltersCopyWith<SearchFilters> get copyWith => _$SearchFiltersCopyWithImpl<SearchFilters>(this as SearchFilters, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchFilters&&(identical(other.city, city) || other.city == city)&&(identical(other.district, district) || other.district == district)&&(identical(other.category, category) || other.category == category)&&(identical(other.priceMin, priceMin) || other.priceMin == priceMin)&&(identical(other.priceMax, priceMax) || other.priceMax == priceMax)&&(identical(other.areaMin, areaMin) || other.areaMin == areaMin)&&(identical(other.areaMax, areaMax) || other.areaMax == areaMax)&&const DeepCollectionEquality().equals(other.amenities, amenities)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit));
}


@override
int get hashCode => Object.hash(runtimeType,city,district,category,priceMin,priceMax,areaMin,areaMax,const DeepCollectionEquality().hash(amenities),sort,page,limit);

@override
String toString() {
  return 'SearchFilters(city: $city, district: $district, category: $category, priceMin: $priceMin, priceMax: $priceMax, areaMin: $areaMin, areaMax: $areaMax, amenities: $amenities, sort: $sort, page: $page, limit: $limit)';
}


}

/// @nodoc
abstract mixin class $SearchFiltersCopyWith<$Res>  {
  factory $SearchFiltersCopyWith(SearchFilters value, $Res Function(SearchFilters) _then) = _$SearchFiltersCopyWithImpl;
@useResult
$Res call({
 String? city, String? district, String? category, double? priceMin, double? priceMax, double? areaMin, double? areaMax, List<String> amenities, String? sort, int page, int limit
});




}
/// @nodoc
class _$SearchFiltersCopyWithImpl<$Res>
    implements $SearchFiltersCopyWith<$Res> {
  _$SearchFiltersCopyWithImpl(this._self, this._then);

  final SearchFilters _self;
  final $Res Function(SearchFilters) _then;

/// Create a copy of SearchFilters
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? city = freezed,Object? district = freezed,Object? category = freezed,Object? priceMin = freezed,Object? priceMax = freezed,Object? areaMin = freezed,Object? areaMax = freezed,Object? amenities = null,Object? sort = freezed,Object? page = null,Object? limit = null,}) {
  return _then(_self.copyWith(
city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,priceMin: freezed == priceMin ? _self.priceMin : priceMin // ignore: cast_nullable_to_non_nullable
as double?,priceMax: freezed == priceMax ? _self.priceMax : priceMax // ignore: cast_nullable_to_non_nullable
as double?,areaMin: freezed == areaMin ? _self.areaMin : areaMin // ignore: cast_nullable_to_non_nullable
as double?,areaMax: freezed == areaMax ? _self.areaMax : areaMax // ignore: cast_nullable_to_non_nullable
as double?,amenities: null == amenities ? _self.amenities : amenities // ignore: cast_nullable_to_non_nullable
as List<String>,sort: freezed == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as String?,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchFilters].
extension SearchFiltersPatterns on SearchFilters {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchFilters value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchFilters() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchFilters value)  $default,){
final _that = this;
switch (_that) {
case _SearchFilters():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchFilters value)?  $default,){
final _that = this;
switch (_that) {
case _SearchFilters() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? city,  String? district,  String? category,  double? priceMin,  double? priceMax,  double? areaMin,  double? areaMax,  List<String> amenities,  String? sort,  int page,  int limit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchFilters() when $default != null:
return $default(_that.city,_that.district,_that.category,_that.priceMin,_that.priceMax,_that.areaMin,_that.areaMax,_that.amenities,_that.sort,_that.page,_that.limit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? city,  String? district,  String? category,  double? priceMin,  double? priceMax,  double? areaMin,  double? areaMax,  List<String> amenities,  String? sort,  int page,  int limit)  $default,) {final _that = this;
switch (_that) {
case _SearchFilters():
return $default(_that.city,_that.district,_that.category,_that.priceMin,_that.priceMax,_that.areaMin,_that.areaMax,_that.amenities,_that.sort,_that.page,_that.limit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? city,  String? district,  String? category,  double? priceMin,  double? priceMax,  double? areaMin,  double? areaMax,  List<String> amenities,  String? sort,  int page,  int limit)?  $default,) {final _that = this;
switch (_that) {
case _SearchFilters() when $default != null:
return $default(_that.city,_that.district,_that.category,_that.priceMin,_that.priceMax,_that.areaMin,_that.areaMax,_that.amenities,_that.sort,_that.page,_that.limit);case _:
  return null;

}
}

}

/// @nodoc


class _SearchFilters implements SearchFilters {
  const _SearchFilters({this.city, this.district, this.category, this.priceMin, this.priceMax, this.areaMin, this.areaMax, final  List<String> amenities = const <String>[], this.sort, this.page = 1, this.limit = 10}): _amenities = amenities;
  

@override final  String? city;
@override final  String? district;
@override final  String? category;
@override final  double? priceMin;
@override final  double? priceMax;
@override final  double? areaMin;
@override final  double? areaMax;
 final  List<String> _amenities;
@override@JsonKey() List<String> get amenities {
  if (_amenities is EqualUnmodifiableListView) return _amenities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_amenities);
}

@override final  String? sort;
@override@JsonKey() final  int page;
@override@JsonKey() final  int limit;

/// Create a copy of SearchFilters
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchFiltersCopyWith<_SearchFilters> get copyWith => __$SearchFiltersCopyWithImpl<_SearchFilters>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchFilters&&(identical(other.city, city) || other.city == city)&&(identical(other.district, district) || other.district == district)&&(identical(other.category, category) || other.category == category)&&(identical(other.priceMin, priceMin) || other.priceMin == priceMin)&&(identical(other.priceMax, priceMax) || other.priceMax == priceMax)&&(identical(other.areaMin, areaMin) || other.areaMin == areaMin)&&(identical(other.areaMax, areaMax) || other.areaMax == areaMax)&&const DeepCollectionEquality().equals(other._amenities, _amenities)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit));
}


@override
int get hashCode => Object.hash(runtimeType,city,district,category,priceMin,priceMax,areaMin,areaMax,const DeepCollectionEquality().hash(_amenities),sort,page,limit);

@override
String toString() {
  return 'SearchFilters(city: $city, district: $district, category: $category, priceMin: $priceMin, priceMax: $priceMax, areaMin: $areaMin, areaMax: $areaMax, amenities: $amenities, sort: $sort, page: $page, limit: $limit)';
}


}

/// @nodoc
abstract mixin class _$SearchFiltersCopyWith<$Res> implements $SearchFiltersCopyWith<$Res> {
  factory _$SearchFiltersCopyWith(_SearchFilters value, $Res Function(_SearchFilters) _then) = __$SearchFiltersCopyWithImpl;
@override @useResult
$Res call({
 String? city, String? district, String? category, double? priceMin, double? priceMax, double? areaMin, double? areaMax, List<String> amenities, String? sort, int page, int limit
});




}
/// @nodoc
class __$SearchFiltersCopyWithImpl<$Res>
    implements _$SearchFiltersCopyWith<$Res> {
  __$SearchFiltersCopyWithImpl(this._self, this._then);

  final _SearchFilters _self;
  final $Res Function(_SearchFilters) _then;

/// Create a copy of SearchFilters
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? city = freezed,Object? district = freezed,Object? category = freezed,Object? priceMin = freezed,Object? priceMax = freezed,Object? areaMin = freezed,Object? areaMax = freezed,Object? amenities = null,Object? sort = freezed,Object? page = null,Object? limit = null,}) {
  return _then(_SearchFilters(
city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,priceMin: freezed == priceMin ? _self.priceMin : priceMin // ignore: cast_nullable_to_non_nullable
as double?,priceMax: freezed == priceMax ? _self.priceMax : priceMax // ignore: cast_nullable_to_non_nullable
as double?,areaMin: freezed == areaMin ? _self.areaMin : areaMin // ignore: cast_nullable_to_non_nullable
as double?,areaMax: freezed == areaMax ? _self.areaMax : areaMax // ignore: cast_nullable_to_non_nullable
as double?,amenities: null == amenities ? _self._amenities : amenities // ignore: cast_nullable_to_non_nullable
as List<String>,sort: freezed == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as String?,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
