part of bottom_nav_setting_view;

class _BottomNavSettingMobile extends StatelessWidget {
  final BottomNavSettingViewModel viewModel;
  const _BottomNavSettingMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(title: const SpAppBarTitle()),
      body: ReorderableListView.builder(
        itemBuilder: (context, index) {
          MainTabBarItem tab = viewModel.tabs[index];
          return IgnorePointer(
            ignoring: !tab.optinal,
            key: ValueKey(tab.router),
            child: ListTile(
              leading: Icon(tab.activeIcon),
              title: Text(tab.router.title),
              trailing: Checkbox(
                value: true,
                fillColor: tab.optinal ? null : MaterialStateProperty.all(Theme.of(context).disabledColor),
                onChanged: (value) {},
              ),
            ),
          );
        },
        itemCount: viewModel.tabs.length,
        onReorder: (oldIndex, newIndex) {
          viewModel.onReorder(oldIndex, newIndex);
        },
      ),
    );
  }
}
