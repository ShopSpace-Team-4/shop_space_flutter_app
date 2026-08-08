// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'browse_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BrowsePage _$BrowsePageFromJson(Map<String, dynamic> json) => _BrowsePage(
  items: (json['items'] as List<dynamic>)
      .map((e) => BrowseListing.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: BrowseMeta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BrowsePageToJson(_BrowsePage instance) =>
    <String, dynamic>{'items': instance.items, 'meta': instance.meta};

_BrowseMeta _$BrowseMetaFromJson(Map<String, dynamic> json) => _BrowseMeta(
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  pages: (json['pages'] as num).toInt(),
);

Map<String, dynamic> _$BrowseMetaToJson(_BrowseMeta instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'total': instance.total,
      'pages': instance.pages,
    };
