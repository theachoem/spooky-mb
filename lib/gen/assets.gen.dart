/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import

import 'package:flutter/widgets.dart';

class $GoogleFontsGen {
  const $GoogleFontsGen();

  /// File path: google_fonts/OFL.txt
  String get ofl => 'google_fonts/OFL.txt';

  /// File path: google_fonts/Quicksand-Bold.ttf
  String get quicksandBold => 'google_fonts/Quicksand-Bold.ttf';

  /// File path: google_fonts/Quicksand-Light.ttf
  String get quicksandLight => 'google_fonts/Quicksand-Light.ttf';

  /// File path: google_fonts/Quicksand-Medium.ttf
  String get quicksandMedium => 'google_fonts/Quicksand-Medium.ttf';

  /// File path: google_fonts/Quicksand-Regular.ttf
  String get quicksandRegular => 'google_fonts/Quicksand-Regular.ttf';

  /// File path: google_fonts/Quicksand-SemiBold.ttf
  String get quicksandSemiBold => 'google_fonts/Quicksand-SemiBold.ttf';
}

class $TranslationsGen {
  const $TranslationsGen();

  /// File path: translations/en.json
  String get en => 'translations/en.json';

  /// File path: translations/km.json
  String get km => 'translations/km.json';
}

class $AssetsIllustrationsGen {
  const $AssetsIllustrationsGen();

  /// File path: assets/illustrations/two_people.png
  AssetGenImage get twoPeople =>
      const AssetGenImage('assets/illustrations/two_people.png');
}

class $AssetsSoundsGen {
  const $AssetsSoundsGen();

  /// File path: assets/sounds/sounds.json
  String get sounds => 'assets/sounds/sounds.json';
}

class Assets {
  Assets._();

  static const $AssetsIllustrationsGen illustrations =
      $AssetsIllustrationsGen();
  static const $AssetsSoundsGen sounds = $AssetsSoundsGen();
  static const $GoogleFontsGen googleFonts = $GoogleFontsGen();
  static const $TranslationsGen translations = $TranslationsGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
