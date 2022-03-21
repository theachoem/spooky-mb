part of main_view;

class _MainMobile extends StatelessWidget {
  final MainViewModel viewModel;
  const _MainMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    List<MainTabBarItem> tabs = MainTabBar.items;
    return Scaffold(
      floatingActionButton: buildFloatingActionButton(context),
      body: Stack(
        children: [
          buildPages(tabs, context),
          buildBarrierColor(context),
        ],
      ),
      bottomNavigationBar: Wrap(
        children: [
          MiniSoundPlayer(),
          Divider(height: 0.0),
          buildBottomSafeHeight(context),
          buildBottomNavigationBar(tabs),
        ],
      ),
    );
  }

  Widget buildBottomSafeHeight(BuildContext context) {
    return Consumer<MiniSoundPlayerProvider>(
      child: ValueListenableBuilder<bool>(
        valueListenable: viewModel.shouldShowBottomNavNotifier,
        builder: (context, shownBottomNav, chil) {
          return AnimatedContainer(
            height: shownBottomNav ? 0.0 : MediaQuery.of(context).padding.bottom,
            color: Theme.of(context).appBarTheme.backgroundColor,
            duration: ConfigConstant.duration,
            curve: Curves.ease,
          );
        },
      ),
      builder: (context, provider, child) {
        return SpCrossFade(
          showFirst: provider.currentSounds.isNotEmpty,
          firstChild: child!,
          secondChild: SizedBox(width: double.infinity),
        );
      },
    );
  }

  Widget buildBarrierColor(BuildContext context) {
    MiniSoundPlayerProvider miniSoundPlayerProvider = context.read<MiniSoundPlayerProvider>();
    return ValueListenableBuilder<double>(
      valueListenable: miniSoundPlayerProvider.playerExpandProgressNotifier,
      builder: (context, percentage, child) {
        double offset = miniSoundPlayerProvider.offset(percentage);
        return Positioned.fill(
          child: IgnorePointer(
            ignoring: offset == 0.0,
            child: GestureDetector(
              onTap: () {
                miniSoundPlayerProvider.controller.animateToHeight(height: miniSoundPlayerProvider.playerMinHeight);
              },
              child: Opacity(
                opacity: offset,
                child: Container(color: Colors.black54),
              ),
            ),
          ),
        );
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
      builder: (context, shouldShow, child) {
        return ValueListenableBuilder(
          valueListenable: viewModel.bottomNavigationHeight,
          child: AnimatedOpacity(
            opacity: shouldShow ? 1 : 1,
            duration: ConfigConstant.fadeDuration,
            curve: Curves.ease,
            child: Wrap(
              children: [
                child ?? const SizedBox.shrink(),
              ],
            ),
          ),
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
  }

  Widget buildFloatingActionButton(BuildContext context) {
    MiniSoundPlayerProvider miniSoundPlayerProvider = context.read<MiniSoundPlayerProvider>();
    return ValueListenableBuilder<double>(
      valueListenable: miniSoundPlayerProvider.playerExpandProgressNotifier,
      builder: (context, percentage, child) {
        double offset = miniSoundPlayerProvider.offset(percentage);
        bool showSoundLibraryButton = offset >= 0.5;
        return SpShowHideAnimator(
          shouldShow: viewModel.activeIndex == 0 || showSoundLibraryButton,
          child: SpTapEffect(
            effects: const [SpTapEffectType.scaleDown],
            onTap: showSoundLibraryButton
                ? () => Navigator.of(context).pushNamed(SpRouter.soundList.path)
                : () => viewModel.createStory(context),
            onLongPressed: () => viewModel.setShouldShowBottomNav(!viewModel.shouldShowBottomNavNotifier.value),
            child: FloatingActionButton.extended(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              label: SpCrossFade(
                firstChild: const Text("Add"),
                secondChild: const Text("Sound Library"),
                showFirst: !showSoundLibraryButton,
              ),
              onPressed: null,
              icon: SpAnimatedIcons(
                showFirst: !showSoundLibraryButton,
                firstChild: const Icon(
                  Icons.edit,
                  key: ValueKey(Icons.edit),
                ),
                secondChild: const Icon(
                  Icons.music_note,
                  key: ValueKey(Icons.music_note),
                ),
              ),
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
    switch (item.router) {
      case SpRouter.home:
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
      case SpRouter.explore:
        screen = const ExploreView();
        break;
      case SpRouter.setting:
        screen = const SettingView();
        break;
      default:
        screen = const NotFoundView();
        break;
    }
    return screen;
  }
}
