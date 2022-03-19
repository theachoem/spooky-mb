import 'package:json_annotation/json_annotation.dart';

part 'sound_model.g.dart';

@JsonSerializable()
class SoundModel {
  SoundModel({
    required this.soundName,
    required this.fileName,
    required this.fileSize,
  });

  final String soundName;
  final String fileName;
  final int fileSize;

  SoundModel copyWith({
    String? soundName,
    String? fileName,
    int? fileSize,
  }) {
    return SoundModel(
      soundName: soundName ?? this.soundName,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
    );
  }

  Map<String, dynamic> toJson() => _$SoundModelToJson(this);
  factory SoundModel.fromJson(Map<String, dynamic> json) => _$SoundModelFromJson(json);
}
