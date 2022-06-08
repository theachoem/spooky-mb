library notification_service;

import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/notification/channels/auto_save_channel.dart';
import 'package:spooky/core/notification/channels/base_notification_channel.dart';
import 'package:spooky/core/notification/channels/play_sound_channel.dart';
import 'package:spooky/core/storages/local_storages/theme_storage.dart';
import 'package:spooky/core/types/notification_channel_types.dart';
import 'package:spooky/core/notification/payloads/base_notification_payload.dart';

part './notification_config.dart';

class NotificationService {
  static final AwesomeNotifications notifications = AwesomeNotifications();
  static final config = _NotificationConfig();

  static Future<bool> get isNotificationAllowed async {
    bool supportedPlatform = Platform.isAndroid || Platform.isIOS;
    if (!supportedPlatform) return true;
    return notifications.isNotificationAllowed();
  }

  static Future<bool> requestPermissionToSendNotifications() async {
    bool supportedPlatform = Platform.isAndroid || Platform.isIOS;
    if (!supportedPlatform) return false;
    return notifications.requestPermissionToSendNotifications();
  }

  static Future<void> initialize() async {
    bool supportedPlatform = Platform.isAndroid || Platform.isIOS;
    if (!supportedPlatform) return;

    await notifications.initialize(
      'resource://drawable/ic_notification',
      config.channels,
      debug: kDebugMode,
    );

    notifications.setListeners(onActionReceivedMethod: (ReceivedAction event) async {
      NotificationChannelTypes? type;

      for (final typeFromValues in NotificationChannelTypes.values) {
        if (typeFromValues.name == event.channelKey) {
          type = typeFromValues;
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
