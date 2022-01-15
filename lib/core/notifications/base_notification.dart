import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:spooky/core/models/base_route_model.dart';

abstract class BaseNotification {
  String notificatonChannelId = "com.juniorise.spooky/notification";
  String notificatonChannelName = "Spooky Notification";

  bool autoSave = true;
  static late final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  static late final AndroidInitializationSettings _initializationSettingsAndroid;
  static late final IOSInitializationSettings _initializationSettingsIOS;
  static late final MacOSInitializationSettings _initializationSettingsMacOS;
  static late final InitializationSettings _initializationSettings;

  FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin => _flutterLocalNotificationsPlugin;
  AndroidInitializationSettings get initializationSettingsAndroid => _initializationSettingsAndroid;
  IOSInitializationSettings get initializationSettingsIOS => _initializationSettingsIOS;
  MacOSInitializationSettings get initializationSettingsMacOS => _initializationSettingsMacOS;
  InitializationSettings get initializationSettings => _initializationSettings;

  Future<void> initialize() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializationSettingsAndroid = AndroidInitializationSettings('@drawable/ic_notification');

    _initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: autoSave,
      requestBadgePermission: autoSave,
      requestAlertPermission: autoSave,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    _initializationSettingsMacOS = MacOSInitializationSettings(
      requestAlertPermission: autoSave,
      requestBadgePermission: autoSave,
      requestSoundPermission: autoSave,
    );

    _initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: selectNotification);
  }

  void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload);
  void selectNotification(String? payload);

  Future<void> displayNotification({
    required String plainTitle,
    required String plainBody,
    required BaseRouteModel? payload,
  }) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      notificatonChannelId,
      notificatonChannelName,
      channelDescription: "Display auto save alert.",
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );
    final IOSNotificationDetails iosPlatformChannelSpecifics = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );
    return await flutterLocalNotificationsPlugin.show(
      0,
      plainTitle,
      plainBody,
      platformChannelSpecifics,
      payload: payload?.payload,
    );
  }
}
