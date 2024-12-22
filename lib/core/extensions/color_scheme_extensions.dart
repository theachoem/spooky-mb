import 'package:flutter/material.dart';

extension ColorSchemeExtension on ColorScheme {
  // ignore: library_private_types_in_public_api
  _M3ReadOnlyColor get readOnly => _M3ReadOnlyColor(this);
}

/// Used in extension [ColorSchemeExtension]
class _M3ReadOnlyColor {
  final ColorScheme _color;
  _M3ReadOnlyColor(this._color);

  Color? get surface1 {
    return Color.alphaBlend(
      _color.primary.withValues(alpha: 0.05),
      _color.surface,
    );
  }

  Color? get surface2 {
    return Color.alphaBlend(
      _color.primary.withValues(alpha: 0.08),
      _color.surface,
    );
  }

  Color? get surface3 {
    return Color.alphaBlend(
      _color.primary.withValues(alpha: 0.11),
      _color.surface,
    );
  }

  Color? get surface4 {
    return Color.alphaBlend(
      _color.primary.withValues(alpha: 0.12),
      _color.surface,
    );
  }

  Color? get surface5 {
    return Color.alphaBlend(
      _color.primary.withValues(alpha: 0.14),
      _color.surface,
    );
  }

  Color? get black => const Color(0xFF000000);
  Color? get white => const Color(0xFFFFFFFF);
}
