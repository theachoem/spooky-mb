import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
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
      title: tr("alert.notification_permission.title"),
      message: tr("alert.notification_permission.message"),
      okLabel: tr("button.enable_notification"),
    );

    if (value == OkCancelResult.ok) {
      await NotificationService.requestPermissionToSendNotifications();
      load();
    }
  }
}
