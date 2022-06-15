// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backups_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackupsMetadata _$BackupsMetadataFromJson(Map<String, dynamic> json) =>
    BackupsMetadata(
      version: json['version'] as String? ?? "1",
      deviceModel: json['device_model'] as String,
      deviceId: json['device_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$BackupsMetadataToJson(BackupsMetadata instance) =>
    <String, dynamic>{
      'device_model': instance.deviceModel,
      'device_id': instance.deviceId,
      'created_at': instance.createdAt.toIso8601String(),
      'version': instance.version,
    };
