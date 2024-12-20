import 'package:flutter/material.dart';
import 'package:spooky/core/constants/utils_colors.dart';

class ColorFromDayService {
  final BuildContext context;

  ColorFromDayService({
    required this.context,
  });

  Color? get(int day) {
    bool darkMode = Theme.of(context).brightness == Brightness.dark;
    return darkMode ? colorsByDayDark[day] : colorsByDayLight[day];
  }
}
