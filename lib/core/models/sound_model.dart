import 'package:json_annotation/json_annotation.dart';

part 'sound_model.g.dart';

@JsonSerializable()
class SoundModel {
  SoundModel({
    required this.soundName,
    required this.fileName,
    required this.fileSize,
    required this.asset,
  });

  final String soundName;
  final String fileName;
  final int fileSize;
  final String? asset;

  Map<String, dynamic> toJson() => _$SoundModelToJson(this);
  factory SoundModel.fromJson(Map<String, dynamic> json) => _$SoundModelFromJson(json);
}
