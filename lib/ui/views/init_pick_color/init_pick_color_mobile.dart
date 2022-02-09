part of init_pick_color_view;

class _InitPickColorMobile extends StatelessWidget {
  final InitPickColorViewModel viewModel;
  const _InitPickColorMobile(this.viewModel);

  static const Map<String, int> hexagonIndexsMap = {
    // -2
    "-2, 0": 0,
    "-2, 1": 1,
    "-2, 2": 2,
    // -1
    "-1, -1": 3,
    "-1, 0": 4,
    "-1, 1": 5,
    "-1, 2": 6,
    // 0
    "0, -2": 7,
    "0, -1": 8,
    "0, 0": 9,
    "0, 1": 10,
    "0, 2": 11,
    // 1
    "1, -2": 12,
    "1, -1": 13,
    "1, 0": 14,
    "1, 1": 15,
    // 2
    "2, -2": 16,
    "2, -1": 17,
    "2, 0": 18,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: MorphingAppBar(
        elevation: 0.0,
        leading: SpPopButton(),
        title: Text(
          "What's your favorite color?",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          SpThemeSwitcher(backgroundColor: Colors.transparent),
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(ConfigConstant.margin2),
          child: HexagonGrid(
            hexType: HexagonType.FLAT,
            depth: 2,
            buildTile: (coordinates) {
              return buildColorItem(coordinates, context);
            },
          ),
        ),
      ),
    );
  }

  HexagonWidgetBuilder buildColorItem(
    Coordinates coordinates,
    BuildContext context,
  ) {
    Color color = colorByCoordinates(coordinates);
    bool selected = App.of(context)?.currentSeedColor == color;
    return HexagonWidgetBuilder(
      padding: 0.0,
      cornerRadius: 0.0,
      elevation: 0.0,
      color: Colors.transparent,
      child: SpTapEffect(
        effects: [SpTapEffectType.scaleDown],
        onTap: () => App.of(context)?.updateColor(color),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: AnimatedContainer(
            duration: ConfigConstant.fadeDuration,
            transform: Matrix4.identity()..scale(selected ? 1.1 : 1.0),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            alignment: Alignment.center,
            transformAlignment: Alignment.center,
            child: SpCrossFade(
              showFirst: selected,
              secondChild: SizedBox(width: ConfigConstant.iconSize2),
              firstChild: Icon(
                Icons.check,
                color: M3Color.of(context).onPrimary,
                size: ConfigConstant.iconSize2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color colorByCoordinates(Coordinates coordinates) {
    String _key = "${coordinates.q}, ${coordinates.r}";
    Color color = hexagonIndexsMap.containsKey(_key) ? materialColors[hexagonIndexsMap[_key]!] : Colors.transparent;
    return color;
  }
}
