// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'listing_meta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ListingMeta {

 List<String> get categories; List<String> get amenities; List<String> get statuses;
/// Create a copy of ListingMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListingMetaCopyWith<ListingMeta> get copyWith => _$ListingMetaCopyWithImpl<ListingMeta>(this as ListingMeta, _$identity);

  /// Serializes this ListingMeta to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListingMeta&&const DeepCollectionEquality().equals(other.categories, categories)&&const DeepCollectionEquality().equals(other.amenities, amenities)&&const DeepCollectionEquality().equals(other.statuses, statuses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(categories),const DeepCollectionEquality().hash(amenities),const DeepCollectionEquality().hash(statuses));

@override
String toString() {
  return 'ListingMeta(categories: $categories, amenities: $amenities, statuses: $statuses)';
}


}

/// @nodoc
abstract mixin class $ListingMetaCopyWith<$Res>  {
  factory $ListingMetaCopyWith(ListingMeta value, $Res Function(ListingMeta) _then) = _$ListingMetaCopyWithImpl;
@useResult
$Res call({
 List<String> categories, List<String> amenities, List<String> statuses
});




}
/// @nodoc
class _$ListingMetaCopyWithImpl<$Res>
    implements $ListingMetaCopyWith<$Res> {
  _$ListingMetaCopyWithImpl(this._self, this._then);

  final ListingMeta _self;
  final $Res Function(ListingMeta) _then;

/// Create a copy of ListingMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categories = null,Object? amenities = null,Object? statuses = null,}) {
  return _then(_self.copyWith(
categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,amenities: null == amenities ? _self.amenities : amenities // ignore: cast_nullable_to_non_nullable
as List<String>,statuses: null == statuses ? _self.statuses : statuses // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ListingMeta].
extension ListingMetaPatterns on ListingMeta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListingMeta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListingMeta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListingMeta value)  $default,){
final _that = this;
switch (_that) {
case _ListingMeta():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListingMeta value)?  $default,){
final _that = this;
switch (_that) {
case _ListingMeta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> categories,  List<String> amenities,  List<String> statuses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListingMeta() when $default != null:
return $default(_that.categories,_that.amenities,_that.statuses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> categories,  List<String> amenities,  List<String> statuses)  $default,) {final _that = this;
switch (_that) {
case _ListingMeta():
return $default(_that.categories,_that.amenities,_that.statuses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> categories,  List<String> amenities,  List<String> statuses)?  $default,) {final _that = this;
switch (_that) {
case _ListingMeta() when $default != null:
return $default(_that.categories,_that.amenities,_that.statuses);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ListingMeta implements ListingMeta {
  const _ListingMeta({required final  List<String> categories, required final  List<String> amenities, required final  List<String> statuses}): _categories = categories,_amenities = amenities,_statuses = statuses;
  factory _ListingMeta.fromJson(Map<String, dynamic> json) => _$ListingMetaFromJson(json);

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

 final  List<String> _statuses;
@override List<String> get statuses {
  if (_statuses is EqualUnmodifiableListView) return _statuses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_statuses);
}


/// Create a copy of ListingMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListingMetaCopyWith<_ListingMeta> get copyWith => __$ListingMetaCopyWithImpl<_ListingMeta>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListingMetaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListingMeta&&const DeepCollectionEquality().equals(other._categories, _categories)&&const DeepCollectionEquality().equals(other._amenities, _amenities)&&const DeepCollectionEquality().equals(other._statuses, _statuses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_amenities),const DeepCollectionEquality().hash(_statuses));

@override
String toString() {
  return 'ListingMeta(categories: $categories, amenities: $amenities, statuses: $statuses)';
}


}

/// @nodoc
abstract mixin class _$ListingMetaCopyWith<$Res> implements $ListingMetaCopyWith<$Res> {
  factory _$ListingMetaCopyWith(_ListingMeta value, $Res Function(_ListingMeta) _then) = __$ListingMetaCopyWithImpl;
@override @useResult
$Res call({
 List<String> categories, List<String> amenities, List<String> statuses
});




}
/// @nodoc
class __$ListingMetaCopyWithImpl<$Res>
    implements _$ListingMetaCopyWith<$Res> {
  __$ListingMetaCopyWithImpl(this._self, this._then);

  final _ListingMeta _self;
  final $Res Function(_ListingMeta) _then;

/// Create a copy of ListingMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categories = null,Object? amenities = null,Object? statuses = null,}) {
  return _then(_ListingMeta(
categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,amenities: null == amenities ? _self._amenities : amenities // ignore: cast_nullable_to_non_nullable
as List<String>,statuses: null == statuses ? _self._statuses : statuses // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
