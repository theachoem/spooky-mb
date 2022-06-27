import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/providers/bottom_nav_items_provider.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/util_widgets/measure_size.dart';
import 'package:spooky/views/main/main_view_item.dart';
import 'package:spooky/views/main/main_view_model.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';

class HomeBottomNavigation extends StatelessWidget {
  const HomeBottomNavigation({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final MainViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavItemsProvider>(
      builder: (context, provider, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: viewModel.shouldShowBottomNavNotifier,
          child: buildNavigationBar(provider),
          builder: (context, shouldShowFromParams, child) {
            bool shouldShow = shouldShowFromParams && provider.tabs != null && provider.tabs!.length >= 2;
            return ValueListenableBuilder(
              valueListenable: viewModel.bottomNavigationHeight,
              child: buildAnimatedVisibilityWrapper(provider, shouldShow, child),
              builder: (context, height, child) {
                return AnimatedContainer(
                  height: shouldShow ? viewModel.bottomNavigationHeight.value : 0,
                  duration: ConfigConstant.duration,
                  curve: Curves.ease,
                  child: child,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget buildAnimatedVisibilityWrapper(BottomNavItemsProvider provider, bool shouldShow, Widget? child) {
    return AnimatedOpacity(
      duration: ConfigConstant.duration,
      curve: Curves.ease,
      opacity: provider.tabs == null ? 0.0 : 1.0,
      child: Wrap(
        children: [
          Visibility(
            visible: shouldShow,
            child: child ?? const SizedBox.shrink(),
          )
        ],
      ),
    );
  }

  Widget buildNavigationBar(BottomNavItemsProvider provider) {
    final tabs = provider.tabs ?? [];
    return MeasureSize(
      onChange: (size) => viewModel.bottomNavigationHeight.value = size.height,
      child: tabs.length >= 2
          ? NavigationBar(
              key: ValueKey(viewModel.shouldShowBottomNavNotifier.value),
              onDestinationSelected: (int index) => viewModel.setActiveRouter(provider.tabs![index]),
              selectedIndex: provider.tabs?.indexOf(viewModel.activeRouter) ?? 0,
              destinations: (provider.tabs ?? []).map((tab) {
                MainTabBarItem e = tab.tab!;
                return SpTapEffect(
                  onTap: () => viewModel.setActiveRouter(e.router),
                  child: NavigationDestination(
                    tooltip: e.router.title,
                    selectedIcon: Icon(e.activeIcon),
                    icon: Icon(e.inactiveIcon),
                    label: e.label,
                  ),
                );
              }).toList(),
            )
          : const SizedBox.shrink(),
    );
  }
}
