import 'package:json_annotation/json_annotation.dart';
import 'base_notification_payload.dart';

part 'play_sound_payload.g.dart';

@JsonSerializable()
class PlaySoundPayload extends BaseNotificationPayload {
  final String path;
  PlaySoundPayload(this.path);

  @override
  Map<String, dynamic> toJson() => _$PlaySoundPayloadToJson(this);
  factory PlaySoundPayload.fromJson(Map<String, dynamic> json) => _$PlaySoundPayloadFromJson(json);
}
