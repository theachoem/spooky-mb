import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/ui/widgets/sp_tap_effect.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class SpBottomNavigationBarItem {
  final String label;
  final IconData iconData;
  final IconData activeIconData;

  SpBottomNavigationBarItem({
    required this.label,
    required this.iconData,
    required this.activeIconData,
  });
}

class SpBottomNavigationBar extends StatefulWidget {
  const SpBottomNavigationBar({
    Key? key,
    required this.items,
    this.currentIndex = 0,
    this.onTap,
  }) : super(key: key);

  final List<SpBottomNavigationBarItem> items;
  final ValueChanged<int>? onTap;
  final int currentIndex;

  @override
  State<SpBottomNavigationBar> createState() => _SpBottomNavigationBarState();
}

class _SpBottomNavigationBarState extends State<SpBottomNavigationBar> {
  late ValueNotifier<int> notifier;

  @override
  void initState() {
    notifier = ValueNotifier(widget.currentIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double bottomHeight = MediaQuery.of(context).padding.bottom;

    // bottom navigation bar height
    double height = kToolbarHeight;
    height += bottomHeight;
    height += 26;

    ColorScheme? colorScheme = M3Color.of(context);

    return Material(
      color: colorScheme.readOnly.surface2,
      child: LayoutBuilder(builder: (context, constraints) {
        return Row(
          children: List.generate(widget.items.length, (index) {
            final SpBottomNavigationBarItem item = widget.items[index];
            return buildItem(
              height,
              bottomHeight,
              constraints,
              index,
              colorScheme,
              item,
              context,
            );
          }),
        );
      }),
    );
  }

  Widget buildItem(
    double height,
    double bottomHeight,
    BoxConstraints constraints,
    int index,
    ColorScheme? colorScheme,
    SpBottomNavigationBarItem item,
    BuildContext context,
  ) {
    return Container(
      height: height,
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: bottomHeight),
      child: SpTapEffect(
        onTap: () {
          notifier.value = index;
          if (widget.onTap != null) widget.onTap!(index);
        },
        child: SizedBox(
          width: constraints.maxWidth / widget.items.length,
          child: ValueListenableBuilder<int>(
            valueListenable: notifier,
            builder: (context, value, child) {
              return buildContent(
                index,
                colorScheme,
                item,
                context,
                constraints,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildContent(
    int index,
    ColorScheme? colorScheme,
    SpBottomNavigationBarItem item,
    BuildContext context,
    BoxConstraints constraints,
  ) {
    final bool selected = index == notifier.value;
    double itemWidth = constraints.maxWidth / widget.items.length;
    double transformX = notifier.value * itemWidth;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 12),
        Stack(
          children: [
            if (index == 0) buildIndicator(transformX, colorScheme),
            buildIcon(selected, item, colorScheme),
          ],
        ),
        ConfigConstant.sizedBoxH0,
        Text(
          item.label,
          style: M3TextTheme.of(context).labelMedium?.copyWith(color: colorScheme?.onSecondaryContainer),
        ),
        const SizedBox(height: ConfigConstant.margin2),
      ],
    );
  }

  Widget buildIcon(bool selected, SpBottomNavigationBarItem item, ColorScheme? colorScheme) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(
        horizontal: ConfigConstant.margin2 + ConfigConstant.margin0,
        vertical: ConfigConstant.margin0,
      ),
      alignment: Alignment.center,
      child: AnimatedCrossFade(
        crossFadeState: selected ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: ConfigConstant.fadeDuration,
        sizeCurve: Curves.linear,
        firstChild: Icon(
          item.activeIconData,
          size: ConfigConstant.iconSize2,
          color: colorScheme?.onSecondaryContainer,
        ),
        secondChild: Icon(
          item.iconData,
          size: ConfigConstant.iconSize2,
          color: colorScheme?.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget buildIndicator(double transformX, ColorScheme? colorScheme) {
    return Center(
      child: AnimatedContainer(
        height: 32,
        width: 62,
        curve: Curves.fastLinearToSlowEaseIn,
        duration: ConfigConstant.fadeDuration,
        transform: Matrix4.identity()..translate(transformX, 0.0),
        decoration: BoxDecoration(
          color: colorScheme?.secondaryContainer.withOpacity(1),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
