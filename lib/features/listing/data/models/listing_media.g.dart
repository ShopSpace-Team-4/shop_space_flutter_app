// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ListingMedia _$ListingMediaFromJson(Map<String, dynamic> json) =>
    _ListingMedia(
      id: json['_id'] as String,
      mediaType: json['mediaType'] as String,
      url: json['url'] as String,
      sortOrder: (json['sortOrder'] as num).toInt(),
    );

Map<String, dynamic> _$ListingMediaToJson(_ListingMedia instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'mediaType': instance.mediaType,
      'url': instance.url,
      'sortOrder': instance.sortOrder,
    };
