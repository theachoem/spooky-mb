import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class SpSectionContents {
  final String headline;
  final List<Widget> tiles;

  SpSectionContents({
    required this.headline,
    required this.tiles,
  });
}

class SpSectionsTiles extends StatelessWidget {
  const SpSectionsTiles({Key? key}) : super(key: key);

  static List<Widget> divide({
    required BuildContext context,
    required List<SpSectionContents> sections,
  }) {
    return [
      for (int i = 0; i < sections.length; i++) ...[
        ConfigConstant.sizedBoxH1,
        ConfigConstant.sizedBoxH2,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            sections[i].headline,
            style: M3TextTheme.of(context).titleSmall,
          ),
        ),
        ConfigConstant.sizedBoxH0,
        ...sections[i].tiles,
        if (i != sections.length - 1) Divider(height: 0),
      ]
    ];
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
