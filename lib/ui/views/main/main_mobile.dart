part of main_view;

class _MainMobile extends StatelessWidget {
  final MainViewModel viewModel;
  const _MainMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        r.Home(),
        r.Explore(),
        r.Setting(),
      ],
      builder: (context, child, animation) {
        final TabsRouter tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: FadeTransition(
            opacity: animation,
            child: child,
          ),
          floatingActionButton: SpShowHideAnimator(
            shouldShow: tabsRouter.activeIndex == 0,
            child: FloatingActionButton.extended(
              onPressed: () {
                context.router.push(
                  r.Detail(
                    initialStory: StoryModel.fromNow(),
                    intialFlow: DetailViewFlow.create,
                  ),
                );
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
