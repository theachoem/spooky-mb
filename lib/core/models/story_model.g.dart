// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryModel _$StoryModelFromJson(Map<String, dynamic> json) => StoryModel(
      starred: json['starred'] as bool?,
      feeling: json['feeling'] as String?,
      changes: (json['changes'] as List<dynamic>?)
          ?.map((e) => StoryContentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoryModelToJson(StoryModel instance) =>
    <String, dynamic>{
      'starred': instance.starred,
      'feeling': instance.feeling,
      'changes': instance.changes?.map((e) => e.toJson()).toList(),
    };
