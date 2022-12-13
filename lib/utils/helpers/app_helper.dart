import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:spooky/main.dart';
import 'package:spooky/utils/constants/app_constant.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spooky/app.dart';
import 'dart:convert';
import 'dart:math';

class AppHelper {
  AppHelper._internal();
  static const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  static int dayOfWeek(BuildContext context, DateTime dateTime) {
    final result = DateFormat.E("en").format(dateTime);
    for (int i = 0; i < days.length; i++) {
      if (result == days[i]) return i == 0 ? 7 : i;
    }
    return 1;
  }

  static T? listItem<T>(Iterable<T> list, int index) {
    if (index >= 0 && list.length > index) return list.toList()[index];
    return null;
  }

  static int? intFromDateTime({DateTime? dateTime}) {
    if (dateTime == null) return null;
    return dateTime.millisecondsSinceEpoch;
  }

  static bool? boolFromInt(int? value) {
    if (value == null) return false;
    return value == 1 ? true : false;
  }

  static int? intFromBool(bool? value) {
    if (value == null) return 0;
    return value ? 1 : 0;
  }

  static String prettifyJson(Map<dynamic, dynamic> json) {
    JsonEncoder encoder = const JsonEncoder.withIndent("  ");
    String prettyJson = encoder.convert(json);
    return prettyJson;
  }

  static FontWeight fontWeightGetter(FontWeight defaultWeight, FontWeight currentWeight) {
    int changeBy = defaultWeight == FontWeight.w400 ? 0 : 1;
    Map<int, FontWeight> fontWeights = {
      0: FontWeight.w100,
      1: FontWeight.w200,
      2: FontWeight.w300,
      3: FontWeight.w400,
      4: FontWeight.w500,
      5: FontWeight.w600,
      6: FontWeight.w700,
      7: FontWeight.w800,
      8: FontWeight.w900,
    };
    int index = currentWeight.index + changeBy;
    return fontWeights[max(min(8, index), 0)]!;
  }

  static Future<void> openLinkDialog(String url) async {
    BuildContext? context = App.navigatorKey.currentContext;
    if (context == null) return;

    Color? toolbarColor = Theme.of(context).appBarTheme.backgroundColor;
    Color? foregroundColor = Theme.of(context).appBarTheme.titleTextStyle?.color;

    try {
      launch(
        url,
        customTabsOption: CustomTabsOption(
          toolbarColor: toolbarColor,
          enableDefaultShare: true,
          enableUrlBarHiding: false,
          showPageTitle: true,
          enableInstantApps: true,
          extraCustomTabs: const <String>[
            'org.mozilla.firefox',
            'com.microsoft.emmx',
          ],
        ),
        safariVCOption: SafariViewControllerOption(
          preferredBarTintColor: toolbarColor,
          preferredControlTintColor: foregroundColor,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print("ERROR: openLinkDialog $e");
      }

      OkCancelResult result = await showOkAlertDialog(
        context: context,
        title: tr("alert.link.title"),
        message: url,
        okLabel: tr("button.open"),
      );

      if (result == OkCancelResult.ok) {
        await launchUrlString(
          url,
          mode: LaunchMode.externalNonBrowserApplication,
        );
      }
    }
  }

  static bool shouldDelete({
    DateTime? movedToBinAt,
    DateTime? currentDate,
    Duration? deletedIn,
  }) {
    if (movedToBinAt == null) return false;
    DateTime deleteAt = movedToBinAt.add(deletedIn ?? AppConstant.deleteInDuration);
    currentDate = currentDate ?? DateTime.now();
    return currentDate.isAfter(deleteAt);
  }

  static Future<List<String>> getDeviceModel() async {
    if (Global.instance.unitTesting) return ["Device Model", "device_id"];

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? device;
    String? id;

    if (Platform.isIOS) {
      IosDeviceInfo info = await deviceInfo.iosInfo;
      device = info.model ?? info.name;
      id = info.identifierForVendor;
    }

    if (Platform.isAndroid) {
      AndroidDeviceInfo info = await deviceInfo.androidInfo;
      device = info.model;
      id = info.id;
    }

    if (Platform.isMacOS) {
      MacOsDeviceInfo info = await deviceInfo.macOsInfo;
      device = info.model;
      id = info.systemGUID;
    }

    if (Platform.isWindows) {
      WindowsDeviceInfo info = await deviceInfo.windowsInfo;
      device = info.computerName;
      id = info.computerName;
    }

    if (Platform.isLinux) {
      LinuxDeviceInfo info = await deviceInfo.linuxInfo;
      device = info.name;
      id = info.machineId;
    }

    return [device ?? tr("msg.unknown"), id ?? "unknown_id"];
  }

  static String? queryParameters({
    required String url,
    required String param,
  }) {
    return Uri.parse(url).queryParameters[param];
  }
}
