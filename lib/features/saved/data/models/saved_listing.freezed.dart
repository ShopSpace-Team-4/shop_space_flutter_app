// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_listing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SavedListing {

 String get id; String get title; String get location; double get annualRent; double get annualRentWithVat; String get currency; double get areaSqm; String? get thumbnailUrl; bool? get isSaved;
/// Create a copy of SavedListing
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedListingCopyWith<SavedListing> get copyWith => _$SavedListingCopyWithImpl<SavedListing>(this as SavedListing, _$identity);

  /// Serializes this SavedListing to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedListing&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.location, location) || other.location == location)&&(identical(other.annualRent, annualRent) || other.annualRent == annualRent)&&(identical(other.annualRentWithVat, annualRentWithVat) || other.annualRentWithVat == annualRentWithVat)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.areaSqm, areaSqm) || other.areaSqm == areaSqm)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.isSaved, isSaved) || other.isSaved == isSaved));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,location,annualRent,annualRentWithVat,currency,areaSqm,thumbnailUrl,isSaved);

@override
String toString() {
  return 'SavedListing(id: $id, title: $title, location: $location, annualRent: $annualRent, annualRentWithVat: $annualRentWithVat, currency: $currency, areaSqm: $areaSqm, thumbnailUrl: $thumbnailUrl, isSaved: $isSaved)';
}


}

/// @nodoc
abstract mixin class $SavedListingCopyWith<$Res>  {
  factory $SavedListingCopyWith(SavedListing value, $Res Function(SavedListing) _then) = _$SavedListingCopyWithImpl;
@useResult
$Res call({
 String id, String title, String location, double annualRent, double annualRentWithVat, String currency, double areaSqm, String? thumbnailUrl, bool? isSaved
});




}
/// @nodoc
class _$SavedListingCopyWithImpl<$Res>
    implements $SavedListingCopyWith<$Res> {
  _$SavedListingCopyWithImpl(this._self, this._then);

  final SavedListing _self;
  final $Res Function(SavedListing) _then;

/// Create a copy of SavedListing
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? location = null,Object? annualRent = null,Object? annualRentWithVat = null,Object? currency = null,Object? areaSqm = null,Object? thumbnailUrl = freezed,Object? isSaved = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,annualRent: null == annualRent ? _self.annualRent : annualRent // ignore: cast_nullable_to_non_nullable
as double,annualRentWithVat: null == annualRentWithVat ? _self.annualRentWithVat : annualRentWithVat // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,areaSqm: null == areaSqm ? _self.areaSqm : areaSqm // ignore: cast_nullable_to_non_nullable
as double,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,isSaved: freezed == isSaved ? _self.isSaved : isSaved // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [SavedListing].
extension SavedListingPatterns on SavedListing {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavedListing value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavedListing() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavedListing value)  $default,){
final _that = this;
switch (_that) {
case _SavedListing():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavedListing value)?  $default,){
final _that = this;
switch (_that) {
case _SavedListing() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String location,  double annualRent,  double annualRentWithVat,  String currency,  double areaSqm,  String? thumbnailUrl,  bool? isSaved)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavedListing() when $default != null:
return $default(_that.id,_that.title,_that.location,_that.annualRent,_that.annualRentWithVat,_that.currency,_that.areaSqm,_that.thumbnailUrl,_that.isSaved);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String location,  double annualRent,  double annualRentWithVat,  String currency,  double areaSqm,  String? thumbnailUrl,  bool? isSaved)  $default,) {final _that = this;
switch (_that) {
case _SavedListing():
return $default(_that.id,_that.title,_that.location,_that.annualRent,_that.annualRentWithVat,_that.currency,_that.areaSqm,_that.thumbnailUrl,_that.isSaved);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String location,  double annualRent,  double annualRentWithVat,  String currency,  double areaSqm,  String? thumbnailUrl,  bool? isSaved)?  $default,) {final _that = this;
switch (_that) {
case _SavedListing() when $default != null:
return $default(_that.id,_that.title,_that.location,_that.annualRent,_that.annualRentWithVat,_that.currency,_that.areaSqm,_that.thumbnailUrl,_that.isSaved);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SavedListing implements SavedListing {
  const _SavedListing({required this.id, required this.title, required this.location, required this.annualRent, required this.annualRentWithVat, required this.currency, required this.areaSqm, this.thumbnailUrl, this.isSaved});
  factory _SavedListing.fromJson(Map<String, dynamic> json) => _$SavedListingFromJson(json);

@override final  String id;
@override final  String title;
@override final  String location;
@override final  double annualRent;
@override final  double annualRentWithVat;
@override final  String currency;
@override final  double areaSqm;
@override final  String? thumbnailUrl;
@override final  bool? isSaved;

/// Create a copy of SavedListing
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavedListingCopyWith<_SavedListing> get copyWith => __$SavedListingCopyWithImpl<_SavedListing>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SavedListingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavedListing&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.location, location) || other.location == location)&&(identical(other.annualRent, annualRent) || other.annualRent == annualRent)&&(identical(other.annualRentWithVat, annualRentWithVat) || other.annualRentWithVat == annualRentWithVat)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.areaSqm, areaSqm) || other.areaSqm == areaSqm)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.isSaved, isSaved) || other.isSaved == isSaved));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,location,annualRent,annualRentWithVat,currency,areaSqm,thumbnailUrl,isSaved);

@override
String toString() {
  return 'SavedListing(id: $id, title: $title, location: $location, annualRent: $annualRent, annualRentWithVat: $annualRentWithVat, currency: $currency, areaSqm: $areaSqm, thumbnailUrl: $thumbnailUrl, isSaved: $isSaved)';
}


}

/// @nodoc
abstract mixin class _$SavedListingCopyWith<$Res> implements $SavedListingCopyWith<$Res> {
  factory _$SavedListingCopyWith(_SavedListing value, $Res Function(_SavedListing) _then) = __$SavedListingCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String location, double annualRent, double annualRentWithVat, String currency, double areaSqm, String? thumbnailUrl, bool? isSaved
});




}
/// @nodoc
class __$SavedListingCopyWithImpl<$Res>
    implements _$SavedListingCopyWith<$Res> {
  __$SavedListingCopyWithImpl(this._self, this._then);

  final _SavedListing _self;
  final $Res Function(_SavedListing) _then;

/// Create a copy of SavedListing
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? location = null,Object? annualRent = null,Object? annualRentWithVat = null,Object? currency = null,Object? areaSqm = null,Object? thumbnailUrl = freezed,Object? isSaved = freezed,}) {
  return _then(_SavedListing(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,annualRent: null == annualRent ? _self.annualRent : annualRent // ignore: cast_nullable_to_non_nullable
as double,annualRentWithVat: null == annualRentWithVat ? _self.annualRentWithVat : annualRentWithVat // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,areaSqm: null == areaSqm ? _self.areaSqm : areaSqm // ignore: cast_nullable_to_non_nullable
as double,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,isSaved: freezed == isSaved ? _self.isSaved : isSaved // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
