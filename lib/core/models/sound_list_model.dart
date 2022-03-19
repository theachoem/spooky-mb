import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/models/sound_model.dart';

part 'sound_list_model.g.dart';

@JsonSerializable()
class SoundListModel {
  SoundListModel({required this.sounds});
  final List<SoundModel> sounds;

  SoundListModel copyWith({
    List<SoundModel>? sounds,
  }) {
    return SoundListModel(
      sounds: sounds ?? this.sounds,
    );
  }

  Map<String, dynamic> toJson() => _$SoundListModelToJson(this);
  factory SoundListModel.fromJson(Map<String, dynamic> json) => _$SoundListModelFromJson(json);
}
