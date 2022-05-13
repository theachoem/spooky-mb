import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/views/font_manager/font_manager_view_model.dart';
import 'package:spooky/views/font_manager/local_widgets/font_tile.dart';

class FontList extends StatelessWidget {
  const FontList({
    Key? key,
    required this.fonts,
  }) : super(key: key);

  final List<FontBean> fonts;
  List<String> get indexBarData => fonts.map((e) => e.getSuspensionTag()).toSet().toList();

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: AzListView(
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
        susItemBuilder: (context, index) {
          return buildSusWidget(context, index);
        },
        indexBarData: indexBarData,
      ),
    );
  }

  Widget buildFontTile(BuildContext context, int index) {
    final FontBean data = fonts[index];
    return Column(
      children: [
        if (data.isShowSuspension && index != 0) buildSectionBreak(),
        Stack(
          children: [
            if (data.isShowSuspension && data.display().headline != null)
              buildHeaderText(context, data.display().headline!),
            FontTile(
              fontFamily: data.family,
              onFontUpdated: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSectionBreak() {
    return Container(
      transform: Matrix4.identity()..translate(0.0, -56),
      child: const Divider(height: 1),
    );
  }

  Widget buildHeaderText(BuildContext context, String headline) {
    return Container(
      transform: Matrix4.identity()..translate(0.0, -49.0),
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: Colors.transparent),
        title: Text(
          headline,
          style: TextStyle(color: M3Color.of(context).primary),
        ),
      ),
    );
  }

  Widget buildSusWidget(BuildContext context, int index) {
    final FontBean bean = fonts[index];

    // indexed by alphabet
    int alphabetIndex = indexBarData.indexOf(bean.tag);
    int dayIndex = (alphabetIndex % 6) + 1;
    Color? backgroundColor = M3Color.dayColorsOf(context)[dayIndex];

    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.only(top: 16.0),
      color: M3Color.of(context).background,
      child: CircleAvatar(
        backgroundColor: backgroundColor,
        child: bean.display().iconData != null
            ? Icon(bean.display().iconData, color: M3Color.of(context).onPrimary)
            : Text(bean.tag, style: TextStyle(color: M3Color.of(context).onPrimary)),
      ),
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
