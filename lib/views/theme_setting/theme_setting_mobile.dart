part of theme_setting_view;

class _ThemeSettingMobile extends StatelessWidget {
  final ThemeSettingViewModel viewModel;
  const _ThemeSettingMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    final StoryConfigProvider storyConfigProvider = context.read<StoryConfigProvider>();
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
              headline: tr("section.personalize"),
              tiles: [
                buildColorThemeTile(),
                buildThemeModeTile(context),
              ],
            ),
            SpSectionContents(
              headline: tr("section.font"),
              tiles: [
                ListTile(
                  title: Text(SpRouter.fontManager.datas.title),
                  leading: const Icon(Icons.font_download),
                  onTap: () {
                    Navigator.of(context).pushNamed(SpRouter.fontManager.path);
                  },
                ),
              ],
            ),
            SpSectionContents(
              headline: tr("section.story"),
              tiles: [
                buildLayoutTile(context, storyConfigProvider),
                buildSortTile(storyConfigProvider),
                // buildMaxLineTile(),
                buildDisableDatePicker(storyConfigProvider),
                buildPriorityStarredTile(storyConfigProvider),
                // buildShowChipTile(),
              ],
            ),
            SpSectionContents(
              headline: tr("section.advance"),
              tiles: [
                ListTile(
                  leading: const SizedBox(
                    height: 40,
                    child: Icon(Icons.settings_suggest),
                  ),
                  title: Text(SpRouter.bottomNavSetting.datas.subtitle),
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

  Widget buildPriorityStarredTile(StoryConfigProvider storyConfigProvider) {
    return ValueListenableBuilder<bool?>(
      valueListenable: storyConfigProvider.prioritiedNotifier,
      builder: (context, value, child) {
        bool prioritied = value ?? storyConfigProvider.storage.prioritied;
        return ListTile(
          leading: const Icon(Icons.favorite),
          title: Text(tr("tile.prioritize_starred.title")),
          onTap: () => storyConfigProvider.setPriorityStarred(!prioritied),
          trailing: Switch.adaptive(
            value: prioritied,
            onChanged: (value) {
              storyConfigProvider.setPriorityStarred(value);
            },
          ),
        );
      },
    );
  }

  Widget buildDisableDatePicker(StoryConfigProvider storyConfigProvider) {
    return ValueListenableBuilder<bool?>(
      valueListenable: storyConfigProvider.disableDatePickerNotifier,
      builder: (context, value, child) {
        bool disableDatePicker = value ?? storyConfigProvider.storage.disableDatePicker;
        return ListTile(
          leading: const Icon(Icons.date_range_outlined),
          title: Text(tr("tile.disable_date_picker.title")),
          onTap: () => storyConfigProvider.setDisableDatePicker(!disableDatePicker),
          trailing: Switch.adaptive(
            value: disableDatePicker,
            onChanged: (value) {
              storyConfigProvider.setDisableDatePicker(value);
            },
          ),
        );
      },
    );
  }

  Widget buildColorThemeTile() {
    return SpOverlayEntryButton(floatingBuilder: (context, callback) {
      return SpColorPicker(
        blackWhite: SpColorPicker.getBlackWhite(context),
        currentColor: context.read<ThemeProvider>().colorSeed(context),
        level: SpColorPickerLevel.one,
        onPickedColor: (color) async {
          callback();
          await Future.delayed(ConfigConstant.duration).then((value) async {
            await context.read<ThemeProvider>().updateColor(color, context);
          });
        },
      );
    }, childBuilder: (context, key, callback) {
      bool isSystemTheme = context.read<ThemeProvider>().themeMode == ThemeMode.system;
      bool hasDynamicColor = ThemeProvider.darkDynamic != null || ThemeProvider.lightDynamic != null;
      return ListTile(
        key: key,
        title: Text(tr("tile.color.title")),
        trailing: SizedBox(
          width: 48,
          child: SpColorItem(
            size: ConfigConstant.iconSize2,
            onPressed: null,
            selected: true,
            color: isSystemTheme
                ? Theme.of(context).colorScheme.primary
                : context.read<ThemeProvider>().colorSeed(context),
          ),
        ),
        onLongPress: () {
          if (isSystemTheme && hasDynamicColor) {
            showWarningColorDialog(context);
          } else {
            Navigator.of(context).pushNamed(SpRouter.initPickColor.path);
          }
        },
        onTap: () {
          if (isSystemTheme && hasDynamicColor) {
            showWarningColorDialog(context);
          } else {
            callback();
          }
        },
      );
    });
  }

  Future<OkCancelResult> showWarningColorDialog(BuildContext context) {
    return showOkAlertDialog(
      context: context,
      title: tr("alert.already_used_dynamic_color.title"),
      message: tr("alert.already_used_dynamic_color.message"),
      okLabel: tr("button.ok"),
    );
  }

  ListTile buildThemeModeTile(BuildContext context) {
    ThemeMode mode = context.read<ThemeProvider>().themeMode;
    return ListTile(
      title: SpCrossFade(
        firstChild: Text(TypeLocalization.themeMode(mode)),
        secondChild: Text(TypeLocalization.themeMode(mode)),
        showFirst: M3Color.of(context).brightness == Brightness.dark,
      ),
      trailing: SpThemeSwitcher(backgroundColor: Colors.transparent),
      onTap: () => SpThemeSwitcher.onLongPress(context),
      onLongPress: () => SpThemeSwitcher.onLongPress(context),
    );
  }

  Widget buildSortTile(StoryConfigProvider storyConfigProvider) {
    return ValueListenableBuilder<SortType?>(
      valueListenable: storyConfigProvider.sortTypeNotifier,
      builder: (context, value, child) {
        final sortType = value ?? storyConfigProvider.storage.sortType;
        return ListTile(
          leading: const SizedBox(height: 44, child: Icon(Icons.sort)),
          title: Text(tr("tile.sort.title")),
          subtitle: Text(sortType.title),
          onTap: () async {
            final sortTypeResult = await storyConfigProvider.showSortSelectorDialog(context);
            if (sortTypeResult != null) {
              storyConfigProvider.setSortType(sortTypeResult);
            }
          },
        );
      },
    );
  }

  Widget buildLayoutTile(
    BuildContext context,
    StoryConfigProvider storyConfigProvider,
  ) {
    String layoutTitle(SpListLayoutType type) {
      switch (type) {
        case SpListLayoutType.library:
          return tr("title.layout.types.library");
        case SpListLayoutType.diary:
          return tr("title.layout.types.diary");
        case SpListLayoutType.timeline:
          return tr("title.layout.types.timeline");
      }
    }

    return ListTile(
      leading: const SizedBox(height: 44, child: Icon(Icons.list_alt)),
      title: Text(tr("tile.layout.title")),
      subtitle: Text(layoutTitle(storyConfigProvider.storage.layoutType)),
      onTap: () async {
        SpListLayoutType? layoutTypeResult = await showConfirmationDialog(
          context: context,
          title: tr("tile.layout.title"),
          initialSelectedActionKey: storyConfigProvider.storage.layoutType,
          cancelLabel: MaterialLocalizations.of(context).cancelButtonLabel,
          actions: SpListLayoutType.values.map((e) {
            return AlertDialogAction(
              key: e,
              label: layoutTitle(e),
            );
          }).map((e) {
            return AlertDialogAction<SpListLayoutType>(
              key: e.key,
              isDefaultAction: e.key == storyConfigProvider.storage.layoutType,
              label: e.label,
            );
          }).toList(),
        );

        if (layoutTypeResult != storyConfigProvider.storage.layoutType && layoutTypeResult != null) {
          await storyConfigProvider.setLayoutType(layoutTypeResult).then((value) {
            Phoenix.rebirth(context);
          });
        }
      },
    );
  }
}
