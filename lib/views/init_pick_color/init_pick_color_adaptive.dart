part of init_pick_color_view;

class _InitPickColorAdaptive extends StatelessWidget {
  final InitPickColorViewModel viewModel;
  const _InitPickColorAdaptive(this.viewModel);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: SizedBox(height: MediaQuery.of(context).padding.bottom),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: viewModel.showNextButton,
        child: FutureBuilder<int>(
          future: viewModel.completer.future,
          builder: (context, snapshot) {
            return Visibility(
              visible: snapshot.data == 1,
              child: SpFadeIn(
                duration: ConfigConstant.duration * 2,
                child: SpButton(
                  label: tr("button.done"),
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(SpRouter.main.path, (_) => false);
                  },
                ),
              ),
            );
          },
        ),
      ),
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SpExpandedAppBar(
            fallbackRouter: SpRouter.initPickColor,
            expandedHeight: 200,
            collapsedHeight: 200,
            backgroundColor: M3Color.of(context).background,
            subtitleIcon: Icons.color_lens_outlined,
            actions: [
              SpThemeSwitcher(backgroundColor: Colors.transparent),
            ],
          ),
          buildBody(width),
        ],
      ),
    );
  }

  Widget buildBody(double width) {
    return SliverFillRemaining(child: LayoutBuilder(builder: (context, constraint) {
      return Stack(
        children: [
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Divider(height: 1),
          ),
          Container(
            height: constraint.maxHeight,
            constraints: constraint,
            alignment: Alignment.center,
            padding: ThemeProvider.hasDynamicColor
                ? const EdgeInsets.only(top: kToolbarHeight)
                : const EdgeInsets.only(bottom: kToolbarHeight),
            child: Wrap(
              children: [
                buildPickerWrapper(width),
              ],
            ),
          ),
          if (ThemeProvider.hasDynamicColor)
            Positioned(
              top: ConfigConstant.margin2,
              left: 0,
              right: 0,
              child: SpFadeIn(
                duration: ConfigConstant.duration,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SwitchListTile.adaptive(
                    shape: RoundedRectangleBorder(
                      borderRadius: ConfigConstant.circlarRadius2,
                      side: BorderSide(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    title: Text(tr("tile.dynamic_color.title")),
                    subtitle: Text(tr("tile.dynamic_color.subtitle")),
                    value: Provider.of<ThemeProvider>(context, listen: false).themeMode == ThemeMode.system,
                    onChanged: (bool value) {
                      final provider = Provider.of<ThemeProvider>(context, listen: false);
                      provider.setThemeMode(value
                          ? ThemeMode.system
                          : provider.isDarkMode(context)
                              ? ThemeMode.dark
                              : ThemeMode.light);
                    },
                  ),
                ),
              ),
            ),
        ],
      );
    }));
  }

  Widget buildPickerWrapper(double width) {
    return FutureBuilder<int>(
      future: viewModel.completer.future,
      builder: (context, snapshot) {
        return Visibility(
          visible: snapshot.data == 1,
          child: SpFadeIn(
            duration: ConfigConstant.fadeDuration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildColorPicker(context, width),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildColorPicker(BuildContext context, double width) {
    ThemeProvider themeProvider = context.read<ThemeProvider>();
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: M3Color.of(context).background,
          border: Border.all(color: M3Color.of(context).onBackground, width: 6.0),
          shape: BoxShape.circle,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size(width) / 2),
          child: BubbleLens(
            duration: ConfigConstant.fadeDuration,
            width: size(width),
            height: size(width),
            widgets: materialColors.map((color) {
              bool selected =
                  themeProvider.useDynamicColor ? false : themeProvider.colorSeed(context).value == color.value;
              return SpTapEffect(
                effects: const [
                  SpTapEffectType.scaleDown,
                  SpTapEffectType.touchableOpacity,
                ],
                onTap: () => themeProvider.updateColor(color, context),
                child: AnimatedContainer(
                  duration: ConfigConstant.fadeDuration,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [color, color.lighten()]),
                  ),
                  alignment: Alignment.center,
                  transformAlignment: Alignment.center,
                  child: SpCrossFade(
                    showFirst: selected,
                    duration: ConfigConstant.duration * 3,
                    secondChild: const SizedBox(width: ConfigConstant.iconSize3),
                    firstChild: Icon(
                      Icons.check,
                      color: M3Color.of(context).onPrimary,
                      size: ConfigConstant.iconSize3,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  double size(double width) => min(width - 100, 250);
}
