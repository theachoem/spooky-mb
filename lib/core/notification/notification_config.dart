part of notification_service;

class _NotificationConfig {
  _NotificationConfig() {
    Set<String> channel = channels.map((e) => e.channelKey!).toSet();
    // assert to make sure channelKey are unique
    assert(channel.length == notifications.length);
  }

  List<BaseNotificationChannel> get notifications {
    return [
      AutoSaveChannel(),
    ];
  }

  List<NotificationChannel> get channels {
    return notifications.map((e) {
      return NotificationChannel(
        channelKey: e.channelKey.name,
        channelName: e.channelName,
        channelDescription: e.channelDescription,
        defaultColor: M3Color.currentPrimaryColor,
        ledColor: Colors.white,
      );
    }).toList();
  }
}
