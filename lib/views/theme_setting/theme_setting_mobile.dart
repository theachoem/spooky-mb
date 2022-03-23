part of theme_setting_view;

class _ThemeSettingMobile extends StatelessWidget {
  final ThemeSettingViewModel viewModel;
  const _ThemeSettingMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        leading: ModalRoute.of(context)?.canPop == true ? const SpPopButton() : null,
        title: const SpAppBarTitle(fallbackRouter: SpRouter.themeSetting),
      ),
      body: ListView(
        children: SpSectionsTiles.divide(
          context: context,
          sections: [
            SpSectionContents(
              headline: "Personalize",
              tiles: [
                buildColorThemeTile(),
                buildThemeModeTile(context),
              ],
            ),
            SpSectionContents(
              headline: "Font",
              tiles: [
                ListTile(
                  title: Text(SpRouter.fontManager.title),
                  leading: const Icon(Icons.font_download),
                  onTap: () {
                    if (context.read<UserProvider>().purchased(ProductAsType.fontBook)) {
                      Navigator.of(context).pushNamed(SpRouter.fontManager.path);
                    } else {
                      Navigator.of(context).pushNamed(SpRouter.addOn.path);
                    }
                  },
                ),
              ],
            ),
            SpSectionContents(
              headline: "Story",
              tiles: [
                buildLayoutTile(context),
                buildSortTile(context),
                buildMaxLineTile(),
                const Divider(height: 0),
                buildShowChipTile(),
              ],
            ),
            SpSectionContents(
              headline: "Advance",
              tiles: [
                ListTile(
                  leading: const SizedBox(
                    height: 40,
                    child: Icon(Icons.settings_suggest),
                  ),
                  title: Text(SpRouter.bottomNavSetting.subtitle),
                  onTap: () {
                    Navigator.of(context).pushNamed(SpRouter.bottomNavSetting.path);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMaxLineTile() {
    return Consumer<TileMaxLineProvider>(builder: (context, provider, child) {
      return ListTile(
        leading: const SizedBox(height: 40, child: Icon(Icons.article)),
        title: const Text("Max line"),
        subtitle: Text(provider.maxLine.toString()),
        trailing: const Icon(Icons.keyboard_arrow_right),
        onTap: () {
          showTextInputDialog(
            context: context,
            title: "Set max line",
            textFields: [
              DialogTextField(
                keyboardType: TextInputType.number,
                initialText: provider.maxLine.toString(),
                validator: (String? data) {
                  if (data != null) {
                    int? value = int.tryParse(data);
                    if (value != null) {
                      return null;
                    }
                  }
                  return "Invalid number";
                },
              ),
            ],
          ).then((value) {
            if (value?.isNotEmpty == true) {
              provider.setMaxLine(int.tryParse(value!.first));
            }
          });
        },
      );
    });
  }

  Consumer<ShowChipsProvider> buildShowChipTile() {
    return Consumer<ShowChipsProvider>(
      builder: (context, provider, child) {
        return SwitchListTile.adaptive(
          value: provider.shouldShow,
          title: const Text("Show chips on story"),
          onChanged: (value) {
            provider.set(value);
          },
        );
      },
    );
  }

  Widget buildColorThemeTile() {
    return SpOverlayEntryButton(floatingBuilder: (context, callback) {
      return SpColorPicker(
        blackWhite: SpColorPicker.getBlackWhite(context),
        currentColor: context.read<ThemeProvider>().colorSeed,
        onPickedColor: (color) async {
          callback();
          await Future.delayed(ConfigConstant.duration);
          await context.read<ThemeProvider>().updateColor(color);
        },
      );
    }, childBuilder: (context, callback) {
      return ListTile(
        title: const Text("Color"),
        trailing: SizedBox(
          width: 48,
          child: SpColorItem(
            size: ConfigConstant.iconSize2,
            onPressed: null,
            selected: true,
            color: context.read<ThemeProvider>().colorSeed,
          ),
        ),
        onLongPress: () {
          Navigator.of(context).pushNamed(SpRouter.initPickColor.path);
        },
        onTap: () {
          callback();
        },
      );
    });
  }

  ListTile buildThemeModeTile(BuildContext context) {
    ThemeMode mode = context.read<ThemeProvider>().themeMode;
    return ListTile(
      title: SpCrossFade(
        firstChild: Text(mode.name.capitalize),
        secondChild: Text(mode.name.capitalize),
        showFirst: M3Color.of(context).brightness == Brightness.dark,
      ),
      trailing: SpThemeSwitcher(backgroundColor: Colors.transparent),
      onTap: () => SpThemeSwitcher?.onPress(context),
      onLongPress: () => SpThemeSwitcher?.onLongPress(context),
    );
  }

  Widget buildSortTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.sort),
      title: const Text("Sort"),
      onTap: () async {
        SortType? sortType;
        sortType = await SortTypeStorage().readEnum() ?? SortType.oldToNew;

        String sortTitle(SortType? type) {
          switch (type) {
            case SortType.oldToNew:
              return "Old to New";
            case SortType.newToOld:
              return "New to Old";
            case SortType.starred:
              return "Starred";
            case null:
              return "null";
          }
        }

        SortType? _sortType = await showConfirmationDialog(
          context: context,
          title: "Reorder Your Stories",
          initialSelectedActionKey: sortType,
          actions: [
            AlertDialogAction(
              key: SortType.newToOld,
              label: sortTitle(SortType.newToOld),
            ),
            AlertDialogAction(
              key: SortType.starred,
              label: sortTitle(SortType.starred),
            ),
            AlertDialogAction(
              key: SortType.oldToNew,
              label: sortTitle(SortType.oldToNew),
            ),
          ].map((e) {
            return AlertDialogAction<SortType>(
              key: e.key,
              isDefaultAction: e.key == sortType,
              label: e.label,
            );
          }).toList(),
        );

        if (_sortType != null) {
          sortType = _sortType;
          SortTypeStorage().writeEnum(sortType);
        }
      },
    );
  }

  Widget buildLayoutTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.list_alt),
      title: const Text("Layout"),
      onTap: () async {
        ListLayoutType layoutType = await SpListLayoutBuilder.get();

        String layoutTitle(ListLayoutType type) {
          switch (type) {
            case ListLayoutType.single:
              return "Single List";
            case ListLayoutType.tabs:
              return "Tabs";
          }
        }

        ListLayoutType? _layoutType = await showConfirmationDialog(
          context: context,
          title: "Layout",
          initialSelectedActionKey: layoutType,
          actions: [
            AlertDialogAction(
              key: ListLayoutType.single,
              label: layoutTitle(ListLayoutType.single),
            ),
            AlertDialogAction(
              key: ListLayoutType.tabs,
              label: layoutTitle(ListLayoutType.tabs),
            ),
          ].map((e) {
            return AlertDialogAction<ListLayoutType>(
              key: e.key,
              isDefaultAction: e.key == layoutType,
              label: e.label,
            );
          }).toList(),
        );

        if (_layoutType != layoutType && _layoutType != null) {
          await SpListLayoutBuilder.set(_layoutType);
          Phoenix.rebirth(context);
        }
      },
    );
  }
}
