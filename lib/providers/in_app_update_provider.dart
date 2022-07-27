import 'dart:io';
import 'package:new_version/new_version.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:url_launcher/url_launcher_string.dart';

class InAppUpdateProvider extends ChangeNotifier {
  bool get isUpdateAvailable => immediateUpdateAllowed || flexibleUpdateAllowed;
  AppUpdateInfo? androidUpdateInfo;
  VersionStatus? updateInfo;
  bool updating = false;

  String? get storeVersion => updateInfo?.storeVersion ?? androidUpdateInfo?.availableVersionCode.toString();

  bool immediateUpdateAllowed = false;
  bool flexibleUpdateAllowed = false;

  InAppUpdateProvider() {
    load();
  }

  Future<void> load() async {
    updateInfo = await NewVersion().getVersionStatus();
    if (Platform.isAndroid) {
      try {
        androidUpdateInfo = await InAppUpdate.checkForUpdate();
        immediateUpdateAllowed = androidUpdateInfo!.immediateUpdateAllowed;
        flexibleUpdateAllowed = androidUpdateInfo!.flexibleUpdateAllowed;
      } catch (e) {
        immediateUpdateAllowed = false;
        flexibleUpdateAllowed = false;
      }
      notifyListeners();
    } else if (Platform.isIOS) {
      if (updateInfo?.canUpdate == true) {
        flexibleUpdateAllowed = true;
        notifyListeners();
      }
    }
  }

  Future<void> update() async {
    if (Platform.isAndroid) {
      await _updateAndroid();
    } else {
      await _updateIos();
    }
  }

  Future<void> _updateIos() async {
    final url = updateInfo?.appStoreLink;
    if (url != null) {
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
      }
    }
  }

  Future<void> _updateAndroid() async {
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
