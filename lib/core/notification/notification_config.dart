part of notification_service;

class _NotificationConfig {
  _NotificationConfig() {
    Set<String> channel = channels.map((e) => e.channelKey!).toSet();
    // assert to make sure channelKey are unique
    assert(channel.length == notifications.length);
  }

  BaseNotificationChannel? channelByType(NotificationChannelTypes type) {
    return notificationsMap[type];
  }

  Map<NotificationChannelTypes, BaseNotificationChannel> get notificationsMap {
    return {
      NotificationChannelTypes.autoSave: AutoSaveChannel(),
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
