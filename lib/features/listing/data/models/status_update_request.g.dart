// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StatusUpdateRequest _$StatusUpdateRequestFromJson(Map<String, dynamic> json) =>
    _StatusUpdateRequest(
      status: const ListingStatusConverter().fromJson(json['status'] as String),
    );

Map<String, dynamic> _$StatusUpdateRequestToJson(
  _StatusUpdateRequest instance,
) => <String, dynamic>{
  'status': const ListingStatusConverter().toJson(instance.status),
};
