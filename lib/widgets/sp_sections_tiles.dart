import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/widgets/sp_icon_button.dart';

class SpSectionContents {
  final String? headline;
  final List<Widget> tiles;
  final IconData? leadingIcon;
  final Color? headlineColor;
  final SpIconButton? actionButton;

  SpSectionContents({
    required this.headline,
    required this.tiles,
    this.leadingIcon,
    this.headlineColor,
    this.actionButton,
  });
}

class SpSectionsTiles extends StatelessWidget {
  const SpSectionsTiles({Key? key}) : super(key: key);

  static Widget buildHeader({
    required BuildContext context,
    required SpSectionContents section,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(
        bottom: section.actionButton != null ? 0 : 4.0,
        top: section.actionButton != null ? 10.0 : 24,
      ),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                style: M3TextTheme.of(context)
                    .titleSmall
                    ?.copyWith(color: section.headlineColor ?? M3Color.of(context).primary),
                children: [
                  TextSpan(text: section.headline),
                  if (section.leadingIcon != null)
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Icon(
                          section.leadingIcon,
                          color: M3Color.of(context).primary,
                          size: ConfigConstant.iconSize1 - 4.0,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (section.actionButton != null) section.actionButton!
        ],
      ),
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
        if (sections[i].headline != null) buildHeader(context: context, section: sections[i]),
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
