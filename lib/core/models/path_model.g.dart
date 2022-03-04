// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'path_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PathModel _$PathModelFromJson(Map<String, dynamic> json) => PathModel(
      fileName: json['file_name'] as String,
      year: json['year'] as int,
      month: json['month'] as int,
      day: json['day'] as int,
      filePath: $enumDecode(_$FilePathTypeEnumMap, json['file_path']),
    );

Map<String, dynamic> _$PathModelToJson(PathModel instance) => <String, dynamic>{
      'file_name': instance.fileName,
      'year': instance.year,
      'month': instance.month,
      'day': instance.day,
      'file_path': _$FilePathTypeEnumMap[instance.filePath],
    };

const _$FilePathTypeEnumMap = {
  FilePathType.user: 'user',
  FilePathType.docs: 'docs',
  FilePathType.archive: 'archive',
  FilePathType.backups: 'backups',
};
