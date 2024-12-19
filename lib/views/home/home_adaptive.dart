part of 'home_view.dart';

const double _indicatorHeight = 40;
const double _circleSize = 32;

class _HomeAdaptive extends StatelessWidget {
  const _HomeAdaptive(this.viewModel);

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: viewModel.months.length,
      child: _HomeScaffold(
        viewModel: viewModel,
        endDrawer: const _HomeEndDrawer(),
        appBar: buildAppBar(context),
        body: buildBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => viewModel.goToNewPage(context),
          child: const Icon(Icons.edit),
        ),
      ),
    );
  }

  SliverAppBar buildAppBar(BuildContext context) {
    return SliverAppBar(
      actions: const [SizedBox()],
      automaticallyImplyLeading: false,
      pinned: true,
      floating: false,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      backgroundColor: Theme.of(context).colorScheme.surface,
      collapsedHeight: viewModel.scrollInfo.getCollapsedHeight(context),
      expandedHeight: viewModel.scrollInfo.getExpandedHeight(context),
      flexibleSpace: HomeFlexibleSpaceBar(viewModel: viewModel, indicatorHeight: _indicatorHeight),
      bottom: TabBar(
        enableFeedback: true,
        tabAlignment: TabAlignment.start,
        isScrollable: true,
        indicatorAnimation: TabIndicatorAnimation.linear,
        labelColor: Theme.of(context).colorScheme.onPrimary,
        unselectedLabelColor: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 12.0),
        indicator: RoundedIndicator.simple(
          height: _indicatorHeight,
          color: Theme.of(context).colorScheme.primary,
        ),
        onTap: (index) => viewModel.scrollInfo.moveToMonthIndex(index),
        splashBorderRadius: BorderRadius.circular(_indicatorHeight / 2),
        tabs: viewModel.months.map((month) {
          return Container(
            height: _indicatorHeight,
            alignment: Alignment.center,
            child: Text(DateFormatService.MMM(DateTime(2000, month))),
          );
        }).toList(),
      ),
    );
  }

  SliverList buildBody() {
    return SliverList.builder(
      itemCount: viewModel.stories?.items.length ?? 0,
      itemBuilder: (context, index) {
        StoryDbModel? previousStory = index - 1 >= 0 ? viewModel.stories!.items[index - 1] : null;
        StoryDbModel story = viewModel.stories!.items[index];

        if (previousStory?.month != story.month) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Month(index: index, context: context, story: story),
              buildStoryTile(story),
            ],
          );
        } else {
          return buildStoryTile(story);
        }
      },
    );
  }

  Widget buildStoryTile(StoryDbModel story) {
    StoryContentDbModel? lastChangedStory = story.changes.lastOrNull;
    String? displayBody = lastChangedStory != null ? viewModel.getDisplayBodyFor(lastChangedStory) : null;

    return StoryTile(
      circleSize: _circleSize,
      story: story,
      lastChangedStory: lastChangedStory,
      displayBody: displayBody,
      viewModel: viewModel,
    );
  }
}
