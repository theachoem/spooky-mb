import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

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
    JsonEncoder encoder = JsonEncoder.withIndent("  ");
    String prettyJson = encoder.convert(json);
    return prettyJson;
  }
}
