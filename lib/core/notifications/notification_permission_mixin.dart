import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:spooky/core/notifications/base_notification.dart';

mixin NotificationPermissionMixin on BaseNotification {
  Future<bool?> requestIosPermissions() async {
    return flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<bool?> requestMacOsPermissions() async {
    return flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}
