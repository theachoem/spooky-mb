import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/notification/channels/base_notification_channel.dart';
import 'package:spooky/core/notification/payloads/play_sound_payload.dart';
import 'package:spooky/core/types/notification_channel_types.dart';
import 'package:spooky/providers/mini_sound_player_provider.dart';

class PlaySoundChannel extends BaseNotificationChannel<PlaySoundPayload> {
  @override
  String get channelName => tr("notification_channel.play_sound.name");

  @override
  bool get enableVibration => false;

  @override
  String get channelDescription => tr("notification_channel.play_sound.description");

  @override
  NotificationChannelTypes get channelKey => NotificationChannelTypes.playSounds;

  @override
  String? get icon => "ni_play_sound";

  @override
  bool get singleInstance => true;

  @override
  List<NotificationActionButton>? get actionButtons {
    return [
      NotificationActionButton(
        key: "open",
        label: tr("button.open"),
        showInCompactView: true,
      ),
      // stop from background only available on IOS
      if (Platform.isIOS)
        NotificationActionButton(
          key: "stop",
          label: tr("button.stop"),
          showInCompactView: true,
          actionType: ActionType.DisabledAction,
        ),
    ];
  }

  @override
  Future<void> triggered({
    String? buttonKey,
    Map<String, String?>? payload,
  }) async {
    switch (buttonKey) {
      case "open":
        break;
      case "stop":
        BuildContext? context = App.navigatorKey.currentContext;
        if (context != null) {
          context.read<MiniSoundPlayerProvider>().onDismissed();
        }
        break;
      default:
    }
  }
}
