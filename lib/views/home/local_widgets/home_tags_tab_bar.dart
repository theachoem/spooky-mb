import 'package:flutter/material.dart';
import 'package:spooky/views/home/local_widgets/home_app_bar.dart';
import 'package:spooky/widgets/sp_reorderable_tab_bar.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class HomeTagsTabBar extends StatelessWidget {
  const HomeTagsTabBar({
    Key? key,
    required this.widget,
    required this.parentState,
    this.reorderable,
  }) : super(key: key);

  final HomeAppBar widget;
  final HomeAppBarState parentState;
  final bool Function(int index)? reorderable;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(40),
      child: SpReorderableTabBar(
        indicator: Theme.of(context).tabBarTheme.indicator,
        indicatorWeight: 4.1,
        onReorder: widget.onReorder,
        padding: const EdgeInsets.symmetric(horizontal: ConfigConstant.margin2),
        controller: widget.tabController,
        reorderable: reorderable,
        onContext: (context) => parentState.tabContext = context,
        onLongPress: (context, index) {
          if (context == null) return;
          widget.viewModel.showTabPopover(
            context: context,
            index: index,
            controller: widget.tabController,
            parentState: parentState,
            reorderable: reorderable,
          );
        },
        tabs: widget.tabs.map((tab) {
          bool starred = tab.label == "*";
          return Tab(
            key: ValueKey(tab.id),
            text: starred ? null : tab.label,
            child: starred ? const Icon(Icons.star) : null,
          );
        }).toList(),
      ),
    );
  }
}
