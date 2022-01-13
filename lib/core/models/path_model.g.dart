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
    );

Map<String, dynamic> _$PathModelToJson(PathModel instance) => <String, dynamic>{
      'file_name': instance.fileName,
      'year': instance.year,
      'month': instance.month,
      'day': instance.day,
    };
