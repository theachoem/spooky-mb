part of home_view;

class _HomeMobile extends StatefulWidget {
  final HomeViewModel viewModel;

  const _HomeMobile(
    this.viewModel, {
    Key? key,
  }) : super(key: key);

  @override
  State<_HomeMobile> createState() => _HomeMobileState();
}

class _HomeMobileState extends State<_HomeMobile> with SingleTickerProviderStateMixin {
  late TabController controller;
  late SpListLayoutType layoutType;
  late List<TagDbModel> tags;

  // doesn't needed in single list
  // {
  //   1: reloaderPage1(),
  //   .
  //   .
  //   12: reloaderPage12(),
  // }
  Map<int, void Function()> listReloaderMap = {};

  @override
  void initState() {
    super.initState();
    tags = [
      TagDbModel.fromIDTitle(0, "*"),
      ...Global.instance.tags,
      TagDbModel.fromIDTitle(0, "All"),
    ];

    layoutType = Global.instance.layoutType;
    switch (layoutType) {
      case SpListLayoutType.library:
        controller = TabController(
          length: tags.length,
          vsync: this,
          initialIndex: 0,
        );
        break;
      case SpListLayoutType.diary:
        controller = TabController(length: 12, vsync: this, initialIndex: widget.viewModel.month - 1);
        break;
      case SpListLayoutType.timeline:
        controller = TabController(length: 1, vsync: this, initialIndex: 0);
        break;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: widget.viewModel.scrollController,
        headerSliverBuilder: headerSliverBuilder,
        body: buildLayouts(),
      ),
    );
  }

  Widget buildLayouts() {
    switch (layoutType) {
      case SpListLayoutType.timeline:
        return buildSingleLayout();
      case SpListLayoutType.library:
      case SpListLayoutType.diary:
        return buildTabLayout();
    }
  }

  Widget buildSingleLayout() {
    return StoryQueryList(
      queryOptions: StoryQueryOptionsModel(
        type: PathType.docs,
        year: widget.viewModel.year,
      ),
    );
  }

  Widget buildTabLayout() {
    return SpTabView(
      controller: controller,
      listener: (controller) {
        switch (layoutType) {
          case SpListLayoutType.library:
          case SpListLayoutType.timeline:
            break;
          case SpListLayoutType.diary:
            // set reloader on listen to tabs
            int monthIndex = (controller.animation?.value.round() ?? controller.index) + 1;
            widget.viewModel.onMonthChange(monthIndex);
            break;
        }
      },
      children: List.generate(
        controller.length,
        (index) {
          switch (layoutType) {
            case SpListLayoutType.library:
              bool starredList = tags[index].title == "*";
              bool allList = tags[index].id == 0 && !starredList;

              String? tag;
              if (!starredList && !allList) tag = tags[index].id.toString();

              return StoryQueryList(
                queryOptions: StoryQueryOptionsModel(
                  type: PathType.docs,
                  year: widget.viewModel.year,
                  tag: tag,
                  starred: starredList ? true : null,
                ),
              );
            case SpListLayoutType.diary:
              return StoryQueryList(
                queryOptions: StoryQueryOptionsModel(
                  type: PathType.docs,
                  year: widget.viewModel.year,
                  month: index + 1,
                ),
              );
            case SpListLayoutType.timeline:
              throw Exception("Timeline shouldn't has tab");
          }
        },
      ),
    );
  }

  List<Widget> headerSliverBuilder(context, scroll) {
    return [
      buildAppBar(),
    ];
  }

  Widget buildAppBar() {
    return HomeAppBar(
      subtitle: "${widget.viewModel.year} - ${widget.viewModel.docsCount} Stories",
      tabController: controller,
      viewModel: widget.viewModel,
      onTap: (index) {
        switch (layoutType) {
          case SpListLayoutType.diary:
            widget.viewModel.onMonthChange(index + 1);
            break;
          case SpListLayoutType.library:
          case SpListLayoutType.timeline:
            break;
        }
        // if (index == controller.index) {
        //   PrimaryScrollController.of(context)?.animateTo(
        //     0,
        //     duration: ConfigConstant.duration * 5,
        //     curve: Curves.easeInOutQuad,
        //   );
        // }
      },
      useDefaultTabStyle: layoutType == SpListLayoutType.library,
      tabLabels: tabLabels,
    );
  }

  List<String> get tabLabels {
    switch (layoutType) {
      case SpListLayoutType.diary:
        return List.generate(
          12,
          (index) {
            return DateFormatHelper.toNameOfMonth().format(
              DateTime(2020, index + 1),
            );
          },
        );
      case SpListLayoutType.library:
        return tags.map((e) => e.title).toList();
      case SpListLayoutType.timeline:
        return [
          "Exception",
        ];
    }
  }
}
