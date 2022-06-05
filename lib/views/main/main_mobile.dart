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
      bottomNavigationBar: HomeBottomNavigation(viewModel: viewModel),
    );
  }

  Future<void> onFabPressed(bool showSoundLibraryButton, BuildContext context) async {
    if (showSoundLibraryButton) {
      final notifier = context.read<BottomNavItemsProvider>();
      if (notifier.tabs?.contains(SpRouter.soundList) == true) {
        await Navigator.of(context).maybePop();
        viewModel.setActiveRouter(SpRouter.soundList);
      } else {
        Navigator.of(context).pushNamed(SpRouter.soundList.path);
      }
    } else {
      return viewModel.createStory(context);
    }
  }

  Widget buildPages(BuildContext context) {
    return Consumer<BottomNavItemsProvider>(
      builder: (context, provider, child) {
        List<SpRouter> tabs = provider.tabs ?? [];
        return Stack(
          children: List.generate(tabs.length, (index) {
            SpRouter? item = tabs[index];
            bool selected = viewModel.activeRouter == item;
            return buildAnimatedPageWrapper(
              selected: selected,
              index: index,
              child: buildTabItem(
                item: item.tab!,
                index: index,
                context: context,
              ),
            );
          }),
        );
      },
    );
  }

  Widget buildAnimatedPageWrapper({
    required bool selected,
    required int index,
    required Widget child,
  }) {
    return AnimatedOpacity(
      opacity: selected ? 1.0 : 0.0,
      duration: ConfigConstant.duration,
      child: AnimatedContainer(
        duration: ConfigConstant.duration,
        transform: Matrix4.identity()..translate(0.0, !selected ? 8.0 : 0.0),
        child: Visibility(
          visible: selected,
          maintainState: index == 0,
          child: child,
        ),
      ),
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
          shouldShow: viewModel.activeRouter == SpRouter.home || showSoundLibraryButton,
          child: SpTapEffect(
            effects: const [SpTapEffectType.scaleDown],
            onTap: () => onFabPressed(showSoundLibraryButton, context),
            onLongPressed: () => viewModel.setShouldShowBottomNav(!viewModel.shouldShowBottomNavNotifier.value),
            child: buildObservationFab(showSoundLibraryButton),
          ),
        );
      },
    );
  }

  Widget buildObservationFab(bool showSoundLibraryButton) {
    return FloatingActionButton.extended(
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
        screen = buildHomeView(index);
        break;
      default:
        BaseRouteSetting<dynamic> route = SpRouteConfig(context: context).buildRoute(item.router);
        screen = route.route(context);
        break;
    }
    return screen;
  }

  Widget buildHomeView(int index) {
    return HomeView(
      onTabChange: viewModel.onTabChange,
      onYearChange: (int year) => viewModel.setYear(year),
      onScrollControllerReady: (ScrollController controller) {
        viewModel.setScrollController(index: index, controller: controller);
      },
    );
  }
}
