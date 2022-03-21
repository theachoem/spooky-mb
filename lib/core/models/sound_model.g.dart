// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sound_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SoundModel _$SoundModelFromJson(Map<String, dynamic> json) => SoundModel(
      type: $enumDecode(_$SoundTypeEnumMap, json['type']),
      soundName: json['sound_name'] as String,
      fileName: json['file_name'] as String,
      fileSize: json['file_size'] as int,
      weatherType: $enumDecode(_$WeatherTypeEnumMap, json['weather_type']),
    );

Map<String, dynamic> _$SoundModelToJson(SoundModel instance) =>
    <String, dynamic>{
      'type': _$SoundTypeEnumMap[instance.type],
      'sound_name': instance.soundName,
      'file_name': instance.fileName,
      'file_size': instance.fileSize,
      'weather_type': _$WeatherTypeEnumMap[instance.weatherType],
    };

const _$SoundTypeEnumMap = {
  SoundType.sound: 'sound',
  SoundType.music: 'music',
};

const _$WeatherTypeEnumMap = {
  WeatherType.heavyRainy: 'heavyRainy',
  WeatherType.heavySnow: 'heavySnow',
  WeatherType.middleSnow: 'middleSnow',
  WeatherType.thunder: 'thunder',
  WeatherType.lightRainy: 'lightRainy',
  WeatherType.lightSnow: 'lightSnow',
  WeatherType.sunnyNight: 'sunnyNight',
  WeatherType.sunny: 'sunny',
  WeatherType.cloudy: 'cloudy',
  WeatherType.cloudyNight: 'cloudyNight',
  WeatherType.middleRainy: 'middleRainy',
  WeatherType.overcast: 'overcast',
  WeatherType.hazy: 'hazy',
  WeatherType.foggy: 'foggy',
  WeatherType.dusty: 'dusty',
};
