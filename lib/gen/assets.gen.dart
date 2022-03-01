/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

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

class $AssetsTranslationsGen {
  const $AssetsTranslationsGen();

  /// File path: assets/translations/en.json
  String get en => 'assets/translations/en.json';

  /// File path: assets/translations/km.json
  String get km => 'assets/translations/km.json';
}

class Assets {
  Assets._();

  static const $AssetsTranslationsGen translations = $AssetsTranslationsGen();
  static const $GoogleFontsGen googleFonts = $GoogleFontsGen();
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
