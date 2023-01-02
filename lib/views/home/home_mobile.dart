part of home_view;

class _HomeMobile extends StatelessWidget {
  final HomeViewModel viewModel;

  const _HomeMobile(
    this.viewModel, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrimaryScrollController(
      controller: viewModel.scrollController,
      child: DefaultTabController(
        length: viewModel.tabs.length,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: NestedScrollView(
            controller: viewModel.scrollController,
            headerSliverBuilder: headerSliverBuilder,
            body: buildLayouts(),
          ),
        ),
      ),
    );
  }

  Widget buildLayouts() {
    switch (viewModel.layoutType) {
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
      overridedLayout: SpListLayoutType.diary,
      queryOptions: StoryQueryOptionsModel(
        type: PathType.docs,
        year: viewModel.year,
        sortBy: viewModel.tabs.isNotEmpty ? viewModel.tabs.first.overridedSortType : null,
      ),
    );
  }

  Widget buildTabLayout() {
    return SpTabView(
      listener: (controller) {
        listener(
          (controller.animation?.value.round() ?? controller.index),
        );
      },
      children: List.generate(
        viewModel.tabs.length,
        (index) {
          switch (viewModel.layoutType) {
            case SpListLayoutType.library:
              final tag = viewModel.tabs[index].tag!;
              bool starredList = tag.title == "*";
              bool allList = tag.id == 0 && !starredList;

              String? tagId;
              if (!starredList && !allList) tagId = tag.id.toString();

              return StoryQueryList(
                hasDifferentYear: false,
                overridedLayout: viewModel.tabs[index].overridedLayout,
                queryOptions: StoryQueryOptionsModel(
                  type: PathType.docs,
                  year: viewModel.year,
                  tag: tagId,
                  starred: starredList ? true : null,
                  sortBy: viewModel.tabs[index].overridedSortType,
                ),
              );
            case SpListLayoutType.diary:
              return StoryQueryList(
                hasDifferentYear: false,
                overridedLayout: viewModel.tabs[index].overridedLayout,
                shouldReload: () async {
                  if (viewModel.tabs[index].overridedLayout != viewModel.layoutType) {
                    // let [notifyListeners] do the reload
                    viewModel.updateLayout(index, viewModel.layoutType);
                    return false;
                  } else {
                    return true;
                  }
                },
                queryOptions: StoryQueryOptionsModel(
                  type: PathType.docs,
                  year: viewModel.year,
                  month: index + 1,
                  sortBy: viewModel.tabs[index].overridedSortType,
                ),
              );
            case SpListLayoutType.timeline:
              throw Exception("Timeline shouldn't has tab");
          }
        },
      ),
    );
  }

  List<Widget> headerSliverBuilder(
    BuildContext context,
    bool innerBoxIsScrolled,
  ) {
    return [
      buildAppBar(context),
    ];
  }

  Widget buildAppBar(BuildContext context) {
    String storyCounter;

    return HomeAppBar(
      docsCountNotifier: viewModel.docsCountNotifier,
      subtitle: (int docsCount) {
        storyCounter = plural("plural.story", docsCount);
        return "${viewModel.year} - $storyCounter";
      },
      tabController: DefaultTabController.of(context),
      viewModel: viewModel,
      onReorder: (int oldIndex, int newIndex) {
        viewModel.reorder(
          oldIndex,
          newIndex,
          context,
        );
      },
      reorderable: (int index) {
        return index != 0 && index != viewModel.tabs.length - 1;
      },
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
      useDefaultTabStyle: viewModel.layoutType == SpListLayoutType.library,
      tabs: viewModel.tabs,
    );
  }

  void listener(int index) {
    switch (viewModel.layoutType) {
      case SpListLayoutType.diary:
        viewModel.onMonthChange(index + 1);
        break;
      case SpListLayoutType.library:
        TagDbModel tag = viewModel.tabs[index].tag!;
        String? tagId;

        if (tag.id == 0 && tag.title == "*") {
          tagId = "*";
        } else if (tag.id == 0) {
          tagId = null;
        } else {
          tagId = tag.id.toString();
        }

        viewModel.onTagChange(tagId);
        break;
      case SpListLayoutType.timeline:
        break;
    }
  }
}
