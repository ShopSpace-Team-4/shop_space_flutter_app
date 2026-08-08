// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ListingMeta _$ListingMetaFromJson(Map<String, dynamic> json) => _ListingMeta(
  categories: (json['categories'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  amenities: (json['amenities'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  statuses: (json['statuses'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$ListingMetaToJson(_ListingMeta instance) =>
    <String, dynamic>{
      'categories': instance.categories,
      'amenities': instance.amenities,
      'statuses': instance.statuses,
    };
