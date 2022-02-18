part of main_view;

class _MainMobile extends StatelessWidget {
  final MainViewModel viewModel;
  const _MainMobile(this.viewModel);

  void onConfirm(DateTime date, BuildContext context) {
    DetailArgs args = DetailArgs(initialStory: StoryModel.fromDate(date), intialFlow: DetailViewFlow.create);
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
      ),
    );
  }

  Widget buildPagesListener({
    required Widget child,
  }) {
    return NotificationListener<UserScrollNotification>(
      child: child,
      onNotification: (notification) {
        ScrollDirection direction = notification.direction;
        double maxScrollExtent = notification.metrics.maxScrollExtent;

        // some screen list view can't be scroll
        if (maxScrollExtent == 0) {
          if (direction == ScrollDirection.idle) {
            return false;
          } else {
            viewModel.setShowBottomNav(true);
            return true;
          }
        }

        switch (notification.direction) {
          case ScrollDirection.idle:
            return true;
          case ScrollDirection.forward:
            WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
              viewModel.setShowBottomNav(true);
            });
            break;
          case ScrollDirection.reverse:
            WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
              viewModel.setShowBottomNav(false);
            });
            break;
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
      valueListenable: viewModel.shouldShowBottomNavNotifier,
      builder: (context, allowToAdd, child) {
        return SpShowHideAnimator(
          shouldShow: viewModel.activeIndex == 0,
          child: FloatingActionButton.extended(
            backgroundColor: allowToAdd ? null : M3Color.of(context).primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            label: SpCrossFade(
              firstChild: const Text("Add"),
              secondChild: const Text("Scroll to Top"),
              showFirst: allowToAdd,
            ),
            icon: SpAnimatedIcons(
              firstChild: const Icon(Icons.edit, key: ValueKey(Icons.edit)),
              secondChild: const Icon(Icons.arrow_upward, key: ValueKey(Icons.arrow_upward)),
              showFirst: allowToAdd,
            ),
            onPressed: () async {
              if (!allowToAdd) {
                await PrimaryScrollController.of(context)
                    ?.animateTo(0.0, duration: ConfigConstant.duration, curve: ConfigConstant.scrollToTopCurve);
                viewModel.shouldShowBottomNavNotifier.value = true;
              } else {
                DateTime? date = await SpDatePicker.showDayPicker(context, viewModel.date);
                if (date != null) onConfirm(date, context);
              }
            },
          ),
        );
      },
    );
  }

  Widget buildTabItem({
    required MainTabBarItem item,
    required BuildContext context,
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
