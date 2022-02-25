import 'package:json_annotation/json_annotation.dart';
import 'base_notification_payload.dart';

part 'auto_save_payload.g.dart';

@JsonSerializable()
class AutoSavePayload extends BaseNotificationPayload {
  final String path;
  AutoSavePayload(this.path);

  @override
  Map<String, dynamic> toJson() => _$AutoSavePayloadToJson(this);
  factory AutoSavePayload.fromJson(Map<String, dynamic> json) => _$AutoSavePayloadFromJson(json);
}
