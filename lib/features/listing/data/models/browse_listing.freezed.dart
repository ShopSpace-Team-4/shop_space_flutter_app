// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'browse_listing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BrowseListing {

 String get id; String get title; String get category; double get areaSqm; String get city; String get district; double get annualRent; double get annualRentWithVat; String get currency; String? get thumbnailUrl; bool? get isSaved;
/// Create a copy of BrowseListing
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrowseListingCopyWith<BrowseListing> get copyWith => _$BrowseListingCopyWithImpl<BrowseListing>(this as BrowseListing, _$identity);

  /// Serializes this BrowseListing to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrowseListing&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.areaSqm, areaSqm) || other.areaSqm == areaSqm)&&(identical(other.city, city) || other.city == city)&&(identical(other.district, district) || other.district == district)&&(identical(other.annualRent, annualRent) || other.annualRent == annualRent)&&(identical(other.annualRentWithVat, annualRentWithVat) || other.annualRentWithVat == annualRentWithVat)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.isSaved, isSaved) || other.isSaved == isSaved));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,category,areaSqm,city,district,annualRent,annualRentWithVat,currency,thumbnailUrl,isSaved);

@override
String toString() {
  return 'BrowseListing(id: $id, title: $title, category: $category, areaSqm: $areaSqm, city: $city, district: $district, annualRent: $annualRent, annualRentWithVat: $annualRentWithVat, currency: $currency, thumbnailUrl: $thumbnailUrl, isSaved: $isSaved)';
}


}

/// @nodoc
abstract mixin class $BrowseListingCopyWith<$Res>  {
  factory $BrowseListingCopyWith(BrowseListing value, $Res Function(BrowseListing) _then) = _$BrowseListingCopyWithImpl;
@useResult
$Res call({
 String id, String title, String category, double areaSqm, String city, String district, double annualRent, double annualRentWithVat, String currency, String? thumbnailUrl, bool? isSaved
});




}
/// @nodoc
class _$BrowseListingCopyWithImpl<$Res>
    implements $BrowseListingCopyWith<$Res> {
  _$BrowseListingCopyWithImpl(this._self, this._then);

  final BrowseListing _self;
  final $Res Function(BrowseListing) _then;

/// Create a copy of BrowseListing
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? category = null,Object? areaSqm = null,Object? city = null,Object? district = null,Object? annualRent = null,Object? annualRentWithVat = null,Object? currency = null,Object? thumbnailUrl = freezed,Object? isSaved = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,areaSqm: null == areaSqm ? _self.areaSqm : areaSqm // ignore: cast_nullable_to_non_nullable
as double,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,annualRent: null == annualRent ? _self.annualRent : annualRent // ignore: cast_nullable_to_non_nullable
as double,annualRentWithVat: null == annualRentWithVat ? _self.annualRentWithVat : annualRentWithVat // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,isSaved: freezed == isSaved ? _self.isSaved : isSaved // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [BrowseListing].
extension BrowseListingPatterns on BrowseListing {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BrowseListing value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BrowseListing() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BrowseListing value)  $default,){
final _that = this;
switch (_that) {
case _BrowseListing():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BrowseListing value)?  $default,){
final _that = this;
switch (_that) {
case _BrowseListing() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String category,  double areaSqm,  String city,  String district,  double annualRent,  double annualRentWithVat,  String currency,  String? thumbnailUrl,  bool? isSaved)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BrowseListing() when $default != null:
return $default(_that.id,_that.title,_that.category,_that.areaSqm,_that.city,_that.district,_that.annualRent,_that.annualRentWithVat,_that.currency,_that.thumbnailUrl,_that.isSaved);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String category,  double areaSqm,  String city,  String district,  double annualRent,  double annualRentWithVat,  String currency,  String? thumbnailUrl,  bool? isSaved)  $default,) {final _that = this;
switch (_that) {
case _BrowseListing():
return $default(_that.id,_that.title,_that.category,_that.areaSqm,_that.city,_that.district,_that.annualRent,_that.annualRentWithVat,_that.currency,_that.thumbnailUrl,_that.isSaved);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String category,  double areaSqm,  String city,  String district,  double annualRent,  double annualRentWithVat,  String currency,  String? thumbnailUrl,  bool? isSaved)?  $default,) {final _that = this;
switch (_that) {
case _BrowseListing() when $default != null:
return $default(_that.id,_that.title,_that.category,_that.areaSqm,_that.city,_that.district,_that.annualRent,_that.annualRentWithVat,_that.currency,_that.thumbnailUrl,_that.isSaved);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BrowseListing implements BrowseListing {
  const _BrowseListing({required this.id, required this.title, required this.category, required this.areaSqm, required this.city, required this.district, required this.annualRent, required this.annualRentWithVat, required this.currency, this.thumbnailUrl, this.isSaved});
  factory _BrowseListing.fromJson(Map<String, dynamic> json) => _$BrowseListingFromJson(json);

@override final  String id;
@override final  String title;
@override final  String category;
@override final  double areaSqm;
@override final  String city;
@override final  String district;
@override final  double annualRent;
@override final  double annualRentWithVat;
@override final  String currency;
@override final  String? thumbnailUrl;
@override final  bool? isSaved;

/// Create a copy of BrowseListing
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrowseListingCopyWith<_BrowseListing> get copyWith => __$BrowseListingCopyWithImpl<_BrowseListing>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BrowseListingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BrowseListing&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.areaSqm, areaSqm) || other.areaSqm == areaSqm)&&(identical(other.city, city) || other.city == city)&&(identical(other.district, district) || other.district == district)&&(identical(other.annualRent, annualRent) || other.annualRent == annualRent)&&(identical(other.annualRentWithVat, annualRentWithVat) || other.annualRentWithVat == annualRentWithVat)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.isSaved, isSaved) || other.isSaved == isSaved));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,category,areaSqm,city,district,annualRent,annualRentWithVat,currency,thumbnailUrl,isSaved);

@override
String toString() {
  return 'BrowseListing(id: $id, title: $title, category: $category, areaSqm: $areaSqm, city: $city, district: $district, annualRent: $annualRent, annualRentWithVat: $annualRentWithVat, currency: $currency, thumbnailUrl: $thumbnailUrl, isSaved: $isSaved)';
}


}

/// @nodoc
abstract mixin class _$BrowseListingCopyWith<$Res> implements $BrowseListingCopyWith<$Res> {
  factory _$BrowseListingCopyWith(_BrowseListing value, $Res Function(_BrowseListing) _then) = __$BrowseListingCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String category, double areaSqm, String city, String district, double annualRent, double annualRentWithVat, String currency, String? thumbnailUrl, bool? isSaved
});




}
/// @nodoc
class __$BrowseListingCopyWithImpl<$Res>
    implements _$BrowseListingCopyWith<$Res> {
  __$BrowseListingCopyWithImpl(this._self, this._then);

  final _BrowseListing _self;
  final $Res Function(_BrowseListing) _then;

/// Create a copy of BrowseListing
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? category = null,Object? areaSqm = null,Object? city = null,Object? district = null,Object? annualRent = null,Object? annualRentWithVat = null,Object? currency = null,Object? thumbnailUrl = freezed,Object? isSaved = freezed,}) {
  return _then(_BrowseListing(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,areaSqm: null == areaSqm ? _self.areaSqm : areaSqm // ignore: cast_nullable_to_non_nullable
as double,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,annualRent: null == annualRent ? _self.annualRent : annualRent // ignore: cast_nullable_to_non_nullable
as double,annualRentWithVat: null == annualRentWithVat ? _self.annualRentWithVat : annualRentWithVat // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,isSaved: freezed == isSaved ? _self.isSaved : isSaved // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
