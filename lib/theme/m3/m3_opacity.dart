import 'package:flutter/material.dart';

/// Used in extension [ColorExtension]
class M3Opacity {
  final Color _baseColor;
  M3Opacity(this._baseColor);

  Color get opacity008 => _baseColor.withOpacity(0.08);
  Color get opacity012 => _baseColor.withOpacity(0.12);
  Color get opacity016 => _baseColor.withOpacity(0.16);
}
