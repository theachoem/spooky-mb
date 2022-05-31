part of init_pick_color_view;

class _InitPickColorMobile extends StatelessWidget {
  final InitPickColorViewModel viewModel;
  const _InitPickColorMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: SpSingleButtonBottomNavigation(
        buttonLabel: "Next",
        show: viewModel.showNextButton,
        onTap: () {
          Navigator.of(context).pushNamed(
            SpRouter.restore.path,
            arguments: const RestoreArgs(
              showSkipButton: true,
            ),
          );
        },
      ),
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SpExpandedAppBar(
            expandedHeight: 200,
            collapsedHeight: 200,
            backgroundColor: M3Color.of(context).background,
            subtitleIcon: Icons.color_lens_outlined,
            actions: [
              SpThemeSwitcher(backgroundColor: Colors.transparent),
            ],
          ),
          SliverFillRemaining(child: LayoutBuilder(builder: (context, constraint) {
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
                  padding:
                      ThemeProvider.hasDynamicColor ? const EdgeInsets.only(top: kToolbarHeight + 16) : EdgeInsets.zero,
                  child: Wrap(
                    children: [
                      buildPickerWrapper(width),
                    ],
                  ),
                ),
                if (ThemeProvider.hasDynamicColor)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: SwitchListTile.adaptive(
                      title: const Text("Dynamic color"),
                      subtitle: const Text("Use colors base on your system."),
                      value: Provider.of<ThemeProvider>(context, listen: false).themeMode == ThemeMode.system,
                      onChanged: (bool value) {
                        final provider = Provider.of<ThemeProvider>(context, listen: false);
                        provider.setThemeMode(value
                            ? ThemeMode.system
                            : provider.isDarkMode()
                                ? ThemeMode.dark
                                : ThemeMode.light);
                      },
                    ),
                  ),
              ],
            );
          })),
        ],
      ),
    );
  }

  Widget buildPickerWrapper(double width) {
    return FutureBuilder<int>(
      future: Future.delayed(ConfigConstant.fadeDuration).then((value) => 1),
      builder: (context, snapshot) {
        var selected = snapshot.data == 1;
        return AnimatedOpacity(
          duration: ConfigConstant.duration,
          opacity: selected ? 1.0 : 0.0,
          child: AnimatedContainer(
            curve: Curves.ease,
            duration: ConfigConstant.fadeDuration,
            transform: Matrix4.identity()..translate(0.0, selected ? 0.0 : 4.0),
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
              bool selected = themeProvider.useDynamicColor ? false : themeProvider.colorSeed.value == color.value;
              return SpTapEffect(
                effects: const [
                  SpTapEffectType.scaleDown,
                  SpTapEffectType.touchableOpacity,
                ],
                onTap: () => themeProvider.updateColor(color),
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
