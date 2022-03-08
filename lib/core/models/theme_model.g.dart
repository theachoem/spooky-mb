// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThemeModel _$ThemeModelFromJson(Map<String, dynamic> json) => ThemeModel(
      fontFamily: json['font_family'] as String?,
      fontWeightIndex: json['font_weight_index'] as int?,
      themeMode: $enumDecodeNullable(_$ThemeModeEnumMap, json['theme_mode']),
      colorSeedValue: json['color_seed_value'] as int?,
    );

Map<String, dynamic> _$ThemeModelToJson(ThemeModel instance) =>
    <String, dynamic>{
      'font_family': instance.fontFamily,
      'font_weight_index': instance.fontWeightIndex,
      'theme_mode': _$ThemeModeEnumMap[instance.themeMode],
      'color_seed_value': instance.colorSeedValue,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
