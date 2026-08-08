// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'browse_listing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BrowseListing _$BrowseListingFromJson(Map<String, dynamic> json) =>
    _BrowseListing(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      areaSqm: (json['areaSqm'] as num).toDouble(),
      city: json['city'] as String,
      district: json['district'] as String,
      annualRent: (json['annualRent'] as num).toDouble(),
      annualRentWithVat: (json['annualRentWithVat'] as num).toDouble(),
      currency: json['currency'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      isSaved: json['isSaved'] as bool?,
    );

Map<String, dynamic> _$BrowseListingToJson(_BrowseListing instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'areaSqm': instance.areaSqm,
      'city': instance.city,
      'district': instance.district,
      'annualRent': instance.annualRent,
      'annualRentWithVat': instance.annualRentWithVat,
      'currency': instance.currency,
      'thumbnailUrl': instance.thumbnailUrl,
      'isSaved': instance.isSaved,
    };
