// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryModel _$StoryModelFromJson(Map<String, dynamic> json) => StoryModel(
      id: json['id'] as String,
      path: PathModel.fromJson(json['path'] as Map<String, dynamic>),
      synced: json['synced'] as bool? ?? false,
      changes: (json['changes'] as List<dynamic>?)
              ?.map(
                  (e) => StoryContentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      cloudIds: (json['cloud_ids'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$StoryModelToJson(StoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'path': instance.path.toJson(),
      'changes': instance.changes.map((e) => e.toJson()).toList(),
      'synced': instance.synced,
      'cloud_ids': instance.cloudIds,
    };
