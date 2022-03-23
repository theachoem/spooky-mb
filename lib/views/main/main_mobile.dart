part of main_view;

class _MainMobile extends StatelessWidget {
  final MainViewModel viewModel;
  const _MainMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return MiniPlayerScaffold(
      body: buildPages(context),
      floatingActionButton: buildFloatingActionButton(context),
      shouldShowBottomNavNotifier: viewModel.shouldShowBottomNavNotifier,
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget buildPages(BuildContext context) {
    return Consumer<BottomNavItemsProvider>(builder: (context, provider, child) {
      return Stack(
        children: List.generate(
          provider.tabs?.length ?? 0,
          (index) {
            SpRouter? item = provider.tabs?[index] ?? SpRouter.notFound;
            return Visibility(
              visible: min(viewModel.activeIndex, provider.tabs?.length ?? 0) == index,
              maintainState: index == 0,
              child: TweenAnimationBuilder<int>(
                duration: ConfigConstant.fadeDuration,
                tween: IntTween(begin: 0, end: 1),
                builder: (context, value, child) {
                  return AnimatedOpacity(
                    duration: ConfigConstant.fadeDuration,
                    opacity: index == viewModel.activeIndex && value == 1 ? 1 : 0,
                    child: buildTabItem(
                      item: item.tab!,
                      index: index,
                      context: context,
                    ),
                  );
                },
              ),
            );
          },
        ),
      );
    });
  }

  Widget buildBottomNavigationBar() {
    return Consumer<BottomNavItemsProvider>(
      builder: (context, provider, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: viewModel.shouldShowBottomNavNotifier,
          child: MeasureSize(
            onChange: (size) => viewModel.bottomNavigationHeight.value = size.height,
            child: SpBottomNavigationBar(
              currentIndex: viewModel.activeIndex,
              onTap: (int index) => viewModel.setActiveIndex(index),
              items: (provider.tabs ?? []).map((tab) {
                MainTabBarItem e = tab.tab!;
                return SpBottomNavigationBarItem(
                  activeIconData: e.activeIcon,
                  iconData: e.inactiveIcon,
                  label: e.router.title,
                );
              }).toList(),
            ),
          ),
          builder: (context, shouldShow, child) {
            shouldShow = shouldShow || provider.tabs != null;
            return ValueListenableBuilder(
              valueListenable: viewModel.bottomNavigationHeight,
              child: AnimatedOpacity(
                duration: ConfigConstant.duration,
                curve: Curves.ease,
                opacity: provider.tabs == null ? 0.0 : 1.0,
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
      default:
        BaseRouteSetting<dynamic> route = SpRouteConfig(context: context).buildRoute(item.router);
        screen = route.route(context);
        break;
    }
    return screen;
  }
}
