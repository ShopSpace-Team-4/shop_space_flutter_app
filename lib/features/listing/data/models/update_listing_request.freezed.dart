// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_listing_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateListingRequest {

 String get title; String get category; double get areaSqm; String get city; String get district; String get address; String get description; List<String> get amenities; int get numberOfFloors; int get floorNumber; String get availableFrom; String get minimumLeaseTerm; double get annualRent;@JsonKey(includeIfNull: false) String? get currency; int get securityDepositMonths;
/// Create a copy of UpdateListingRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateListingRequestCopyWith<UpdateListingRequest> get copyWith => _$UpdateListingRequestCopyWithImpl<UpdateListingRequest>(this as UpdateListingRequest, _$identity);

  /// Serializes this UpdateListingRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateListingRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.areaSqm, areaSqm) || other.areaSqm == areaSqm)&&(identical(other.city, city) || other.city == city)&&(identical(other.district, district) || other.district == district)&&(identical(other.address, address) || other.address == address)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.amenities, amenities)&&(identical(other.numberOfFloors, numberOfFloors) || other.numberOfFloors == numberOfFloors)&&(identical(other.floorNumber, floorNumber) || other.floorNumber == floorNumber)&&(identical(other.availableFrom, availableFrom) || other.availableFrom == availableFrom)&&(identical(other.minimumLeaseTerm, minimumLeaseTerm) || other.minimumLeaseTerm == minimumLeaseTerm)&&(identical(other.annualRent, annualRent) || other.annualRent == annualRent)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.securityDepositMonths, securityDepositMonths) || other.securityDepositMonths == securityDepositMonths));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,category,areaSqm,city,district,address,description,const DeepCollectionEquality().hash(amenities),numberOfFloors,floorNumber,availableFrom,minimumLeaseTerm,annualRent,currency,securityDepositMonths);

@override
String toString() {
  return 'UpdateListingRequest(title: $title, category: $category, areaSqm: $areaSqm, city: $city, district: $district, address: $address, description: $description, amenities: $amenities, numberOfFloors: $numberOfFloors, floorNumber: $floorNumber, availableFrom: $availableFrom, minimumLeaseTerm: $minimumLeaseTerm, annualRent: $annualRent, currency: $currency, securityDepositMonths: $securityDepositMonths)';
}


}

/// @nodoc
abstract mixin class $UpdateListingRequestCopyWith<$Res>  {
  factory $UpdateListingRequestCopyWith(UpdateListingRequest value, $Res Function(UpdateListingRequest) _then) = _$UpdateListingRequestCopyWithImpl;
@useResult
$Res call({
 String title, String category, double areaSqm, String city, String district, String address, String description, List<String> amenities, int numberOfFloors, int floorNumber, String availableFrom, String minimumLeaseTerm, double annualRent,@JsonKey(includeIfNull: false) String? currency, int securityDepositMonths
});




}
/// @nodoc
class _$UpdateListingRequestCopyWithImpl<$Res>
    implements $UpdateListingRequestCopyWith<$Res> {
  _$UpdateListingRequestCopyWithImpl(this._self, this._then);

  final UpdateListingRequest _self;
  final $Res Function(UpdateListingRequest) _then;

/// Create a copy of UpdateListingRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? category = null,Object? areaSqm = null,Object? city = null,Object? district = null,Object? address = null,Object? description = null,Object? amenities = null,Object? numberOfFloors = null,Object? floorNumber = null,Object? availableFrom = null,Object? minimumLeaseTerm = null,Object? annualRent = null,Object? currency = freezed,Object? securityDepositMonths = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,areaSqm: null == areaSqm ? _self.areaSqm : areaSqm // ignore: cast_nullable_to_non_nullable
as double,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amenities: null == amenities ? _self.amenities : amenities // ignore: cast_nullable_to_non_nullable
as List<String>,numberOfFloors: null == numberOfFloors ? _self.numberOfFloors : numberOfFloors // ignore: cast_nullable_to_non_nullable
as int,floorNumber: null == floorNumber ? _self.floorNumber : floorNumber // ignore: cast_nullable_to_non_nullable
as int,availableFrom: null == availableFrom ? _self.availableFrom : availableFrom // ignore: cast_nullable_to_non_nullable
as String,minimumLeaseTerm: null == minimumLeaseTerm ? _self.minimumLeaseTerm : minimumLeaseTerm // ignore: cast_nullable_to_non_nullable
as String,annualRent: null == annualRent ? _self.annualRent : annualRent // ignore: cast_nullable_to_non_nullable
as double,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,securityDepositMonths: null == securityDepositMonths ? _self.securityDepositMonths : securityDepositMonths // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateListingRequest].
extension UpdateListingRequestPatterns on UpdateListingRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateListingRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateListingRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateListingRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateListingRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateListingRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateListingRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String category,  double areaSqm,  String city,  String district,  String address,  String description,  List<String> amenities,  int numberOfFloors,  int floorNumber,  String availableFrom,  String minimumLeaseTerm,  double annualRent, @JsonKey(includeIfNull: false)  String? currency,  int securityDepositMonths)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateListingRequest() when $default != null:
return $default(_that.title,_that.category,_that.areaSqm,_that.city,_that.district,_that.address,_that.description,_that.amenities,_that.numberOfFloors,_that.floorNumber,_that.availableFrom,_that.minimumLeaseTerm,_that.annualRent,_that.currency,_that.securityDepositMonths);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String category,  double areaSqm,  String city,  String district,  String address,  String description,  List<String> amenities,  int numberOfFloors,  int floorNumber,  String availableFrom,  String minimumLeaseTerm,  double annualRent, @JsonKey(includeIfNull: false)  String? currency,  int securityDepositMonths)  $default,) {final _that = this;
switch (_that) {
case _UpdateListingRequest():
return $default(_that.title,_that.category,_that.areaSqm,_that.city,_that.district,_that.address,_that.description,_that.amenities,_that.numberOfFloors,_that.floorNumber,_that.availableFrom,_that.minimumLeaseTerm,_that.annualRent,_that.currency,_that.securityDepositMonths);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String category,  double areaSqm,  String city,  String district,  String address,  String description,  List<String> amenities,  int numberOfFloors,  int floorNumber,  String availableFrom,  String minimumLeaseTerm,  double annualRent, @JsonKey(includeIfNull: false)  String? currency,  int securityDepositMonths)?  $default,) {final _that = this;
switch (_that) {
case _UpdateListingRequest() when $default != null:
return $default(_that.title,_that.category,_that.areaSqm,_that.city,_that.district,_that.address,_that.description,_that.amenities,_that.numberOfFloors,_that.floorNumber,_that.availableFrom,_that.minimumLeaseTerm,_that.annualRent,_that.currency,_that.securityDepositMonths);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateListingRequest implements UpdateListingRequest {
  const _UpdateListingRequest({required this.title, required this.category, required this.areaSqm, required this.city, required this.district, required this.address, required this.description, required final  List<String> amenities, required this.numberOfFloors, required this.floorNumber, required this.availableFrom, required this.minimumLeaseTerm, required this.annualRent, @JsonKey(includeIfNull: false) this.currency, required this.securityDepositMonths}): _amenities = amenities;
  factory _UpdateListingRequest.fromJson(Map<String, dynamic> json) => _$UpdateListingRequestFromJson(json);

@override final  String title;
@override final  String category;
@override final  double areaSqm;
@override final  String city;
@override final  String district;
@override final  String address;
@override final  String description;
 final  List<String> _amenities;
@override List<String> get amenities {
  if (_amenities is EqualUnmodifiableListView) return _amenities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_amenities);
}

@override final  int numberOfFloors;
@override final  int floorNumber;
@override final  String availableFrom;
@override final  String minimumLeaseTerm;
@override final  double annualRent;
@override@JsonKey(includeIfNull: false) final  String? currency;
@override final  int securityDepositMonths;

/// Create a copy of UpdateListingRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateListingRequestCopyWith<_UpdateListingRequest> get copyWith => __$UpdateListingRequestCopyWithImpl<_UpdateListingRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateListingRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateListingRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.areaSqm, areaSqm) || other.areaSqm == areaSqm)&&(identical(other.city, city) || other.city == city)&&(identical(other.district, district) || other.district == district)&&(identical(other.address, address) || other.address == address)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._amenities, _amenities)&&(identical(other.numberOfFloors, numberOfFloors) || other.numberOfFloors == numberOfFloors)&&(identical(other.floorNumber, floorNumber) || other.floorNumber == floorNumber)&&(identical(other.availableFrom, availableFrom) || other.availableFrom == availableFrom)&&(identical(other.minimumLeaseTerm, minimumLeaseTerm) || other.minimumLeaseTerm == minimumLeaseTerm)&&(identical(other.annualRent, annualRent) || other.annualRent == annualRent)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.securityDepositMonths, securityDepositMonths) || other.securityDepositMonths == securityDepositMonths));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,category,areaSqm,city,district,address,description,const DeepCollectionEquality().hash(_amenities),numberOfFloors,floorNumber,availableFrom,minimumLeaseTerm,annualRent,currency,securityDepositMonths);

@override
String toString() {
  return 'UpdateListingRequest(title: $title, category: $category, areaSqm: $areaSqm, city: $city, district: $district, address: $address, description: $description, amenities: $amenities, numberOfFloors: $numberOfFloors, floorNumber: $floorNumber, availableFrom: $availableFrom, minimumLeaseTerm: $minimumLeaseTerm, annualRent: $annualRent, currency: $currency, securityDepositMonths: $securityDepositMonths)';
}


}

/// @nodoc
abstract mixin class _$UpdateListingRequestCopyWith<$Res> implements $UpdateListingRequestCopyWith<$Res> {
  factory _$UpdateListingRequestCopyWith(_UpdateListingRequest value, $Res Function(_UpdateListingRequest) _then) = __$UpdateListingRequestCopyWithImpl;
@override @useResult
$Res call({
 String title, String category, double areaSqm, String city, String district, String address, String description, List<String> amenities, int numberOfFloors, int floorNumber, String availableFrom, String minimumLeaseTerm, double annualRent,@JsonKey(includeIfNull: false) String? currency, int securityDepositMonths
});




}
/// @nodoc
class __$UpdateListingRequestCopyWithImpl<$Res>
    implements _$UpdateListingRequestCopyWith<$Res> {
  __$UpdateListingRequestCopyWithImpl(this._self, this._then);

  final _UpdateListingRequest _self;
  final $Res Function(_UpdateListingRequest) _then;

/// Create a copy of UpdateListingRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? category = null,Object? areaSqm = null,Object? city = null,Object? district = null,Object? address = null,Object? description = null,Object? amenities = null,Object? numberOfFloors = null,Object? floorNumber = null,Object? availableFrom = null,Object? minimumLeaseTerm = null,Object? annualRent = null,Object? currency = freezed,Object? securityDepositMonths = null,}) {
  return _then(_UpdateListingRequest(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,areaSqm: null == areaSqm ? _self.areaSqm : areaSqm // ignore: cast_nullable_to_non_nullable
as double,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amenities: null == amenities ? _self._amenities : amenities // ignore: cast_nullable_to_non_nullable
as List<String>,numberOfFloors: null == numberOfFloors ? _self.numberOfFloors : numberOfFloors // ignore: cast_nullable_to_non_nullable
as int,floorNumber: null == floorNumber ? _self.floorNumber : floorNumber // ignore: cast_nullable_to_non_nullable
as int,availableFrom: null == availableFrom ? _self.availableFrom : availableFrom // ignore: cast_nullable_to_non_nullable
as String,minimumLeaseTerm: null == minimumLeaseTerm ? _self.minimumLeaseTerm : minimumLeaseTerm // ignore: cast_nullable_to_non_nullable
as String,annualRent: null == annualRent ? _self.annualRent : annualRent // ignore: cast_nullable_to_non_nullable
as double,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,securityDepositMonths: null == securityDepositMonths ? _self.securityDepositMonths : securityDepositMonths // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
