import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spooky/providers/theme_provider.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/widgets/sp_cross_fade.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';

class FontTile extends StatelessWidget {
  const FontTile({
    Key? key,
    required this.fontFamily,
    required this.onFontUpdated,
  }) : super(key: key);

  final String fontFamily;
  final void Function() onFontUpdated;

  @override
  Widget build(BuildContext context) {
    ThemeProvider notifier = Provider.of<ThemeProvider>(context, listen: false);
    return SpPopupMenuButton(
      dxGetter: (_) => MediaQuery.of(context).size.width,
      items: (BuildContext context) {
        return [
          SpPopMenuItem(
            title: "Use this font",
            subtitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
            subtitleStyle: GoogleFonts.getFont(fontFamily),
            trailingIconData: Icons.keyboard_arrow_right,
            onPressed: () {
              context.read<ThemeProvider>().updateFont(fontFamily);
            },
          ),
        ];
      },
      builder: (callback) {
        return ListTile(
          onTap: callback,
          title: Text(fontFamily),
          trailing: Wrap(
            children: [
              SpCrossFade(
                duration: ConfigConstant.duration,
                showFirst: fontFamily == notifier.fontFamily,
                firstChild: Icon(Icons.check, color: M3Color.of(context).primary),
                secondChild: const SizedBox.square(dimension: ConfigConstant.iconSize2),
              ),
              const SizedBox(width: ConfigConstant.margin1),
              Icon(Icons.more_vert),
            ],
          ),
        );
      },
    );
  }
}
