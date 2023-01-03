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
                buildLayoutTile(context),
                buildSortTile(context),
                // buildMaxLineTile(),
                buildPriorityStarredTile(),
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

  Consumer<StoryListConfigurationProvider> buildPriorityStarredTile() {
    return Consumer<StoryListConfigurationProvider>(
      builder: (context, provider, child) {
        return ListTile(
          leading: const Icon(Icons.favorite),
          title: Text(tr("tile.prioritize_starred.title")),
          onTap: () => provider.setPriorityStarred(!provider.prioritied),
          trailing: Switch.adaptive(
            value: provider.prioritied,
            onChanged: (value) {
              provider.setPriorityStarred(value);
            },
          ),
        );
      },
    );
  }

  @Deprecated("Doesn't use anymore")
  Consumer<StoryListConfigurationProvider> buildShowChipTile() {
    return Consumer<StoryListConfigurationProvider>(
      builder: (context, provider, child) {
        return ListTile(
          leading: const Icon(Icons.memory),
          title: Text(tr("tile.show_story_chip.title")),
          onTap: () => provider.setShouldShowChip(!provider.shouldShowChip),
          trailing: Switch.adaptive(
            value: provider.shouldShowChip,
            onChanged: (value) {
              provider.setShouldShowChip(value);
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
        currentColor: context.read<ThemeProvider>().colorSeed,
        level: SpColorPickerLevel.one,
        onPickedColor: (color) async {
          callback();
          await Future.delayed(ConfigConstant.duration).then((value) async {
            await context.read<ThemeProvider>().updateColor(color);
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
            color: isSystemTheme ? Theme.of(context).colorScheme.primary : context.read<ThemeProvider>().colorSeed,
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

  Widget buildSortTile(BuildContext context) {
    return Consumer<StoryListConfigurationProvider>(builder: (context, provider, child) {
      return ListTile(
        leading: const Icon(Icons.sort),
        title: Text(tr("tile.sort.title")),
        onTap: () async {
          final sortTypeResult = await provider.showSortSelectorDialog(context);
          if (sortTypeResult != null) {
            provider.setSortType(sortTypeResult);
          }
        },
      );
    });
  }

  Widget buildLayoutTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.list_alt),
      title: Text(tr("tile.layout.title")),
      onTap: () async {
        SpListLayoutType layoutType = await SpListLayoutBuilder.get();

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

        SpListLayoutType? layoutTypeResult = await showConfirmationDialog(
          context: context,
          title: tr("tile.layout.title"),
          initialSelectedActionKey: layoutType,
          // ignore: use_build_context_synchronously
          cancelLabel: MaterialLocalizations.of(context).cancelButtonLabel,
          actions: SpListLayoutType.values.map((e) {
            return AlertDialogAction(
              key: e,
              label: layoutTitle(e),
            );
          }).map((e) {
            return AlertDialogAction<SpListLayoutType>(
              key: e.key,
              isDefaultAction: e.key == layoutType,
              label: e.label,
            );
          }).toList(),
        );

        if (layoutTypeResult != layoutType && layoutTypeResult != null) {
          await SpListLayoutBuilder.set(layoutTypeResult).then((value) {
            Phoenix.rebirth(context);
          });
        }
      },
    );
  }
}
