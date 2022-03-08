import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/views/font_manager/font_manager_view_model.dart';
import 'package:spooky/views/font_manager/local_widgets/font_tile.dart';
import 'package:spooky/widgets/sp_sections_tiles.dart';

class FontList extends StatelessWidget {
  const FontList({
    Key? key,
    required this.fonts,
  }) : super(key: key);

  final List<FontBean> fonts;

  @override
  Widget build(BuildContext context) {
    return AzListView(
      data: fonts,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + kToolbarHeight),
      itemCount: fonts.length,
      itemBuilder: (context, index) {
        return buildFontTile(context, index);
      },
      indexBarMargin: const EdgeInsets.symmetric(horizontal: 8.0),
      indexHintBuilder: (context, hint) {
        return buildHint(context, hint);
      },
      indexBarData: fonts.map((e) => e.getSuspensionTag()).toSet().toList(),
    );
  }

  Widget buildFontTile(BuildContext context, int index) {
    final FontBean data = fonts[index];
    return Column(
      children: [
        Offstage(
          offstage: !data.isShowSuspension,
          child: buildSusWidget(
            context,
            index != 0,
            data.display(),
          ),
        ),
        FontTile(
          fontFamily: data.family,
          onFontUpdated: () {},
        ),
      ],
    );
  }

  Widget buildSusWidget(BuildContext context, bool showDivider, FontBeanDisplay display) {
    return Column(
      children: [
        if (showDivider) const Divider(height: 1),
        Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.centerLeft,
          child: SpSectionsTiles.header(
            context: context,
            headline: display.headline,
            leadingIcon: display.iconData,
          ),
        ),
      ],
    );
  }

  Widget buildHint(BuildContext context, String hint) {
    return Container(
      alignment: Alignment.center,
      width: kToolbarHeight,
      height: kToolbarHeight,
      decoration: BoxDecoration(
        color: M3Color.of(context).tertiary,
        shape: BoxShape.circle,
      ),
      child: Text(
        hint,
        style: M3TextTheme.of(context).headlineMedium?.copyWith(color: M3Color.of(context).onTertiary),
      ),
    );
  }
}
