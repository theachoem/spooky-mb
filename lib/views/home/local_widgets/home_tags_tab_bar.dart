import 'package:community_material_icon/community_material_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/services/popover_service.dart';
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
          PopoverService.instance.show(
            context: context,
            contentDyOffset: 6.0,
            items: [
              PopoverItem(
                title: tr("button.reorder"),
                iconData: CommunityMaterialIcons.order_alphabetical_ascending,
                onPressed: () {
                  parentState.toggleTabEditing();
                },
              ),
              if (reorderable != null && reorderable!(index))
                PopoverItem(
                  title: tr("button.update"),
                  iconData: CommunityMaterialIcons.table_edit,
                  onPressed: () {
                    widget.viewModel.update(
                      widget.tabs[index],
                      context,
                    );
                  },
                ),
              if (reorderable != null && reorderable!(index))
                PopoverItem(
                  title: tr("button.delete"),
                  iconData: Icons.delete,
                  foregroundColor: Theme.of(context).colorScheme.error,
                  onPressed: () {
                    widget.viewModel.removeTab(
                      widget.tabs[index],
                      context,
                    );
                  },
                ),
            ],
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
