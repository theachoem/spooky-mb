import 'package:flutter/material.dart';
import 'package:spooky/ui/views/home/local_widgets/home_tab_indicator.dart';

class HomeTabBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeTabBar({
    Key? key,
    required this.height,
    required this.tabs,
    this.controller,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
  }) : super(key: key);

  final double height;
  final List<String> tabs;
  final TabController? controller;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    TabController? tabController = controller ?? DefaultTabController.of(context);
    Color indicatorColor = Theme.of(context).colorScheme.onSurface;
    return Container(
      padding: padding,
      height: height + padding.top + padding.bottom,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: TabBar(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          controller: tabController,
          isScrollable: true,
          onTap: (index) {},
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          indicatorColor: indicatorColor,
          unselectedLabelColor: indicatorColor,
          labelColor: Theme.of(context).colorScheme.surface,
          labelStyle: Theme.of(context).textTheme.bodyText2,
          indicator: SpTabIndicator(borderSide: BorderSide(width: height)),
          tabs: List.generate(
            tabs.length,
            (index) {
              final text = tabs[index];
              return Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(text),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(height + padding.top + padding.bottom);
  }
}
