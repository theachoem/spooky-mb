// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_content_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryContentModel _$StoryContentModelFromJson(Map<String, dynamic> json) =>
    StoryContentModel(
      document: json['document'] as List<dynamic>?,
      title: json['title'] as String?,
      createOn: json['create_on'] == null
          ? null
          : DateTime.parse(json['create_on'] as String),
    );

Map<String, dynamic> _$StoryContentModelToJson(StoryContentModel instance) =>
    <String, dynamic>{
      'document': instance.document,
      'title': instance.title,
      'create_on': instance.createOn?.toIso8601String(),
    };
