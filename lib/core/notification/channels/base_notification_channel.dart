import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/types/notification_channel_types.dart';
import 'package:spooky/core/notification/notification_service.dart';
import 'package:spooky/core/notification/payloads/base_notification_payload.dart';
import 'package:spooky/theme/m3/m3_color.dart';

abstract class BaseNotificationChannel<T extends BaseNotificationPayload> {
  NotificationChannelTypes get channelKey;
  String get channelName;
  String get channelDescription;
  String? get icon;

  BuildContext? get context => App.navigatorKey.currentContext;
  bool get enableVibration;

  Future<void> triggered({
    String? buttonKey,
    Map<String, String?>? payload,
  });

  // if true mean there is no multiple notification in this channel.
  // old one will be overrided by latest one
  bool get singleInstance => false;
  int get defaultId => channelKey.hashCode;

  Future<bool> show({
    required int id,
    required String title,
    required String? body,
    required T? payload,
    String? groupKey,
    String? ticker,
    String? bigPicture,
    bool? autoDismissible,
    NotificationSchedule? schedule,
    NotificationLayout? notificationLayout,
  }) {
    notificationLayout ??= bigPicture != null ? NotificationLayout.BigPicture : NotificationLayout.Default;
    ColorScheme? colorScheme = context != null ? M3Color.of(context!) : null;

    NotificationContent content = NotificationContent(
      id: singleInstance ? defaultId : id,
      groupKey: groupKey,
      channelKey: channelKey.name,
      title: title,
      body: body,
      color: colorScheme?.onPrimary,
      autoDismissible: autoDismissible ?? true,
      backgroundColor: colorScheme?.primary,
      bigPicture: bigPicture,
      notificationLayout: notificationLayout,
      payload: payload?.toPayload(),
      ticker: ticker,
      icon: icon != null ? "resource://drawable/${icon!}" : null,
    );

    return NotificationService.notifications.createNotification(
      content: content,
      actionButtons: actionButtons,
    );
  }

  Future<void> dismiss(int id) async {
    return NotificationService.notifications.dismiss(id);
  }

  List<NotificationActionButton>? get actionButtons;
}
