import 'dart:math';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:spooky/app.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
    final context = App.navigatorKey.currentContext;
    if (context == null) return;

    final result = await showOkAlertDialog(
      context: context,
      title: "Link",
      message: url,
      okLabel: "Open",
    );

    if (result == OkCancelResult.ok) {
      await launchUrlString(
        url,
        mode: LaunchMode.externalNonBrowserApplication,
      );
    }
  }
}
