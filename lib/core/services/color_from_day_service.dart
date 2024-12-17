import 'package:flutter/material.dart';

const Map<int, Color> _colorsByDayLight = {
  DateTime.monday: Color(0xFFE38A41),
  DateTime.tuesday: Color(0xFF9341B1),
  DateTime.wednesday: Color(0xFFA3AA49),
  DateTime.thursday: Color(0xFF397C2D),
  DateTime.friday: Color(0xFF5080D7),
  DateTime.saturday: Color(0xFF6E183B),
  DateTime.sunday: Color(0xFFE5333A),
};

const Map<int, Color> _colorsByDayDark = {
  DateTime.monday: Color(0xFFFFB780),
  DateTime.tuesday: Color(0xFFF0AFFF),
  DateTime.wednesday: Color(0xFFC5CE5B),
  DateTime.thursday: Color(0xFF90D87D),
  DateTime.friday: Color(0xFFACC7FF),
  DateTime.saturday: Color(0xFFFFB0C8),
  DateTime.sunday: Color(0xFFFFB3AC),
};

class ColorFromDayService {
  final BuildContext context;

  ColorFromDayService({
    required this.context,
  });

  Color? get(int day) {
    bool darkMode = Theme.of(context).brightness == Brightness.dark;
    return darkMode ? _colorsByDayDark[day] : _colorsByDayLight[day];
  }
}
