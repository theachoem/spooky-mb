part of main_view;

class _MainMobile extends StatelessWidget {
  final MainViewModel viewModel;
  const _MainMobile(this.viewModel);

  void onConfirm(DateTime date, BuildContext context) {
    DetailArgs args = DetailArgs(initialStory: StoryModel.fromDate(date), intialFlow: DetailViewFlowType.create);
    Navigator.of(context).pushNamed(SpRouteConfig.detail, arguments: args).then((value) {
      if (viewModel.storyListReloader != null && value != null) viewModel.storyListReloader!();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<MainTabBarItem> tabs = MainTabBar.items;
    return Scaffold(
      floatingActionButton: buildFloatingActionButton(context),
      bottomNavigationBar: buildBottomNavigationBar(tabs),
      body: buildPagesListener(
        child: buildPages(tabs, context),
        context: context,
      ),
    );
  }

  Widget buildPagesListener({
    required Widget child,
    required BuildContext context,
  }) {
    double height = MediaQuery.of(context).size.height;
    return NotificationListener<ScrollNotification>(
      child: child,
      onNotification: (notification) {
        double offset = notification.metrics.pixels;

        switch (Theme.of(context).platform) {
          case TargetPlatform.android:
          case TargetPlatform.iOS:
            // viewModel.currentScrollController return value
            // that not actually an desire offset, so we prevent it
            if (offset != viewModel.currentScrollController?.offset && offset != 0) {
              viewModel.setShouldScrollToTop(offset > height / 2);
              return true;
            }
            break;
          case TargetPlatform.fuchsia:
          case TargetPlatform.linux:
          case TargetPlatform.macOS:
          case TargetPlatform.windows:
            double windowOffset = viewModel.currentScrollController?.offset ?? 0.0;
            viewModel.setShouldScrollToTop(windowOffset > 0);
            return true;
        }

        return false;
      },
    );
  }

  Widget buildPages(List<MainTabBarItem> tabs, BuildContext context) {
    return IndexedStack(
      index: viewModel.activeIndex,
      sizing: StackFit.expand,
      children: List.generate(tabs.length, (index) {
        return AnimatedOpacity(
          duration: ConfigConstant.fadeDuration,
          opacity: index == viewModel.activeIndex ? 1 : 0,
          child: buildTabItem(
            item: tabs[index],
            index: index,
            context: context,
          ),
        );
      }),
    );
  }

  Widget buildBottomNavigationBar(List<MainTabBarItem> tabs) {
    return ValueListenableBuilder<bool>(
      valueListenable: viewModel.shouldShowBottomNavNotifier,
      child: MeasureSize(
        onChange: (size) => viewModel.bottomNavigationHeight.value = size.height,
        child: SpBottomNavigationBar(
          currentIndex: viewModel.activeIndex,
          onTap: (int index) => viewModel.setActiveIndex(index),
          items: tabs.map((e) {
            return SpBottomNavigationBarItem(
              activeIconData: e.activeIcon,
              iconData: e.inactiveIcon,
              label: e.label,
            );
          }).toList(),
        ),
      ),
      builder: (context, shouldShow, child1) {
        return ValueListenableBuilder(
          valueListenable: viewModel.bottomNavigationHeight,
          child: child1,
          builder: (context, height, child2) {
            return AnimatedContainer(
              height: shouldShow ? viewModel.bottomNavigationHeight.value : 0,
              duration: ConfigConstant.duration,
              curve: Curves.ease,
              child: AnimatedOpacity(
                opacity: shouldShow ? 1 : 1,
                duration: ConfigConstant.fadeDuration,
                curve: Curves.ease,
                child: Wrap(
                  children: [
                    child2 ?? SizedBox.shrink(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildFloatingActionButton(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: viewModel.shouldScrollToTopNotifier,
      builder: (context, shouldScrollToTop, child) {
        return SpShowHideAnimator(
          shouldShow: viewModel.activeIndex == 0,
          child: SpTapEffect(
            effects: [SpTapEffectType.scaleDown],
            onTap: () async {
              if (shouldScrollToTop) {
                await viewModel.currentScrollController
                    ?.animateTo(0.0, duration: ConfigConstant.duration, curve: ConfigConstant.scrollToTopCurve);
              } else {
                DateTime? date = await SpDatePicker.showDayPicker(context, viewModel.date);
                if (date != null) onConfirm(date, context);
              }
            },
            onLongPressed: () {
              viewModel.setShouldShowBottomNav(!viewModel.shouldShowBottomNavNotifier.value);
            },
            child: FloatingActionButton.extended(
              backgroundColor: !shouldScrollToTop ? null : M3Color.of(context).primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              label: SpCrossFade(
                firstChild: const Text("Add"),
                secondChild: const Text("Back"),
                showFirst: !shouldScrollToTop,
              ),
              icon: SpAnimatedIcons(
                firstChild: const Icon(Icons.edit, key: ValueKey(Icons.edit)),
                secondChild: const Icon(Icons.arrow_upward, key: ValueKey(Icons.arrow_upward)),
                showFirst: !shouldScrollToTop,
              ),
              onPressed: null,
            ),
          ),
        );
      },
    );
  }

  Widget buildTabItem({
    required MainTabBarItem item,
    required BuildContext context,
    required int index,
  }) {
    Widget screen;
    switch (item.routeName) {
      case SpRouteConfig.home:
        screen = HomeView(
          onTabChange: viewModel.onTabChange,
          onYearChange: (int year) => viewModel.year = year,
          onListReloaderReady: (void Function() callback) {
            viewModel.storyListReloader = callback;
          },
          onScrollControllerReady: (ScrollController controller) {
            viewModel.setScrollController(
              index: index,
              controller: controller,
            );
          },
        );
        break;
      case SpRouteConfig.explore:
        screen = ExploreView();
        break;
      case SpRouteConfig.setting:
        screen = SettingView();
        break;
      default:
        screen = SpRouteConfig.buildNotFound();
        break;
    }
    return screen;
  }
}
