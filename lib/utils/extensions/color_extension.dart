import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_opacity.dart';

extension ColorExtension on Color {
  M3Opacity get m3Opacity {
    return M3Opacity(this);
  }
}
