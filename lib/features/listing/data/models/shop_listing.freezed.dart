// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shop_listing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShopListing {

 String get id; String? get landlordId; String get title; String get category; double get areaSqm; String get city; String get district; String? get address; String? get description; List<String> get amenities; int? get numberOfFloors; int get floorNumber; DateTime? get availableFrom; String? get minimumLeaseTerm; double get annualRent; double get annualRentWithVat; String get currency; int? get securityDepositMonths;@ListingStatusConverter() ListingStatus get status; List<ListingMedia> get media; String? get thumbnailUrl; bool? get isSaved; String? get whatsappLink; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of ShopListing
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShopListingCopyWith<ShopListing> get copyWith => _$ShopListingCopyWithImpl<ShopListing>(this as ShopListing, _$identity);

  /// Serializes this ShopListing to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShopListing&&(identical(other.id, id) || other.id == id)&&(identical(other.landlordId, landlordId) || other.landlordId == landlordId)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.areaSqm, areaSqm) || other.areaSqm == areaSqm)&&(identical(other.city, city) || other.city == city)&&(identical(other.district, district) || other.district == district)&&(identical(other.address, address) || other.address == address)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.amenities, amenities)&&(identical(other.numberOfFloors, numberOfFloors) || other.numberOfFloors == numberOfFloors)&&(identical(other.floorNumber, floorNumber) || other.floorNumber == floorNumber)&&(identical(other.availableFrom, availableFrom) || other.availableFrom == availableFrom)&&(identical(other.minimumLeaseTerm, minimumLeaseTerm) || other.minimumLeaseTerm == minimumLeaseTerm)&&(identical(other.annualRent, annualRent) || other.annualRent == annualRent)&&(identical(other.annualRentWithVat, annualRentWithVat) || other.annualRentWithVat == annualRentWithVat)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.securityDepositMonths, securityDepositMonths) || other.securityDepositMonths == securityDepositMonths)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.media, media)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.isSaved, isSaved) || other.isSaved == isSaved)&&(identical(other.whatsappLink, whatsappLink) || other.whatsappLink == whatsappLink)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,landlordId,title,category,areaSqm,city,district,address,description,const DeepCollectionEquality().hash(amenities),numberOfFloors,floorNumber,availableFrom,minimumLeaseTerm,annualRent,annualRentWithVat,currency,securityDepositMonths,status,const DeepCollectionEquality().hash(media),thumbnailUrl,isSaved,whatsappLink,createdAt,updatedAt]);

@override
String toString() {
  return 'ShopListing(id: $id, landlordId: $landlordId, title: $title, category: $category, areaSqm: $areaSqm, city: $city, district: $district, address: $address, description: $description, amenities: $amenities, numberOfFloors: $numberOfFloors, floorNumber: $floorNumber, availableFrom: $availableFrom, minimumLeaseTerm: $minimumLeaseTerm, annualRent: $annualRent, annualRentWithVat: $annualRentWithVat, currency: $currency, securityDepositMonths: $securityDepositMonths, status: $status, media: $media, thumbnailUrl: $thumbnailUrl, isSaved: $isSaved, whatsappLink: $whatsappLink, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ShopListingCopyWith<$Res>  {
  factory $ShopListingCopyWith(ShopListing value, $Res Function(ShopListing) _then) = _$ShopListingCopyWithImpl;
@useResult
$Res call({
 String id, String? landlordId, String title, String category, double areaSqm, String city, String district, String? address, String? description, List<String> amenities, int? numberOfFloors, int floorNumber, DateTime? availableFrom, String? minimumLeaseTerm, double annualRent, double annualRentWithVat, String currency, int? securityDepositMonths,@ListingStatusConverter() ListingStatus status, List<ListingMedia> media, String? thumbnailUrl, bool? isSaved, String? whatsappLink, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$ShopListingCopyWithImpl<$Res>
    implements $ShopListingCopyWith<$Res> {
  _$ShopListingCopyWithImpl(this._self, this._then);

  final ShopListing _self;
  final $Res Function(ShopListing) _then;

/// Create a copy of ShopListing
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? landlordId = freezed,Object? title = null,Object? category = null,Object? areaSqm = null,Object? city = null,Object? district = null,Object? address = freezed,Object? description = freezed,Object? amenities = null,Object? numberOfFloors = freezed,Object? floorNumber = null,Object? availableFrom = freezed,Object? minimumLeaseTerm = freezed,Object? annualRent = null,Object? annualRentWithVat = null,Object? currency = null,Object? securityDepositMonths = freezed,Object? status = null,Object? media = null,Object? thumbnailUrl = freezed,Object? isSaved = freezed,Object? whatsappLink = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,landlordId: freezed == landlordId ? _self.landlordId : landlordId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,areaSqm: null == areaSqm ? _self.areaSqm : areaSqm // ignore: cast_nullable_to_non_nullable
as double,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,amenities: null == amenities ? _self.amenities : amenities // ignore: cast_nullable_to_non_nullable
as List<String>,numberOfFloors: freezed == numberOfFloors ? _self.numberOfFloors : numberOfFloors // ignore: cast_nullable_to_non_nullable
as int?,floorNumber: null == floorNumber ? _self.floorNumber : floorNumber // ignore: cast_nullable_to_non_nullable
as int,availableFrom: freezed == availableFrom ? _self.availableFrom : availableFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,minimumLeaseTerm: freezed == minimumLeaseTerm ? _self.minimumLeaseTerm : minimumLeaseTerm // ignore: cast_nullable_to_non_nullable
as String?,annualRent: null == annualRent ? _self.annualRent : annualRent // ignore: cast_nullable_to_non_nullable
as double,annualRentWithVat: null == annualRentWithVat ? _self.annualRentWithVat : annualRentWithVat // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,securityDepositMonths: freezed == securityDepositMonths ? _self.securityDepositMonths : securityDepositMonths // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ListingStatus,media: null == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as List<ListingMedia>,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,isSaved: freezed == isSaved ? _self.isSaved : isSaved // ignore: cast_nullable_to_non_nullable
as bool?,whatsappLink: freezed == whatsappLink ? _self.whatsappLink : whatsappLink // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ShopListing].
extension ShopListingPatterns on ShopListing {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShopListing value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShopListing() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShopListing value)  $default,){
final _that = this;
switch (_that) {
case _ShopListing():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShopListing value)?  $default,){
final _that = this;
switch (_that) {
case _ShopListing() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? landlordId,  String title,  String category,  double areaSqm,  String city,  String district,  String? address,  String? description,  List<String> amenities,  int? numberOfFloors,  int floorNumber,  DateTime? availableFrom,  String? minimumLeaseTerm,  double annualRent,  double annualRentWithVat,  String currency,  int? securityDepositMonths, @ListingStatusConverter()  ListingStatus status,  List<ListingMedia> media,  String? thumbnailUrl,  bool? isSaved,  String? whatsappLink,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShopListing() when $default != null:
return $default(_that.id,_that.landlordId,_that.title,_that.category,_that.areaSqm,_that.city,_that.district,_that.address,_that.description,_that.amenities,_that.numberOfFloors,_that.floorNumber,_that.availableFrom,_that.minimumLeaseTerm,_that.annualRent,_that.annualRentWithVat,_that.currency,_that.securityDepositMonths,_that.status,_that.media,_that.thumbnailUrl,_that.isSaved,_that.whatsappLink,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? landlordId,  String title,  String category,  double areaSqm,  String city,  String district,  String? address,  String? description,  List<String> amenities,  int? numberOfFloors,  int floorNumber,  DateTime? availableFrom,  String? minimumLeaseTerm,  double annualRent,  double annualRentWithVat,  String currency,  int? securityDepositMonths, @ListingStatusConverter()  ListingStatus status,  List<ListingMedia> media,  String? thumbnailUrl,  bool? isSaved,  String? whatsappLink,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ShopListing():
return $default(_that.id,_that.landlordId,_that.title,_that.category,_that.areaSqm,_that.city,_that.district,_that.address,_that.description,_that.amenities,_that.numberOfFloors,_that.floorNumber,_that.availableFrom,_that.minimumLeaseTerm,_that.annualRent,_that.annualRentWithVat,_that.currency,_that.securityDepositMonths,_that.status,_that.media,_that.thumbnailUrl,_that.isSaved,_that.whatsappLink,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? landlordId,  String title,  String category,  double areaSqm,  String city,  String district,  String? address,  String? description,  List<String> amenities,  int? numberOfFloors,  int floorNumber,  DateTime? availableFrom,  String? minimumLeaseTerm,  double annualRent,  double annualRentWithVat,  String currency,  int? securityDepositMonths, @ListingStatusConverter()  ListingStatus status,  List<ListingMedia> media,  String? thumbnailUrl,  bool? isSaved,  String? whatsappLink,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ShopListing() when $default != null:
return $default(_that.id,_that.landlordId,_that.title,_that.category,_that.areaSqm,_that.city,_that.district,_that.address,_that.description,_that.amenities,_that.numberOfFloors,_that.floorNumber,_that.availableFrom,_that.minimumLeaseTerm,_that.annualRent,_that.annualRentWithVat,_that.currency,_that.securityDepositMonths,_that.status,_that.media,_that.thumbnailUrl,_that.isSaved,_that.whatsappLink,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShopListing implements ShopListing {
  const _ShopListing({required this.id, this.landlordId, required this.title, required this.category, required this.areaSqm, required this.city, required this.district, this.address, this.description, required final  List<String> amenities, this.numberOfFloors, required this.floorNumber, this.availableFrom, this.minimumLeaseTerm, required this.annualRent, required this.annualRentWithVat, required this.currency, this.securityDepositMonths, @ListingStatusConverter() required this.status, required final  List<ListingMedia> media, this.thumbnailUrl, this.isSaved, this.whatsappLink, this.createdAt, this.updatedAt}): _amenities = amenities,_media = media;
  factory _ShopListing.fromJson(Map<String, dynamic> json) => _$ShopListingFromJson(json);

@override final  String id;
@override final  String? landlordId;
@override final  String title;
@override final  String category;
@override final  double areaSqm;
@override final  String city;
@override final  String district;
@override final  String? address;
@override final  String? description;
 final  List<String> _amenities;
@override List<String> get amenities {
  if (_amenities is EqualUnmodifiableListView) return _amenities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_amenities);
}

@override final  int? numberOfFloors;
@override final  int floorNumber;
@override final  DateTime? availableFrom;
@override final  String? minimumLeaseTerm;
@override final  double annualRent;
@override final  double annualRentWithVat;
@override final  String currency;
@override final  int? securityDepositMonths;
@override@ListingStatusConverter() final  ListingStatus status;
 final  List<ListingMedia> _media;
@override List<ListingMedia> get media {
  if (_media is EqualUnmodifiableListView) return _media;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_media);
}

@override final  String? thumbnailUrl;
@override final  bool? isSaved;
@override final  String? whatsappLink;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of ShopListing
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShopListingCopyWith<_ShopListing> get copyWith => __$ShopListingCopyWithImpl<_ShopListing>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShopListingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShopListing&&(identical(other.id, id) || other.id == id)&&(identical(other.landlordId, landlordId) || other.landlordId == landlordId)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.areaSqm, areaSqm) || other.areaSqm == areaSqm)&&(identical(other.city, city) || other.city == city)&&(identical(other.district, district) || other.district == district)&&(identical(other.address, address) || other.address == address)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._amenities, _amenities)&&(identical(other.numberOfFloors, numberOfFloors) || other.numberOfFloors == numberOfFloors)&&(identical(other.floorNumber, floorNumber) || other.floorNumber == floorNumber)&&(identical(other.availableFrom, availableFrom) || other.availableFrom == availableFrom)&&(identical(other.minimumLeaseTerm, minimumLeaseTerm) || other.minimumLeaseTerm == minimumLeaseTerm)&&(identical(other.annualRent, annualRent) || other.annualRent == annualRent)&&(identical(other.annualRentWithVat, annualRentWithVat) || other.annualRentWithVat == annualRentWithVat)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.securityDepositMonths, securityDepositMonths) || other.securityDepositMonths == securityDepositMonths)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._media, _media)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.isSaved, isSaved) || other.isSaved == isSaved)&&(identical(other.whatsappLink, whatsappLink) || other.whatsappLink == whatsappLink)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,landlordId,title,category,areaSqm,city,district,address,description,const DeepCollectionEquality().hash(_amenities),numberOfFloors,floorNumber,availableFrom,minimumLeaseTerm,annualRent,annualRentWithVat,currency,securityDepositMonths,status,const DeepCollectionEquality().hash(_media),thumbnailUrl,isSaved,whatsappLink,createdAt,updatedAt]);

@override
String toString() {
  return 'ShopListing(id: $id, landlordId: $landlordId, title: $title, category: $category, areaSqm: $areaSqm, city: $city, district: $district, address: $address, description: $description, amenities: $amenities, numberOfFloors: $numberOfFloors, floorNumber: $floorNumber, availableFrom: $availableFrom, minimumLeaseTerm: $minimumLeaseTerm, annualRent: $annualRent, annualRentWithVat: $annualRentWithVat, currency: $currency, securityDepositMonths: $securityDepositMonths, status: $status, media: $media, thumbnailUrl: $thumbnailUrl, isSaved: $isSaved, whatsappLink: $whatsappLink, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ShopListingCopyWith<$Res> implements $ShopListingCopyWith<$Res> {
  factory _$ShopListingCopyWith(_ShopListing value, $Res Function(_ShopListing) _then) = __$ShopListingCopyWithImpl;
@override @useResult
$Res call({
 String id, String? landlordId, String title, String category, double areaSqm, String city, String district, String? address, String? description, List<String> amenities, int? numberOfFloors, int floorNumber, DateTime? availableFrom, String? minimumLeaseTerm, double annualRent, double annualRentWithVat, String currency, int? securityDepositMonths,@ListingStatusConverter() ListingStatus status, List<ListingMedia> media, String? thumbnailUrl, bool? isSaved, String? whatsappLink, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$ShopListingCopyWithImpl<$Res>
    implements _$ShopListingCopyWith<$Res> {
  __$ShopListingCopyWithImpl(this._self, this._then);

  final _ShopListing _self;
  final $Res Function(_ShopListing) _then;

/// Create a copy of ShopListing
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? landlordId = freezed,Object? title = null,Object? category = null,Object? areaSqm = null,Object? city = null,Object? district = null,Object? address = freezed,Object? description = freezed,Object? amenities = null,Object? numberOfFloors = freezed,Object? floorNumber = null,Object? availableFrom = freezed,Object? minimumLeaseTerm = freezed,Object? annualRent = null,Object? annualRentWithVat = null,Object? currency = null,Object? securityDepositMonths = freezed,Object? status = null,Object? media = null,Object? thumbnailUrl = freezed,Object? isSaved = freezed,Object? whatsappLink = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_ShopListing(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,landlordId: freezed == landlordId ? _self.landlordId : landlordId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,areaSqm: null == areaSqm ? _self.areaSqm : areaSqm // ignore: cast_nullable_to_non_nullable
as double,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,amenities: null == amenities ? _self._amenities : amenities // ignore: cast_nullable_to_non_nullable
as List<String>,numberOfFloors: freezed == numberOfFloors ? _self.numberOfFloors : numberOfFloors // ignore: cast_nullable_to_non_nullable
as int?,floorNumber: null == floorNumber ? _self.floorNumber : floorNumber // ignore: cast_nullable_to_non_nullable
as int,availableFrom: freezed == availableFrom ? _self.availableFrom : availableFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,minimumLeaseTerm: freezed == minimumLeaseTerm ? _self.minimumLeaseTerm : minimumLeaseTerm // ignore: cast_nullable_to_non_nullable
as String?,annualRent: null == annualRent ? _self.annualRent : annualRent // ignore: cast_nullable_to_non_nullable
as double,annualRentWithVat: null == annualRentWithVat ? _self.annualRentWithVat : annualRentWithVat // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,securityDepositMonths: freezed == securityDepositMonths ? _self.securityDepositMonths : securityDepositMonths // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ListingStatus,media: null == media ? _self._media : media // ignore: cast_nullable_to_non_nullable
as List<ListingMedia>,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,isSaved: freezed == isSaved ? _self.isSaved : isSaved // ignore: cast_nullable_to_non_nullable
as bool?,whatsappLink: freezed == whatsappLink ? _self.whatsappLink : whatsappLink // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
