import 'package:flutter/material.dart';
import 'package:spooky/core/base_storages/enum_preference_storage.dart';

class ThemeModeStorage extends EnumPreferenceStorage<ThemeMode> {
  @override
  List<ThemeMode> get values => ThemeMode.values;
}
