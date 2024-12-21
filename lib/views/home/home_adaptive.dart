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
        endDrawer: _HomeEndDrawer(viewModel),
        appBar: HomeAppBar(viewModel: viewModel),
        body: buildBody(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () => viewModel.goToNewPage(context),
          child: const Icon(Icons.edit),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: MediaQuery.of(context).padding.horizontal),
      sliver: SliverList.builder(
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
      ),
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
