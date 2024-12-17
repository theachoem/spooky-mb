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
      child: Scaffold(
        endDrawer: const HomeEndDrawer(),
        body: viewModel.stories?.items.isNotEmpty == true ? buildBody() : const Text("No data"),
        floatingActionButton: FloatingActionButton(
          onPressed: () => viewModel.goToNewPage(context),
          child: const Icon(Icons.edit),
        ),
      ),
    );
  }

  Widget buildBody() {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          buildAppBar(context, innerBoxIsScrolled),
        ];
      },
      body: Stack(
        children: [
          buildTimelineVerticleDivider(),
          buildStoryList(),
        ],
      ),
    );
  }

  SliverAppBar buildAppBar(BuildContext context, bool innerBoxIsScrolled) {
    return SliverAppBar(
      actions: const [SizedBox()],
      automaticallyImplyLeading: false,
      pinned: true,
      floating: false,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      backgroundColor: Theme.of(context).colorScheme.surface,
      collapsedHeight: kToolbarHeight + MediaQuery.of(context).padding.top,
      expandedHeight: kToolbarHeight + 72 + MediaQuery.of(context).padding.top,
      flexibleSpace: HomeFlexibleSpaceBar(viewModel: viewModel, indicatorHeight: _indicatorHeight),
      bottom: TabBar(
        enableFeedback: true,
        tabAlignment: TabAlignment.start,
        isScrollable: true,
        indicatorAnimation: TabIndicatorAnimation.linear,
        labelColor: Theme.of(context).colorScheme.onPrimary,
        unselectedLabelColor: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 8.0),
        indicator: RoundedIndicator.simple(
          height: _indicatorHeight,
          color: Theme.of(context).colorScheme.primary,
        ),
        onTap: null,
        splashBorderRadius: BorderRadius.circular(_indicatorHeight / 2),
        tabs: viewModel.months.map((month) {
          return Container(
            height: _indicatorHeight,
            alignment: Alignment.center,
            child: Text(viewModel.fromIndexToMonth(month - 1)),
          );
        }).toList(),
      ),
    );
  }

  Widget buildStoryList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      itemCount: viewModel.stories?.items.length ?? 0,
      itemBuilder: (context, index) {
        StoryDbModel? previousStory = index - 1 >= 0 ? viewModel.stories!.items[index - 1] : null;
        StoryDbModel story = viewModel.stories!.items[index];

        final lastChange = story.changes.lastOrNull;
        final displayBody = lastChange != null ? viewModel.getDisplayBodyFor(lastChange) : null;

        final tile = StoryTile(
          circleSize: _circleSize,
          story: story,
          lastChange: lastChange,
          displayBody: displayBody,
          viewModel: viewModel,
        );

        if (previousStory?.month != story.month) {
          return buildWithMonth(
            index: index,
            context: context,
            story: story,
            child: tile,
          );
        } else {
          return tile;
        }
      },
    );
  }

  Widget buildWithMonth({
    required int index,
    required BuildContext context,
    required StoryDbModel story,
    required StoryTile child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (index != 0) const SizedBox(height: 8.0),
        Container(
          width: 48.0,
          margin: const EdgeInsets.only(left: 8.0),
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            alignment: Alignment.center,
            child: Text(viewModel.fromIndexToMonth(story.month - 1)),
          ),
        ),
        child,
      ],
    );
  }

  Widget buildTimelineVerticleDivider() {
    return const Positioned(
      top: 0,
      bottom: 0,
      left: 16.0 + _circleSize / 2,
      child: VerticalDivider(
        width: 1,
      ),
    );
  }
}
