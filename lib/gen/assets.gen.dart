/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// ignore_for_file: directives_ordering,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsFontsGen {
  const $AssetsFontsGen();

  $AssetsFontsQuicksandGen get quicksand => const $AssetsFontsQuicksandGen();
}

class $AssetsSoundsGen {
  const $AssetsSoundsGen();

  /// File path: assets/sounds/page-flip-01a.mp3
  String get pageFlip01a => 'assets/sounds/page-flip-01a.mp3';

  /// File path: assets/sounds/page-flip-02.mp3
  String get pageFlip02 => 'assets/sounds/page-flip-02.mp3';

  /// File path: assets/sounds/page-flip-03.mp3
  String get pageFlip03 => 'assets/sounds/page-flip-03.mp3';

  /// File path: assets/sounds/page-flip-10.mp3
  String get pageFlip10 => 'assets/sounds/page-flip-10.mp3';

  /// File path: assets/sounds/page-flip-4.mp3
  String get pageFlip4 => 'assets/sounds/page-flip-4.mp3';

  /// File path: assets/sounds/page-flip-5.mp3
  String get pageFlip5 => 'assets/sounds/page-flip-5.mp3';

  /// File path: assets/sounds/page-flip-6.mp3
  String get pageFlip6 => 'assets/sounds/page-flip-6.mp3';

  /// File path: assets/sounds/page-flip-7.mp3
  String get pageFlip7 => 'assets/sounds/page-flip-7.mp3';

  /// File path: assets/sounds/page-flip-8.mp3
  String get pageFlip8 => 'assets/sounds/page-flip-8.mp3';

  /// File path: assets/sounds/page-flip-9.mp3
  String get pageFlip9 => 'assets/sounds/page-flip-9.mp3';
}

class $AssetsTranslationsGen {
  const $AssetsTranslationsGen();

  /// File path: assets/translations/en.json
  String get en => 'assets/translations/en.json';

  /// File path: assets/translations/km.json
  String get km => 'assets/translations/km.json';
}

class $AssetsFontsQuicksandGen {
  const $AssetsFontsQuicksandGen();

  /// File path: assets/fonts/Quicksand/OFL.txt
  String get ofl => 'assets/fonts/Quicksand/OFL.txt';
}

class Assets {
  Assets._();

  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsSoundsGen sounds = $AssetsSoundsGen();
  static const $AssetsTranslationsGen translations = $AssetsTranslationsGen();
}

class AssetGenImage extends AssetImage {
  const AssetGenImage(String assetName) : super(assetName);

  Image image({
    Key? key,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return Image(
      key: key,
      image: this,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
    );
  }

  String get path => assetName;
}
