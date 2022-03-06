import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/theme_config.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/widgets/sp_cross_fade.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';

class PreviewTrailing extends StatelessWidget {
  const PreviewTrailing({
    Key? key,
    required this.fontFamily,
    required this.context,
  }) : super(key: key);

  final String fontFamily;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      children: [
        SpCrossFade(
          duration: ConfigConstant.duration,
          showFirst: fontFamily == ThemeConfig.fontFamily,
          firstChild: Icon(Icons.check, color: M3Color.of(context).primary),
          secondChild: const SizedBox.square(dimension: ConfigConstant.iconSize2),
        ),
        SpPopupMenuButton(
          items: (BuildContext context) {
            return [
              SpPopMenuItem(
                title: "Sample",
                subtitle:
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                subtitleStyle: GoogleFonts.getFont(fontFamily),
              ),
            ];
          },
          builder: (callback) {
            return SpIconButton(
              icon: const Icon(Icons.preview),
              onPressed: () => callback(),
            );
          },
        ),
      ],
    );
  }
}
