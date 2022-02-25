library notification_service;

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/notification/channels/auto_save_channel.dart';
import 'package:spooky/core/notification/channels/base_notification_channel.dart';
import 'package:spooky/theme/m3/m3_color.dart';

part './notification_config.dart';

class NotificationService {
  static final AwesomeNotifications notifications = AwesomeNotifications();

  static Future<void> initialize() async {
    await notifications.initialize(
      'resource://drawable/ic_notification',
      _NotificationConfig().channels,
      debug: kDebugMode,
    );

    notifications.isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) notifications.requestPermissionToSendNotifications();
    });

    notifications.actionStream.listen((ReceivedAction event) {
      switch (event.channelKey) {
      }
    });
  }
}
