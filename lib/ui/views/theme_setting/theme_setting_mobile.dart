part of theme_setting_view;

class _ThemeSettingMobile extends StatelessWidget {
  final ThemeSettingViewModel viewModel;
  const _ThemeSettingMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        leading: SpPopButton(),
        title: Text(
          "Theme",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: ListView(
        children: [
          ...ListTile.divideTiles(context: context, tiles: [
            SpOverlayEntryButton(floatingBuilder: (context, callback) {
              return SpColorPicker(
                blackWhite: SpColorPicker.getBlackWhite(context),
                currentColor: M3Color.currentPrimaryColor,
                onPickedColor: (color) async {
                  callback();
                  await Future.delayed(ConfigConstant.duration);
                  await App.of(context)?.updateColor(color);
                },
              );
            }, childBuilder: (context, callback) {
              return ListTile(
                title: Text("Color"),
                trailing: SizedBox(
                  width: 48,
                  child: SpColorItem(
                    size: ConfigConstant.iconSize2,
                    onPressed: null,
                    selected: true,
                    color: M3Color.currentPrimaryColor,
                  ),
                ),
                onTap: () {
                  callback();
                },
              );
            }),
            ListTile(
              title: SpCrossFade(
                firstChild: Text(InitialTheme.of(context)?.mode.name.capitalize ?? ""),
                secondChild: Text(InitialTheme.of(context)?.mode.name.capitalize ?? ""),
                showFirst: M3Color.of(context).brightness == Brightness.dark,
              ),
              trailing: SpThemeSwitcher(backgroundColor: Colors.transparent),
              onTap: () => SpThemeSwitcher?.onPress(context),
              onLongPress: () => SpThemeSwitcher?.onLongPress(context),
            )
          ])
        ],
      ),
    );
  }
}
