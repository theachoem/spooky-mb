// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_content_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryContentModel _$StoryContentModelFromJson(Map<String, dynamic> json) =>
    StoryContentModel(
      id: json['id'] as String?,
      starred: json['starred'] as bool?,
      feeling: json['feeling'] as String?,
      title: json['title'] as String?,
      plainText: json['plain_text'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      pages: (json['pages'] as List<dynamic>?)
          ?.map((e) => e as List<dynamic>)
          .toList(),
    );

Map<String, dynamic> _$StoryContentModelToJson(StoryContentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'starred': instance.starred,
      'feeling': instance.feeling,
      'title': instance.title,
      'plain_text': instance.plainText,
      'created_at': instance.createdAt?.toIso8601String(),
      'pages': instance.pages,
    };
