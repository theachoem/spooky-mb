part of main_view;

class _MainMobile extends StatelessWidget {
  final MainViewModel viewModel;
  const _MainMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return route.AutoTabsRouter(
      routes: [
        route.Home(
          onTabChange: viewModel.onTabChange,
          onYearChange: (int year) => viewModel.year = year,
          onListReloaderReady: (void Function() callback) {
            viewModel.storyListReloader = callback;
          },
        ),
        route.Explore(),
        route.Setting(),
      ],
      builder: (context, child, animation) {
        final route.TabsRouter tabsRouter = route.AutoTabsRouter.of(context);
        return Scaffold(
          body: FadeTransition(
            opacity: animation,
            child: child,
          ),
          floatingActionButton: SpShowHideAnimator(
            shouldShow: tabsRouter.activeIndex == 0,
            child: FloatingActionButton.extended(
              onPressed: () {
                SpDatePicker.showDayPicker(context, viewModel.date, (date) async {
                  await context.router
                      .push(
                    route.Detail(story: StoryModel.create(pathDate: date)),
                  )
                      .then((value) {
                    if (value is StoryModel && value.documentId != null && viewModel.storyListReloader != null) {
                      viewModel.storyListReloader!();
                    }
                  });
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              label: const Text("Add"),
              icon: const Icon(Icons.edit),
            ),
          ),
          bottomNavigationBar: SpBottomNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: (int index) {
              tabsRouter.setActiveIndex(index);
            },
            items: [
              SpBottomNavigationBarItem(
                activeIconData: Icons.home,
                iconData: Icons.home_outlined,
                label: "Home",
              ),
              SpBottomNavigationBarItem(
                activeIconData: Icons.explore,
                iconData: Icons.explore_outlined,
                label: "Explore",
              ),
              SpBottomNavigationBarItem(
                activeIconData: Icons.settings,
                iconData: Icons.settings_outlined,
                label: "Setting",
              ),
            ],
          ),
        );
      },
    );
  }
}
