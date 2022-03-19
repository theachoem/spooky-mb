// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sound_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SoundModel _$SoundModelFromJson(Map<String, dynamic> json) => SoundModel(
      soundName: json['sound_name'] as String,
      fileName: json['file_name'] as String,
      fileSize: json['file_size'] as int,
    );

Map<String, dynamic> _$SoundModelToJson(SoundModel instance) => <String, dynamic>{
      'sound_name': instance.soundName,
      'file_name': instance.fileName,
      'file_size': instance.fileSize,
    };
