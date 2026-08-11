// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advisor_source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdvisorSource _$AdvisorSourceFromJson(Map<String, dynamic> json) =>
    _AdvisorSource(
      documentId: json['document_id'] as String?,
      title: json['title'] as String?,
      category: json['category'] as String?,
      businessType: json['business_type'] as String?,
    );

Map<String, dynamic> _$AdvisorSourceToJson(_AdvisorSource instance) =>
    <String, dynamic>{
      'document_id': instance.documentId,
      'title': instance.title,
      'category': instance.category,
      'business_type': instance.businessType,
    };
