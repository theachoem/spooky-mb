import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/views/home/home_view_model.dart';
import 'package:spooky/views/home/local_widgets/home_tab_indicator.dart';
import 'package:spooky/widgets/sp_reorderable_tab_bar.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';

class HomeTabBarWrapper extends StatelessWidget implements PreferredSizeWidget {
  const HomeTabBarWrapper({
    Key? key,
    required this.child,
    required this.height,
    required this.visible,
  }) : super(key: key);

  final Widget child;
  final double height;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: child,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class HomeTabBar extends StatelessWidget {
  const HomeTabBar({
    Key? key,
    required this.height,
    required this.tabs,
    required this.viewModel,
    this.controller,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
  }) : super(key: key);

  final double height;
  final List<String> tabs;
  final TabController? controller;
  final EdgeInsets padding;
  final ValueChanged<int>? onTap;
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    TabController? tabController = controller ?? DefaultTabController.of(context);
    return Container(
      padding: padding,
      height: height + padding.top + padding.bottom,
      child: buildTabBar(tabController, context),
    );
  }

  Widget buildTabBar(
    TabController? tabController,
    BuildContext context,
  ) {
    return SpReorderableTabBar(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      controller: tabController,
      onTap: onTap,
      splashBorderRadius: BorderRadius.circular(48),
      unselectedLabelColor: M3Color.of(context).primary,
      labelColor: M3Color.of(context).onPrimary,
      indicator: SpTabIndicator(
        borderSide: BorderSide(
          width: height,
          color: M3Color.of(context).primary,
        ),
      ),
      onReorder: (int oldIndex, int newIndex) {},
      onLongPress: (context, index) {
        if (tabController?.index == index) {
          viewModel.showTabPopover(
            context: context,
            index: index,
            contentDyOffset: 12,
            controller: tabController,
          );
        }
      },
      tabs: List.generate(
        tabs.length,
        (index) {
          final text = tabs[index];
          return buildTabItem(tabController, text, index);
        },
      ),
    );
  }

  Widget buildTabItem(TabController? tabController, String text, int index) {
    return AnimatedBuilder(
      animation: tabController!.animation!,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(text, textAlign: TextAlign.center),
      ),
      builder: (context, child) {
        return SpTapEffect(
          onTap: () {
            if (tabController.index == index) return;
            if (onTap != null) onTap!(index);
            tabController.animateTo(index);
          },
          behavior: HitTestBehavior.opaque,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
