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
      TagDbModel.fromIDTitle(0, tr("tag.all")),
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
    return PrimaryScrollController(
      controller: widget.viewModel.scrollController,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: NestedScrollView(
          controller: widget.viewModel.scrollController,
          headerSliverBuilder: headerSliverBuilder,
          body: buildLayouts(),
        ),
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
      hasDifferentYear: false,
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
        listener(
          (controller.animation?.value.round() ?? controller.index),
        );
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
                hasDifferentYear: false,
                queryOptions: StoryQueryOptionsModel(
                  type: PathType.docs,
                  year: widget.viewModel.year,
                  tag: tag,
                  starred: starredList ? true : null,
                ),
              );
            case SpListLayoutType.diary:
              return StoryQueryList(
                hasDifferentYear: false,
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
    String storyCounter;

    return HomeAppBar(
      docsCountNotifier: widget.viewModel.docsCountNotifier,
      subtitle: (int docsCount) {
        storyCounter = plural("plural.story", docsCount);
        return "${widget.viewModel.year} - $storyCounter";
      },
      tabController: controller,
      viewModel: widget.viewModel,
      onTap: (index) {
        listener(index);
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

  void listener(int index) {
    switch (layoutType) {
      case SpListLayoutType.diary:
        widget.viewModel.onMonthChange(index + 1);
        break;
      case SpListLayoutType.library:
        TagDbModel tag = tags[index];
        String? tagId;

        if (tag.id == 0 && tag.title == "*") {
          tagId = "*";
        } else if (tag.id == 0) {
          tagId = null;
        } else {
          tagId = tag.id.toString();
        }

        widget.viewModel.onTagChange(tagId);
        break;
      case SpListLayoutType.timeline:
        break;
    }
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
