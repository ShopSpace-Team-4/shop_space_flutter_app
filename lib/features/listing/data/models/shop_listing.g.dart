// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_listing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShopListing _$ShopListingFromJson(Map<String, dynamic> json) => _ShopListing(
  id: json['id'] as String,
  landlordId: json['landlordId'] as String?,
  title: json['title'] as String,
  category: json['category'] as String,
  areaSqm: (json['areaSqm'] as num).toDouble(),
  city: json['city'] as String,
  district: json['district'] as String,
  address: json['address'] as String?,
  description: json['description'] as String?,
  amenities: (json['amenities'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  numberOfFloors: (json['numberOfFloors'] as num?)?.toInt(),
  floorNumber: (json['floorNumber'] as num).toInt(),
  availableFrom: json['availableFrom'] == null
      ? null
      : DateTime.parse(json['availableFrom'] as String),
  minimumLeaseTerm: json['minimumLeaseTerm'] as String?,
  annualRent: (json['annualRent'] as num).toDouble(),
  annualRentWithVat: (json['annualRentWithVat'] as num).toDouble(),
  currency: json['currency'] as String,
  securityDepositMonths: (json['securityDepositMonths'] as num?)?.toInt(),
  status: const ListingStatusConverter().fromJson(json['status'] as String),
  media: (json['media'] as List<dynamic>)
      .map((e) => ListingMedia.fromJson(e as Map<String, dynamic>))
      .toList(),
  thumbnailUrl: json['thumbnailUrl'] as String?,
  isSaved: json['isSaved'] as bool?,
  whatsappLink: json['whatsappLink'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ShopListingToJson(_ShopListing instance) =>
    <String, dynamic>{
      'id': instance.id,
      'landlordId': instance.landlordId,
      'title': instance.title,
      'category': instance.category,
      'areaSqm': instance.areaSqm,
      'city': instance.city,
      'district': instance.district,
      'address': instance.address,
      'description': instance.description,
      'amenities': instance.amenities,
      'numberOfFloors': instance.numberOfFloors,
      'floorNumber': instance.floorNumber,
      'availableFrom': instance.availableFrom?.toIso8601String(),
      'minimumLeaseTerm': instance.minimumLeaseTerm,
      'annualRent': instance.annualRent,
      'annualRentWithVat': instance.annualRentWithVat,
      'currency': instance.currency,
      'securityDepositMonths': instance.securityDepositMonths,
      'status': const ListingStatusConverter().toJson(instance.status),
      'media': instance.media,
      'thumbnailUrl': instance.thumbnailUrl,
      'isSaved': instance.isSaved,
      'whatsappLink': instance.whatsappLink,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
