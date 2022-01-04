import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DateFormatHelper {
  static DateFormat toNameOfMonth(BuildContext context, {bool fullName = false}) {
    final DateFormat format =
        fullName ? DateFormat.MMMM(context.locale.languageCode) : DateFormat.MMM(context.locale.languageCode);
    return format;
  }

  static DateFormat toFullNameOfMonth(BuildContext context) {
    final DateFormat format = DateFormat.MMMM(context.locale.languageCode);
    return format;
  }

  static DateFormat toYear(BuildContext context) {
    final DateFormat format = DateFormat.y(context.locale.languageCode);
    return format;
  }

  static DateFormat toDay(BuildContext context) {
    final DateFormat format = DateFormat.E(context.locale.languageCode);
    return format;
  }

  static DateFormat toIntDay(BuildContext context) {
    final DateFormat format = DateFormat.d(context.locale.languageCode);
    return format;
  }

  static DateFormat dateFormat(BuildContext context) {
    return DateFormat.yMd(context.locale.languageCode);
  }

  static DateFormat yM(BuildContext context) {
    return DateFormat.yMMMM(context.locale.languageCode);
  }

  static DateFormat timeFormat(BuildContext context) {
    return DateFormat.jm(context.locale.languageCode);
  }
}
