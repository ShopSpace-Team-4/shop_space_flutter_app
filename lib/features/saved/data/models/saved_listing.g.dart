// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_listing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SavedListing _$SavedListingFromJson(Map<String, dynamic> json) =>
    _SavedListing(
      id: json['id'] as String,
      title: json['title'] as String,
      location: json['location'] as String,
      annualRent: (json['annualRent'] as num).toDouble(),
      annualRentWithVat: (json['annualRentWithVat'] as num).toDouble(),
      currency: json['currency'] as String,
      areaSqm: (json['areaSqm'] as num).toDouble(),
      thumbnailUrl: json['thumbnailUrl'] as String?,
      isSaved: json['isSaved'] as bool?,
    );

Map<String, dynamic> _$SavedListingToJson(_SavedListing instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'location': instance.location,
      'annualRent': instance.annualRent,
      'annualRentWithVat': instance.annualRentWithVat,
      'currency': instance.currency,
      'areaSqm': instance.areaSqm,
      'thumbnailUrl': instance.thumbnailUrl,
      'isSaved': instance.isSaved,
    };
