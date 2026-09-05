// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_listing_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateListingRequest _$UpdateListingRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateListingRequest(
  title: json['title'] as String,
  category: json['category'] as String,
  areaSqm: (json['areaSqm'] as num).toDouble(),
  city: json['city'] as String,
  district: json['district'] as String,
  address: json['address'] as String,
  description: json['description'] as String,
  amenities: (json['amenities'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  numberOfFloors: (json['numberOfFloors'] as num).toInt(),
  floorNumber: (json['floorNumber'] as num).toInt(),
  availableFrom: json['availableFrom'] as String,
  minimumLeaseTerm: json['minimumLeaseTerm'] as String,
  annualRent: (json['annualRent'] as num).toDouble(),
  currency: json['currency'] as String?,
  securityDepositMonths: (json['securityDepositMonths'] as num).toInt(),
);

Map<String, dynamic> _$UpdateListingRequestToJson(
  _UpdateListingRequest instance,
) => <String, dynamic>{
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
  'availableFrom': instance.availableFrom,
  'minimumLeaseTerm': instance.minimumLeaseTerm,
  'annualRent': instance.annualRent,
  'currency': ?instance.currency,
  'securityDepositMonths': instance.securityDepositMonths,
};
