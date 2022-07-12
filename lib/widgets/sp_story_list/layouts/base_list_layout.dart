part of sp_story_list;

abstract class _BaseSpListLayout extends StatelessWidget {
  _BaseSpListLayout({
    Key? key,
    required this.options,
  }) : super(key: key) {
    _stories = options.stories;
  }

  final _ListLayoutOptions options;
  late final List<StoryDbModel> _stories;

  bool get gridLayout => false;
  StoryDbModel? storyAt(List<StoryDbModel> stories, int index) {
    if (stories.isNotEmpty) {
      if (index >= 0 && stories.length > index) {
        return stories[index];
      }
    }
    return null;
  }

  Widget buildSeperatorBuilder() => const SizedBox.shrink();
  Widget buildTile({
    required BuildContext context,
    required int index,
    required StoryDbModel story,
    required StoryDbModel? previousStory,
  }) {
    return SpStoryTile(
      gridLayout: gridLayout,
      story: story,
      onRefresh: () async {},
    );
  }

  @override
  Widget build(BuildContext context) {
    if (gridLayout) {
      return MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: ConfigConstant.margin0,
        crossAxisSpacing: ConfigConstant.margin0,
        itemCount: _stories.length,
        itemBuilder: (context, index) {
          StoryDbModel story = storyAt(_stories, index)!;
          StoryDbModel? previousStory = storyAt(_stories, index - 1);
          return buildTile(
            index: index,
            context: context,
            story: story,
            previousStory: previousStory,
          );
        },
      );
    } else {
      return ListView.separated(
        itemCount: _stories.length,
        separatorBuilder: (context, index) {
          return buildSeperatorBuilder();
        },
        itemBuilder: (context, index) {
          StoryDbModel story = storyAt(_stories, index)!;
          StoryDbModel? previousStory = storyAt(_stories, index - 1);
          return buildTile(
            index: index,
            context: context,
            story: story,
            previousStory: previousStory,
          );
        },
      );
    }
  }
}
