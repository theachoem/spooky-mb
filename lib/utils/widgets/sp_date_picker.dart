import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';

class SpDatePicker {
  static void showPicker({
    required BuildContext context,
    required void Function(DateTime date) onConfirm,
    DateTime? initialDate,
    DateTime? minDateTime,
    DateTime? maxDateTime,
    String dateFormat = 'yyyy-MM-dd',
  }) {
    M3Color color = M3Color.of(context);
    return DatePicker.showDatePicker(
      context,
      dateFormat: dateFormat,
      initialDateTime: initialDate,
      minDateTime: minDateTime,
      maxDateTime: maxDateTime,
      pickerTheme: DateTimePickerTheme(
        backgroundColor: color.primary,
        itemTextStyle: TextStyle(
          fontFamilyFallback: M3TextTheme.of(context).fontFamilyFallback,
        ).copyWith(color: color.onPrimary),
        cancelTextStyle: TextStyle().copyWith(color: color.onPrimary),
        confirmTextStyle: TextStyle().copyWith(color: color.onPrimary),
      ),
      onConfirm: (DateTime date, List<int> _) {
        onConfirm(date);
      },
    );
  }

  static void showYearPicker(BuildContext context, void Function(DateTime) onConfirm) {
    return showPicker(
      context: context,
      onConfirm: onConfirm,
      dateFormat: 'yyyy',
    );
  }

  static void showDatePicker(BuildContext context, DateTime initialDate, void Function(DateTime) onConfirm) {
    return showPicker(
      context: context,
      onConfirm: onConfirm,
      dateFormat: 'yyyy-MM-dd',
    );
  }

  static void showMMddPicker(BuildContext context, DateTime initialDate, void Function(DateTime) onConfirm) {
    return showPicker(
      context: context,
      initialDate: initialDate,
      onConfirm: onConfirm,
      minDateTime: DateTime(initialDate.year, DateTime.january, 1),
      maxDateTime: DateTime(initialDate.year, DateTime.december, 31),
      dateFormat: 'yyyy-MM-dd',
    );
  }

  static void showDayPicker(BuildContext context, DateTime initialDate, void Function(DateTime) onConfirm) {
    DateTime utc = DateTime(initialDate.year, initialDate.month, 0).toUtc();
    int days = DateTime(initialDate.year, initialDate.month + 1, 0).toUtc().difference(utc).inDays;
    return showPicker(
      context: context,
      initialDate: initialDate,
      onConfirm: onConfirm,
      minDateTime: DateTime(initialDate.year, initialDate.month, 1),
      maxDateTime: DateTime(initialDate.year, initialDate.month, days),
      dateFormat: 'yyyy-MM-dd',
    );
  }
}
