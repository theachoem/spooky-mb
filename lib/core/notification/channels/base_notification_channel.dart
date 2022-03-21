import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/types/notification_channel_types.dart';
import 'package:spooky/core/notification/notification_service.dart';
import 'package:spooky/core/notification/payloads/base_notification_payload.dart';

abstract class BaseNotificationChannel<T extends BaseNotificationPayload> {
  NotificationChannelTypes get channelKey;
  String get channelName;
  String get channelDescription;

  BuildContext? get context => App.navigatorKey.currentContext;

  Future<void> triggered({
    String? buttonKey,
    Map<String, String>? payload,
  });

  Future<bool> show({
    required String title,
    required String? body,
    required T? payload,
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
      payload: payload?.toPayload(),
      category: NotificationCategory.Alarm,
    );
    return NotificationService.notifications.createNotification(
      content: content,
      actionButtons: actionButtons,
    );
  }

  List<NotificationActionButton>? get actionButtons;
}
