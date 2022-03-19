// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sound_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SoundListModel _$SoundListModelFromJson(Map<String, dynamic> json) =>
    SoundListModel(
      sounds: (json['sounds'] as List<dynamic>)
          .map((e) => SoundModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SoundListModelToJson(SoundListModel instance) =>
    <String, dynamic>{
      'sounds': instance.sounds.map((e) => e.toJson()).toList(),
    };
