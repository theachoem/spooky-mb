import 'dart:io';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/providers/tab_notice_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class InAppUpdateProvider extends ChangeNotifier {
  static final InAppUpdateProvider instance = InAppUpdateProvider._();
  InAppUpdateProvider._();

  bool get isUpdateAvailable => immediateUpdateAllowed || flexibleUpdateAllowed;
  AppUpdateInfo? androidUpdateInfo;
  VersionStatus? iosUpdateInfo;
  bool updating = false;

  String? get storeVersion => iosUpdateInfo?.storeVersion ?? androidUpdateInfo?.availableVersionCode.toString();

  bool immediateUpdateAllowed = false;
  bool flexibleUpdateAllowed = false;

  Future<void> load() async {
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
      iosUpdateInfo = await NewVersionPlus().getVersionStatus();
      if (iosUpdateInfo?.canUpdate == true) {
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
    final url = iosUpdateInfo?.appStoreLink;
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

  @override
  void notifyListeners() {
    TabNoticeProvider.instance.set(
      SpRouter.setting,
      TabNoticeSetterSourceType.updater,
      add: isUpdateAvailable,
    );
    super.notifyListeners();
  }
}
