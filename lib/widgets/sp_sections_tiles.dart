import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class SpSectionContents {
  final String? headline;
  final List<Widget> tiles;

  SpSectionContents({
    required this.headline,
    required this.tiles,
  });
}

class SpSectionsTiles extends StatelessWidget {
  const SpSectionsTiles({Key? key}) : super(key: key);

  static Column header({
    required BuildContext context,
    required String headline,
    IconData? leadingIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConfigConstant.sizedBoxH1,
        ConfigConstant.sizedBoxH2,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              style: M3TextTheme.of(context).titleSmall?.copyWith(color: M3Color.of(context).primary),
              children: [
                TextSpan(text: headline),
                if (leadingIcon != null)
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Icon(
                        leadingIcon,
                        color: M3Color.of(context).primary,
                        size: ConfigConstant.iconSize1 - 4.0,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        ConfigConstant.sizedBoxH0,
      ],
    );
  }

  static List<Widget> divide({
    required BuildContext context,
    required List<SpSectionContents> sections,
    bool showTopDivider = false,
  }) {
    return [
      if (showTopDivider) const Divider(height: 1),
      for (int i = 0; i < sections.length; i++) ...[
        if (sections[i].headline != null) ...header(context: context, headline: sections[i].headline!).children,
        ...sections[i].tiles,
        if (i != sections.length - 1) const Divider(height: 1),
      ]
    ];
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
