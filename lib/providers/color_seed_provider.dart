import 'package:flutter/material.dart';
import 'package:spooky/core/storages/local_storages/color_storage.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/theme_config.dart';

class ColorSeedProvider extends ChangeNotifier {
  Color currentSeedColor = M3Color.currentPrimaryColor;
  ThemeData get lightTheme => ThemeConfig.light().themeData;
  ThemeData get darkTheme => ThemeConfig.dark().themeData;

  Future<void> updateColor(Color? color) async {
    await ColorStorage().write(color?.value);
    await M3Color.initialize();
    if (color != null) currentSeedColor = color;
    notifyListeners();
  }

  Future<void> updateFont(String fontFamily) async {
    ThemeConfig.fontFamily = fontFamily;
    notifyListeners();
  }
}
