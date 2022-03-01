part of init_pick_color_view;

class _InitPickColorMobile extends StatelessWidget {
  final InitPickColorViewModel viewModel;
  const _InitPickColorMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: MorphingAppBar(
        systemOverlayStyle: M3Color.systemOverlayStyleFromBg(M3Color.of(context).background),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: buildTitle(),
        actions: [
          SpThemeSwitcher(backgroundColor: Colors.transparent),
          SpIconButton(
            icon: Icon(Icons.clear),
            onPressed: () => Navigator.maybePop(context),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + ConfigConstant.margin2),
        child: Builder(builder: (context) {
          return SpButton(
            label: "Done",
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(SpRouteConfig.main, (_) => false);
            },
          );
        }),
      ),
      body: FutureBuilder<int>(
        future: Future.delayed(ConfigConstant.duration ~/ 2).then((value) => 1),
        builder: (context, snapshot) {
          var selected = snapshot.data == 1;
          return AnimatedOpacity(
            duration: ConfigConstant.duration,
            opacity: selected ? 1.0 : 0.0,
            child: AnimatedContainer(
              curve: Curves.ease,
              duration: ConfigConstant.fadeDuration,
              transform: Matrix4.identity()..translate(0.0, selected ? 0.0 : 4.0),
              child: buildColorPicker(
                context,
                width,
              ),
            ),
          );
        },
      ),
    );
  }

  FutureBuilder<int> buildTitle() {
    return FutureBuilder(
      future: Future.delayed(ConfigConstant.duration).then((value) => 1),
      builder: (context, snapshot) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ScrollPhysics(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "What's your ",
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
              SpCrossFade(
                showFirst: snapshot.data == 1,
                duration: ConfigConstant.duration,
                firstChild: Text(
                  "favorite color?",
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                ),
                secondChild: Text(
                  "",
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildColorPicker(BuildContext context, double width) {
    ColorSeedProvider colorSeedProvider = context.read<ColorSeedProvider>();
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
              bool selected = colorSeedProvider.currentSeedColor == color;
              return SpTapEffect(
                effects: [SpTapEffectType.scaleDown],
                onTap: () => colorSeedProvider.updateColor(color),
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
                    secondChild: SizedBox(width: ConfigConstant.iconSize3),
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
