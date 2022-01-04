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
      ],
      builder: (context, child, animation) {
        final TabsRouter tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: FadeTransition(
            opacity: animation,
            child: child,
          ),
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          floatingActionButton: AnimatedShowHide(
            shouldShow: tabsRouter.activeIndex == 0,
            child: FloatingActionButton.extended(
              onPressed: () {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              label: Text("Add"),
              icon: Icon(Icons.edit),
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
            ],
          ),
        );
      },
    );
  }
}
