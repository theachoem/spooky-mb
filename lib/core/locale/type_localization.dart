import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:spooky/core/types/sound_type.dart';

class TypeLocalization {
  static String pathType(PathType type) {
    switch (type) {
      case PathType.docs:
        return tr("path_type.docs");
      case PathType.bins:
        return tr("path_type.bins");
      case PathType.archives:
        return tr("path_type.archives");
    }
  }

  static String soundType(SoundType type) {
    switch (type) {
      case SoundType.sound:
        return tr("sound_type.sound");
      case SoundType.music:
        return tr("sound_type.music");
    }
  }

  static String themeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return tr("theme_mode.system");
      case ThemeMode.light:
        return tr("theme_mode.light");
      case ThemeMode.dark:
        return tr("theme_mode.dark");
    }
  }
}
