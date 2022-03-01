import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:spooky/core/storages/local_storages/theme_mode_storage.dart';

class ThemeModeProvider extends ChangeNotifier {
  ThemeMode mode = ThemeMode.system;
  ThemeModeStorage storage = ThemeModeStorage();

  ThemeModeProvider() {
    storage.readEnum().then(setThemeMode);
  }

  void setThemeMode(ThemeMode? value) {
    if (value != null && value != mode) {
      mode = value;
      storage.writeEnum(mode);
      notifyListeners();
    }
  }

  bool toggleThemeMode() {
    if (mode == ThemeMode.system) {
      Brightness? brightness = SchedulerBinding.instance?.window.platformBrightness;
      bool isDarkMode = brightness == Brightness.dark;
      setThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
      return !isDarkMode;
    } else {
      bool isDarkMode = mode == ThemeMode.dark;
      setThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
      return !isDarkMode;
    }
  }
}
