part of 'home_view.dart';

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
    if (viewModel.stories == null) {
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 16.0)
          .copyWith(left: MediaQuery.of(context).padding.left, right: MediaQuery.of(context).padding.right),
      sliver: SliverList.builder(
        itemCount: viewModel.stories?.items.length ?? 0,
        itemBuilder: (context, index) {
          StoryDbModel story = viewModel.stories!.items[index];

          return StoryListenerBuilder(
            key: ValueKey(story.id),
            story: story,
            onChanged: (updatedStory) {
              // content already rendered from builder to UI, no need to refresh UI with [notifyListeners];
              viewModel.stories = viewModel.stories?.replaceElement(updatedStory);
            },
            onDeleted: () async {
              viewModel.stories = viewModel.stories?.removeElement(story);
              viewModel.notifyListeners();
            },
            builder: (context, story) {
              return StoryTileListItem(
                showYear: false,
                index: index,
                stories: viewModel.stories!,
                onTap: () => viewModel.goToViewPage(context, story),
                onToggleStarred: () => viewModel.toggleStarred(story),
              );
            },
          );
        },
      ),
    );
  }
}
