import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:spooky/core/notification/channels/base_notification_channel.dart';
import 'package:spooky/core/notification/notification_channel_types.dart';
import 'package:spooky/core/notification/payload/auto_save_payload.dart';

class AutoSaveChannel extends BaseNotificationChannel<AutoSavePayload> {
  @override
  List<NotificationActionButton> get actionButtons {
    return [
      NotificationActionButton(
        key: "view",
        label: "View",
      ),
    ];
  }

  @override
  NotificationChannelTypes get channelKey => NotificationChannelTypes.autoSave;

  @override
  String get channelName => 'Auto Save Notification';

  @override
  String get channelDescription => 'Show notification when stories is auto saved on app inactive.';
}
