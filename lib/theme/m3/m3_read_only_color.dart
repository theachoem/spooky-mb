import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_color.dart';

class M3ReadOnlyColor {
  final M3Color _color;
  M3ReadOnlyColor(this._color);

  Color? get surface1 {
    return Color.alphaBlend(
      _color.primary.withOpacity(0.05),
      _color.background,
    );
  }

  Color? get surface2 {
    return Color.alphaBlend(
      _color.primary.withOpacity(0.08),
      _color.background,
    );
  }

  Color? get surface3 {
    return Color.alphaBlend(
      _color.primary.withOpacity(0.11),
      _color.background,
    );
  }

  Color? get surface4 {
    return Color.alphaBlend(
      _color.primary.withOpacity(0.12),
      _color.background,
    );
  }

  Color? get surface5 {
    return Color.alphaBlend(
      _color.primary.withOpacity(0.14),
      _color.background,
    );
  }

  Color? get black => Color(0xFF000000);
  Color? get white => Color(0xFFFFFFFF);
}
