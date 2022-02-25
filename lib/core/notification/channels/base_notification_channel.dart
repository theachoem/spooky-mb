import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:spooky/core/notification/notification_channel_types.dart';
import 'package:spooky/core/notification/notification_service.dart';
import 'package:spooky/core/notification/payload/base_notification_payload.dart';

abstract class BaseNotificationChannel<T extends BaseNotificationPayload> {
  NotificationChannelTypes get channelKey;
  String get channelName;
  String get channelDescription;

  Future<bool> show({
    required String title,
    required String body,
    required T payload,
    String? bigPicture,
    NotificationSchedule? schedule,
    NotificationLayout? notificationLayout,
  }) {
    notificationLayout ??= bigPicture != null ? NotificationLayout.BigPicture : null;
    NotificationContent content = NotificationContent(
      id: title.hashCode,
      channelKey: channelKey.name,
      title: title,
      body: body,
      bigPicture: bigPicture,
      notificationLayout: notificationLayout,
      payload: payload.toJson(),
    );
    return NotificationService.notifications.createNotification(
      content: content,
      actionButtons: actionButtons,
    );
  }

  List<NotificationActionButton> get actionButtons;
}
