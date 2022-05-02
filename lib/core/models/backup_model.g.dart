// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackupModel _$BackupModelFromJson(Map<String, dynamic> json) => BackupModel(
      year: json['year'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      stories: (json['stories'] as List<dynamic>)
          .map((e) => StoryDbModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BackupModelToJson(BackupModel instance) =>
    <String, dynamic>{
      'year': instance.year,
      'created_at': instance.createdAt.toIso8601String(),
      'stories': instance.stories.map((e) => e.toJson()).toList(),
    };
