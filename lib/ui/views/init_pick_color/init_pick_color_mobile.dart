part of init_pick_color_view;

class _InitPickColorMobile extends StatelessWidget {
  final InitPickColorViewModel viewModel;
  const _InitPickColorMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    List<MaterialColor> first = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
    ];
    List<MaterialColor> second = [
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
    ];
    List<MaterialColor> third = [
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
    ];

    return Scaffold(
      backgroundColor: M3Color.of(context).primary,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: SpPopButton(),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(first.length, (index) {
                return buildColorContainer(
                  first[index],
                  index,
                  context,
                );
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(second.length, (index) {
                return buildColorContainer(
                  second[index],
                  index + first.length,
                  context,
                );
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(third.length, (index) {
                return buildColorContainer(
                  third[index],
                  index + first.length + second.length,
                  context,
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        alignment: Alignment.bottomCenter,
        child: SpButton(
          label: "Done",
          backgroundColor: M3Color.of(context).onPrimary,
          foregroundColor: M3Color.of(context).primary,
          onTap: () {
            Navigator.of(context).pushNamedAndRemoveUntil(SpRouteConfig.main, (_) => false);
          },
        ),
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + ConfigConstant.margin2),
      ),
    );
  }

  Widget buildColorContainer(Color color, int index, BuildContext context) {
    return _ColorItem(
      color: color,
      index: index,
      selected: App.of(context)?.currentSeedColor == color,
      onTap: () {
        App.of(context)?.updateColor(color);
      },
    );
  }
}

class _ColorItem extends StatefulWidget {
  const _ColorItem({
    Key? key,
    required this.color,
    required this.index,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  final Color color;
  final int index;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_ColorItem> createState() => _ColorItemState();
}

class _ColorItemState extends State<_ColorItem> {
  double size = 0.5;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ValueKey(widget.color),
      onVisibilityChanged: (VisibilityInfo info) {
        setState(() {
          size = max(0.5, info.visibleFraction);
        });
      },
      child: SpTapEffect(
        effects: [SpTapEffectType.scaleDown],
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: ConfigConstant.duration,
          curve: Curves.ease,
          transformAlignment: Alignment.center,
          transform: Matrix4.identity()..scale(widget.index.isOdd ? size : 0.5),
          width: ConfigConstant.objectHeight5,
          height: ConfigConstant.objectHeight5,
          margin: EdgeInsets.all(ConfigConstant.margin0),
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.selected ? M3Color.of(context).onPrimary : Colors.transparent,
              width: 4,
            ),
          ),
        ),
      ),
    );
  }
}
