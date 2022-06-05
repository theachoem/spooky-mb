import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

class InAppUpdateProvider extends ChangeNotifier {
  bool get isUpdateAvailable => immediateUpdateAllowed || flexibleUpdateAllowed;
  AppUpdateInfo? updateInfo;

  bool immediateUpdateAllowed = false;
  bool flexibleUpdateAllowed = false;

  InAppUpdateProvider() {
    load();
  }

  Future<void> load() async {
    if (Platform.isAndroid) {
      try {
        updateInfo = await InAppUpdate.checkForUpdate();
        immediateUpdateAllowed = updateInfo!.immediateUpdateAllowed;
        flexibleUpdateAllowed = updateInfo!.flexibleUpdateAllowed;
      } catch (e) {
        immediateUpdateAllowed = false;
        flexibleUpdateAllowed = false;
      }
      notifyListeners();
    }
  }

  bool updating = false;

  Future<void> update() async {
    if (flexibleUpdateAllowed) {
      if (updating) return;
      updating = true;
      final result = await InAppUpdate.startFlexibleUpdate();
      switch (result) {
        case AppUpdateResult.success:
          await InAppUpdate.completeFlexibleUpdate();
          break;
        case AppUpdateResult.userDeniedUpdate:
        case AppUpdateResult.inAppUpdateFailed:
          break;
      }
      updating = false;
    } else if (immediateUpdateAllowed) {
      if (updating) return;
      updating = true;
      await InAppUpdate.performImmediateUpdate();
      updating = false;
    }
  }
}
