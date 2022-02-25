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
      body: buildPages(tabs, context),
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
    return SpShowHideAnimator(
      shouldShow: viewModel.activeIndex == 0,
      child: SpTapEffect(
        effects: [SpTapEffectType.scaleDown],
        onTap: () async {
          ListLayoutType? layout = await SpListLayoutBuilder.get();

          DateTime? date;
          switch (layout) {
            case ListLayoutType.single:
              date = await SpDatePicker.showMonthDayPicker(context, viewModel.date);
              break;
            case ListLayoutType.tabs:
              date = await SpDatePicker.showDayPicker(context, viewModel.date);
              break;
          }

          if (date != null) onConfirm(date, context);
        },
        onLongPressed: () {
          viewModel.setShouldShowBottomNav(!viewModel.shouldShowBottomNavNotifier.value);
        },
        child: FloatingActionButton.extended(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          label: const Text("Add"),
          icon: const Icon(
            Icons.edit,
            key: ValueKey(Icons.edit),
          ),
          onPressed: null,
        ),
      ),
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
