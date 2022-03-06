import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';

class SpDatePicker {
  static Future<DateTime?> showPicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? minDateTime,
    DateTime? maxDateTime,
    String dateFormat = 'yyyy-MM-dd',
  }) {
    ColorScheme color = M3Color.of(context);
    Completer<DateTime?> completer = Completer();
    DatePicker.showDatePicker(
      context,
      dateFormat: dateFormat,
      initialDateTime: initialDate,
      minDateTime: minDateTime,
      maxDateTime: maxDateTime,
      pickerTheme: DateTimePickerTheme(
        backgroundColor: color.primary,
        itemTextStyle:
            TextStyle(fontFamily: M3TextTheme.of(context).bodyText1?.fontFamily).copyWith(color: color.onPrimary),
        cancelTextStyle: TextStyle(color: color.onPrimary),
        confirmTextStyle: TextStyle(color: color.onPrimary),
        buttonStyle: TextButton.styleFrom(
          splashFactory: null,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
      onCancel: () => completer.complete(null),
      onConfirm: (DateTime date, _) => completer.complete(date),
    );

    return completer.future;
  }

  static Future<DateTime?> showYearPicker(BuildContext context) {
    return showPicker(
      context: context,
      dateFormat: 'yyyy',
    );
  }

  static Future<DateTime?> showSecondsPicker(
    BuildContext context,
    int initialSeconds,
  ) {
    DateTime now = DateTime.now();
    return showPicker(
      context: context,
      dateFormat: 'ss',
      initialDate: DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
        now.minute,
        initialSeconds,
      ),
    );
  }

  static Future<DateTime?> showDatePicker(
    BuildContext context,
    DateTime initialDate,
  ) {
    return showPicker(
      context: context,
      dateFormat: 'yyyy-MM-dd',
      initialDate: initialDate,
    );
  }

  static Future<DateTime?> showMMddPicker(
    BuildContext context,
    DateTime initialDate,
  ) {
    return showPicker(
      context: context,
      initialDate: initialDate,
      minDateTime: DateTime(initialDate.year, DateTime.january, 1),
      maxDateTime: DateTime(initialDate.year, DateTime.december, 31),
      dateFormat: 'yyyy-MM-dd',
    );
  }

  static Future<DateTime?> showDayPicker(
    BuildContext context,
    DateTime initialDate,
  ) {
    DateTime utc = DateTime(initialDate.year, initialDate.month, 0).toUtc();
    int days = DateTime(initialDate.year, initialDate.month + 1, 0).toUtc().difference(utc).inDays;
    return showPicker(
      context: context,
      initialDate: initialDate,
      minDateTime: DateTime(initialDate.year, initialDate.month, 1),
      maxDateTime: DateTime(initialDate.year, initialDate.month, days),
      dateFormat: 'yyyy-MMMM-dd',
    );
  }

  static Future<DateTime?> showMonthDayPicker(
    BuildContext context,
    DateTime initialDate,
  ) {
    DateTime utc = DateTime(initialDate.year, initialDate.month, 0).toUtc();
    int days = DateTime(initialDate.year, initialDate.month + 1, 0).toUtc().difference(utc).inDays;
    return showPicker(
      context: context,
      initialDate: initialDate,
      minDateTime: DateTime(initialDate.year, 1, 1),
      maxDateTime: DateTime(initialDate.year, 12, days),
      dateFormat: 'yyyy-MMMM-dd',
    );
  }
}
