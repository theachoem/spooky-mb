import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/notification/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  bool isAllow = true;

  NotificationProvider() {
    load();
  }

  Future<void> load() async {
    bool isAllow = await NotificationService.isNotificationAllowed;
    if (isAllow != this.isAllow) {
      this.isAllow = isAllow;
      notifyListeners();
    }
  }

  Future<void> requestPermission(BuildContext context) async {
    OkCancelResult value = await showOkAlertDialog(
      context: context,
      title: "Notification permission",
      message: "Required to alert you about such as auto save, etc.",
      okLabel: "Enable notification",
    );

    if (value == OkCancelResult.ok) {
      await NotificationService.requestPermissionToSendNotifications();
      load();
    }
  }
}
