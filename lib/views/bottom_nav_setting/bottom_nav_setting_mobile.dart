part of bottom_nav_setting_view;

class _BottomNavSettingMobile extends StatelessWidget {
  final BottomNavSettingViewModel viewModel;
  const _BottomNavSettingMobile(this.viewModel);

  Future<void> onReorder(
    List<BottomNavItemModel> items,
    int oldIndex,
    int newIndex,
    BottomNavItemsProvider provider,
    BuildContext context,
  ) async {
    List<BottomNavItemModel> copied = [...items];
    if (oldIndex < newIndex) newIndex -= 1;
    if (!copied[oldIndex].router!.datas.tab!.optinal || !copied[newIndex].router!.datas.tab!.optinal) return;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: MorphingAppBar(
        title: const SpAppBarTitle(fallbackRouter: SpRouter.bottomNavSetting),
        leading: ModalRoute.of(context)?.canPop == true ? const SpPopButton() : null,
      ),
      bottomNavigationBar: IgnorePointer(
        child: Consumer<BottomNavItemsProvider>(builder: (context, provider, child) {
          if (provider.tabs == null) return const SizedBox.shrink();
          return buildBottomNavDemo(context, provider);
        }),
      ),
      body: Consumer<BottomNavItemsProvider>(
        builder: (context, provider, child) {
          List<BottomNavItemModel> items = provider.availableTabs?.items ?? [];
          return ReorderableListView.builder(
            itemBuilder: (context, index) {
              MainTabBarItem tab = items[index].router!.datas.tab!;
              bool selected = provider.tabs?.contains(tab.router) == true;
              return buildBottomNavItem(
                tab: tab,
                toggle: () => toggle(items, index, selected, provider, context),
                selected: selected,
                context: context,
              );
            },
            itemCount: items.length,
            onReorder: (oldIndex, newIndex) async {
              await onReorder(items, oldIndex, newIndex, provider, context);
            },
          );
        },
      ),
    );
  }

  Widget buildBottomNavItem({
    required MainTabBarItem tab,
    required void Function() toggle,
    required bool selected,
    required BuildContext context,
  }) {
    return IgnorePointer(
      ignoring: !tab.optinal,
      key: ValueKey(tab.router),
      child: ListTile(
        leading: Wrap(
          children: [
            const Icon(Icons.reorder),
            const SizedBox(width: 16.0, height: 8.0),
            Icon(tab.activeIcon),
          ],
        ),
        title: Text(tab.router.datas.title),
        onTap: () => toggle(),
        trailing: Checkbox(
          value: selected,
          fillColor: tab.optinal ? null : MaterialStateProperty.all(Theme.of(context).disabledColor),
          onChanged: (value) => toggle(),
        ),
      ),
    );
  }

  Widget buildBottomNavDemo(
    BuildContext context,
    BottomNavItemsProvider provider,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ConfigConstant.margin2)
          .copyWith(bottom: MediaQuery.of(context).padding.bottom + 8.0),
      child: Material(
        borderOnForeground: true,
        borderRadius: ConfigConstant.circlarRadius2,
        clipBehavior: Clip.hardEdge,
        child: NavigationBar(
          selectedIndex: 0,
          height: 80 - MediaQuery.of(context).padding.bottom / 2,
          destinations: provider.tabs?.map((e) {
                final tab = e.datas.tab!;
                return Container(
                  transform: Matrix4.identity()..translate(0.0, MediaQuery.of(context).padding.bottom / 2),
                  child: NavigationDestination(
                    icon: Icon(tab.inactiveIcon),
                    selectedIcon: Icon(tab.activeIcon),
                    label: tab.label,
                  ),
                );
              }).toList() ??
              [],
        ),
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
      MessengerService.instance.showSnackBar(tr("msg.must_bigger_than_5_items"));
    } else {
      provider.set(
        tabsList: BottomNavItemListModel(copied),
        context: context,
      );
    }
  }
}
