import 'package:flutter/material.dart';
import 'package:spooky/core/storages/base_storages/enum_storage.dart';

class ThemeModeStorage extends EnumPreferenceStorage<ThemeMode> {
  @override
  List<ThemeMode> get values => ThemeMode.values;
}
