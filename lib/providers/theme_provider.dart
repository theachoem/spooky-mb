import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  Future<void> setThemeMode(ThemeMode? value) async {
    if (value != null && value != themeMode) {
      _themeMode = value;
      notifyListeners();
    }
  }

  bool toggleThemeMode(BuildContext context) {
    if (themeMode == ThemeMode.system) {
      Brightness? brightness = View.of(context).platformDispatcher.platformBrightness;
      bool isDarkMode = brightness == Brightness.dark;
      setThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
      return !isDarkMode;
    } else {
      bool isDarkMode = themeMode == ThemeMode.dark;
      setThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
      return !isDarkMode;
    }
  }

  bool isDarkMode(BuildContext context) {
    if (themeMode == ThemeMode.system) {
      Brightness? brightness = View.of(context).platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }
}
