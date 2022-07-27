import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_color.dart';

enum Flavor { dev, qa, production }

class FlavorConfig {
  final Flavor flavor;

  static FlavorConfig? _instance;
  static FlavorConfig get instance => _instance ?? FlavorConfig(flavor: Flavor.production);

  FlavorConfig._(this.flavor);
  factory FlavorConfig({
    required Flavor flavor,
  }) {
    _instance ??= FlavorConfig._(flavor);
    return _instance!;
  }

  Color? color(BuildContext context) {
    return M3Color.dayColorsOf(context)[Flavor.values.indexOf(flavor) + 1];
  }

  static bool isProduction() => instance.flavor == Flavor.production;
  static bool isDevelopment() => instance.flavor == Flavor.dev;
  static bool isQA() => instance.flavor == Flavor.qa;
}
