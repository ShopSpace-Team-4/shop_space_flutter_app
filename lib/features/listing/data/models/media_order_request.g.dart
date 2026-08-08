// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_order_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MediaOrderEntry _$MediaOrderEntryFromJson(Map<String, dynamic> json) =>
    _MediaOrderEntry(
      mediaId: json['mediaId'] as String,
      sortOrder: (json['sortOrder'] as num).toInt(),
    );

Map<String, dynamic> _$MediaOrderEntryToJson(_MediaOrderEntry instance) =>
    <String, dynamic>{
      'mediaId': instance.mediaId,
      'sortOrder': instance.sortOrder,
    };

_MediaOrderRequest _$MediaOrderRequestFromJson(Map<String, dynamic> json) =>
    _MediaOrderRequest(
      media: (json['media'] as List<dynamic>)
          .map((e) => MediaOrderEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MediaOrderRequestToJson(_MediaOrderRequest instance) =>
    <String, dynamic>{'media': instance.media};
