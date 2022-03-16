library notification_service;

import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/notification/channels/auto_save_channel.dart';
import 'package:spooky/core/notification/channels/base_notification_channel.dart';
import 'package:spooky/core/storages/local_storages/theme_storage.dart';
import 'package:spooky/core/types/notification_channel_types.dart';
import 'package:spooky/core/notification/payloads/base_notification_payload.dart';

part './notification_config.dart';

class NotificationService {
  static final AwesomeNotifications notifications = AwesomeNotifications();
  static final _NotificationConfig config = _NotificationConfig();

  static Future<void> initialize() async {
    if (!(Platform.isAndroid || Platform.isIOS)) return;

    await notifications.initialize(
      'resource://drawable/ic_notification',
      config.channels,
      debug: kDebugMode,
    );

    notifications.isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) notifications.requestPermissionToSendNotifications();
    });

    notifications.actionStream.listen((ReceivedAction event) {
      NotificationChannelTypes? type;
      for (final _type in NotificationChannelTypes.values) {
        if (_type.name == event.channelKey) {
          type = _type;
          break;
        }
      }
      if (type != null) {
        BaseNotificationChannel<BaseNotificationPayload>? channel = config.channelByType(type);
        channel?.triggered(
          buttonKey: event.buttonKeyPressed,
          payload: event.payload,
        );
      }
    });
  }
}
