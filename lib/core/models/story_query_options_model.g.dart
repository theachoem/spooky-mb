// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_query_options_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryQueryOptionsModel _$StoryQueryOptionsModelFromJson(
        Map<String, dynamic> json) =>
    StoryQueryOptionsModel(
      year: json['year'] as int?,
      month: json['month'] as int?,
      day: json['day'] as int?,
      tag: json['tag'] as String?,
      type: $enumDecode(_$PathTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$StoryQueryOptionsModelToJson(
        StoryQueryOptionsModel instance) =>
    <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
      'day': instance.day,
      'tag': instance.tag,
      'type': _$PathTypeEnumMap[instance.type],
    };

const _$PathTypeEnumMap = {
  PathType.docs: 'docs',
  PathType.bins: 'bins',
  PathType.archives: 'archives',
};
