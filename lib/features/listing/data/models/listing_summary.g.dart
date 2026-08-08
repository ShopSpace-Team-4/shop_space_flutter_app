// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ListingSummary _$ListingSummaryFromJson(Map<String, dynamic> json) =>
    _ListingSummary(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      areaSqm: (json['areaSqm'] as num).toDouble(),
      annualRent: (json['annualRent'] as num).toDouble(),
      currency: json['currency'] as String,
      status: const ListingStatusConverter().fromJson(json['status'] as String),
      thumbnailUrl: json['thumbnailUrl'] as String?,
    );

Map<String, dynamic> _$ListingSummaryToJson(_ListingSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'areaSqm': instance.areaSqm,
      'annualRent': instance.annualRent,
      'currency': instance.currency,
      'status': const ListingStatusConverter().toJson(instance.status),
      'thumbnailUrl': instance.thumbnailUrl,
    };
