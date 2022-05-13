part of bottom_nav_setting_view;

class _BottomNavSettingMobile extends StatelessWidget {
  final BottomNavSettingViewModel viewModel;
  const _BottomNavSettingMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        title: const SpAppBarTitle(fallbackRouter: SpRouter.bottomNavSetting),
        leading: ModalRoute.of(context)?.canPop == true ? const SpPopButton() : null,
      ),
      body: Consumer<BottomNavItemsProvider>(
        builder: (context, provider, child) {
          List<BottomNavItemModel> items = provider.availableTabs?.items ?? [];
          return ReorderableListView.builder(
            itemBuilder: (context, index) {
              MainTabBarItem tab = items[index].router!.tab!;
              bool selected = provider.tabs?.contains(tab.router) == true;
              _toggle() => toggle(items, index, selected, provider, context);

              return IgnorePointer(
                ignoring: !tab.optinal,
                key: ValueKey(tab.router),
                child: ListTile(
                  leading: Icon(tab.activeIcon),
                  title: Text(tab.router.title),
                  onTap: () => _toggle(),
                  trailing: Checkbox(
                    value: selected,
                    fillColor: tab.optinal ? null : MaterialStateProperty.all(Theme.of(context).disabledColor),
                    onChanged: (value) => _toggle(),
                  ),
                ),
              );
            },
            itemCount: items.length,
            onReorder: (oldIndex, newIndex) async {
              List<BottomNavItemModel> copied = [...items];
              if (oldIndex < newIndex) newIndex -= 1;
              if (!copied[oldIndex].router!.tab!.optinal || !copied[newIndex].router!.tab!.optinal) return;

              final BottomNavItemModel item = copied.removeAt(oldIndex);
              copied.insert(newIndex, item);

              String? msg = await provider.set(
                tabsList: BottomNavItemListModel(copied),
                context: context,
              );

              if (msg != null) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  MessengerService.instance.showSnackBar(msg);
                });
              }
            },
          );
        },
      ),
    );
  }

  void toggle(
    List<BottomNavItemModel> items,
    int index,
    bool selected,
    BottomNavItemsProvider provider,
    BuildContext context,
  ) {
    List<BottomNavItemModel> copied = [...items];
    BottomNavItemModel newValue = copied[index].copyWith(selected: !selected);
    copied[index] = newValue;

    Iterable<BottomNavItemModel> result = copied.where((e) => e.selected == true);
    if (result.length > 5) {
      MessengerService.instance.showSnackBar("Must not bigger than 5 items");
    } else {
      provider.set(
        tabsList: BottomNavItemListModel(copied),
        context: context,
      );
    }
  }
}
