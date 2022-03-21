part of notification_service;

class _NotificationConfig {
  BaseNotificationChannel? channelByType(NotificationChannelTypes type) {
    return notificationsMap[type];
  }

  Map<NotificationChannelTypes, BaseNotificationChannel> get notificationsMap {
    return {
      NotificationChannelTypes.autoSave: AutoSaveChannel(),
      NotificationChannelTypes.playSounds: PlaySoundChannel(),
    };
  }

  List<BaseNotificationChannel> get notifications {
    return notificationsMap.values.toList();
  }

  List<NotificationChannel> get channels {
    return notifications.map((e) {
      return NotificationChannel(
        channelKey: e.channelKey.name,
        channelName: e.channelName,
        channelDescription: e.channelDescription,
        defaultColor: ThemeStorage.theme.colorSeed,
        ledColor: Colors.white,
      );
    }).toList();
  }
}
