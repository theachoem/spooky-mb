// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backups_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackupsModel _$BackupsModelFromJson(Map<String, dynamic> json) => BackupsModel(
      tables: json['tables'] as Map<String, dynamic>,
      metaData:
          BackupsMetadata.fromJson(json['meta_data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BackupsModelToJson(BackupsModel instance) =>
    <String, dynamic>{
      'tables': instance.tables,
      'meta_data': instance.metaData.toJson(),
    };
