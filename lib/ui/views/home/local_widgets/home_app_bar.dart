import 'package:flutter/material.dart';
import 'package:spooky/ui/views/home/local_widgets/home_tab_bar.dart';
import 'package:spooky/utils/mixins/stateful_mixin.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.tabLabels,
    required this.tabController,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final List<String> tabLabels;
  final TabController tabController;

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> with StatefulMixin {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: appBarTheme.elevation,
      pinned: true,
      floating: true,
      stretch: true,
      expandedHeight: kToolbarHeight + 48.0 + 32.0 + 16.0,
      bottom: HomeTabBar(
        height: 40,
        controller: widget.tabController,
        tabs: List.generate(
          widget.tabLabels.length,
          (index) => widget.tabLabels[index],
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        stretchModes: [
          StretchMode.zoomBackground,
        ],
        background: buildBackground(),
      ),
    );
  }

  Widget buildBackground() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, statusBarHeight + 24.0 + 4.0, 16.0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: textTheme.headline6?.copyWith(color: colorScheme.primary),
          ),
          Text(
            widget.subtitle,
            style: textTheme.bodyText2?.copyWith(color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}
