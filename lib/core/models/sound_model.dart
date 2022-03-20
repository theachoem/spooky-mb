import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/types/sound_type.dart';

part 'sound_model.g.dart';

@JsonSerializable()
class SoundModel {
  SoundModel({
    required this.type,
    required this.soundName,
    required this.fileName,
    required this.fileSize,
    required this.weatherType,
  });

  final SoundType type;
  final String soundName;
  final String fileName;
  final int fileSize;
  final WeatherType weatherType;

  Map<String, dynamic> toJson() => _$SoundModelToJson(this);
  factory SoundModel.fromJson(Map<String, dynamic> json) => _$SoundModelFromJson(json);
}
