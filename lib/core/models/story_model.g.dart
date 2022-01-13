// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryModel _$StoryModelFromJson(Map<String, dynamic> json) => StoryModel(
      id: json['id'] as String,
      changes: (json['changes'] as List<dynamic>)
          .map((e) => StoryContentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      path: PathModel.fromJson(json['path'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StoryModelToJson(StoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'path': instance.path.toJson(),
      'changes': instance.changes.map((e) => e.toJson()).toList(),
    };
