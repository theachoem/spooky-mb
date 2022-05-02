// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_db_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryDbModel _$StoryDbModelFromJson(Map<String, dynamic> json) => StoryDbModel(
      type: $enumDecode(_$PathTypeEnumMap, json['type']),
      id: json['id'] as int,
      starred: json['starred'] as bool?,
      feeling: json['feeling'] as String?,
      year: json['year'] as int,
      month: json['month'] as int,
      day: json['day'] as int,
      changes: (json['changes'] as List<dynamic>)
          .map((e) => StoryContentDbModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoryDbModelToJson(StoryDbModel instance) =>
    <String, dynamic>{
      'type': _$PathTypeEnumMap[instance.type],
      'id': instance.id,
      'year': instance.year,
      'month': instance.month,
      'day': instance.day,
      'starred': instance.starred,
      'feeling': instance.feeling,
      'changes': instance.changes.map((e) => e.toJson()).toList(),
    };

const _$PathTypeEnumMap = {
  PathType.docs: 'docs',
  PathType.bins: 'bins',
  PathType.archives: 'archives',
};
