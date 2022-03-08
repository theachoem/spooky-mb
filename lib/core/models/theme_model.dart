import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/gen/fonts.gen.dart';
import 'package:spooky/theme/theme_constant.dart';

part 'theme_model.g.dart';

@JsonSerializable()
class ThemeModel {
  final String? fontFamily;
  final int? fontWeightIndex;
  final ThemeMode? themeMode;
  final int? colorSeedValue;

  Color get colorSeed => colorSeedValue != null ? Color(colorSeedValue!) : ThemeConstant.fallbackColor;
  FontWeight get fontWeight =>
      fontWeightIndex != null ? FontWeight.values[fontWeightIndex!] : ThemeConstant.defaultFontWeight;

  ThemeModel({
    this.fontFamily,
    this.fontWeightIndex,
    this.themeMode,
    this.colorSeedValue,
  });

  factory ThemeModel.start() {
    return ThemeModel(
      fontFamily: FontFamily.quicksand,
      fontWeightIndex: FontWeight.w400.index,
      themeMode: null,
      colorSeedValue: null,
    );
  }

  ThemeModel copyWith({
    String? fontFamily,
    FontWeight? fontWeight,
    ThemeMode? themeMode,
    Color? colorSeed,
  }) {
    return ThemeModel(
      fontFamily: fontFamily ?? this.fontFamily,
      fontWeightIndex: fontWeight?.index ?? fontWeightIndex,
      themeMode: themeMode ?? this.themeMode,
      colorSeedValue: colorSeed?.value ?? colorSeedValue,
    );
  }

  Map<String, dynamic> toJson() => _$ThemeModelToJson(this);
  factory ThemeModel.fromJson(Map<String, dynamic> json) => _$ThemeModelFromJson(json);
}
