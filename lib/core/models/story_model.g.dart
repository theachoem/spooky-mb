// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryModel _$StoryModelFromJson(Map<String, dynamic> json) => StoryModel(
      documentId: json['document_id'] as String?,
      fileId: json['file_id'] as String?,
      starred: json['starred'] as bool?,
      feeling: json['feeling'] as String?,
      title: json['title'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      plainText: json['plain_text'] as String?,
      document: json['document'] as List<dynamic>?,
    );

Map<String, dynamic> _$StoryModelToJson(StoryModel instance) =>
    <String, dynamic>{
      'document_id': instance.documentId,
      'file_id': instance.fileId,
      'starred': instance.starred,
      'feeling': instance.feeling,
      'title': instance.title,
      'created_at': instance.createdAt?.toIso8601String(),
      'plain_text': instance.plainText,
      'document': instance.document,
    };
