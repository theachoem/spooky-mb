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
      body: IndexedStack(
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
      ),
    );
  }

  Widget buildBottomNavigationBar(List<MainTabBarItem> tabs) {
    return SpBottomNavigationBar(
      currentIndex: viewModel.activeIndex,
      onTap: (int index) => viewModel.setActiveIndex(index),
      items: tabs.map((e) {
        return SpBottomNavigationBarItem(
          activeIconData: e.activeIcon,
          iconData: e.inactiveIcon,
          label: e.label,
        );
      }).toList(),
    );
  }

  Widget buildFloatingActionButton(BuildContext context) {
    return Builder(builder: (context) {
      return SpShowHideAnimator(
        shouldShow: viewModel.activeIndex == 0,
        child: FloatingActionButton.extended(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          label: const Text("Add"),
          icon: const Icon(Icons.edit),
          onPressed: () async {
            DateTime? date = await SpDatePicker.showDayPicker(
              context,
              viewModel.date,
            );
            if (date != null) onConfirm(date, context);
          },
        ),
      );
    });
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
