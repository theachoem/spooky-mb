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
  bool get separatorOnTop => true;

  StoryDbModel? storyAt(List<StoryDbModel> stories, int index) {
    if (stories.isNotEmpty) {
      if (index >= 0 && stories.length > index) {
        return stories[index];
      }
    }
    return null;
  }

  Widget buildSeperatorBuilder(BuildContext context, int index) {
    return const SizedBox(height: ConfigConstant.margin2);
  }

  Widget buildTile({
    required BuildContext context,
    required int index,
    required StoryDbModel story,
    required StoryDbModel? previousStory,
    EdgeInsets itemPadding = const EdgeInsets.all(16.0),
  }) {
    return SpStoryTile(
      itemPadding: itemPadding,
      gridLayout: gridLayout,
      story: story,
      onRefresh: () async {},
    );
  }

  @override
  Widget build(BuildContext context) {
    if (gridLayout) {
      return MasonryGridView.count(
        padding: const EdgeInsets.all(16.0),
        crossAxisCount: 2,
        mainAxisSpacing: ConfigConstant.margin1,
        crossAxisSpacing: ConfigConstant.margin1,
        itemCount: _stories.length,
        itemBuilder: (context, index) {
          StoryDbModel story = storyAt(_stories, index)!;
          StoryDbModel? previousStory = storyAt(_stories, index - 1);
          return buildTile(
            index: index,
            context: context,
            story: story,
            previousStory: previousStory,
            itemPadding: EdgeInsets.zero,
          );
        },
      );
    } else {
      int itemCount = separatorOnTop ? _stories.length + 1 : _stories.length;
      EdgeInsets padding = EdgeInsets.symmetric(vertical: separatorOnTop ? ConfigConstant.margin2 : 0);
      return ListView.separated(
        separatorBuilder: buildSeperatorBuilder,
        padding: padding,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (index == 0 && separatorOnTop) return const SizedBox.shrink();

          int configuredIndex = separatorOnTop ? index - 1 : index;
          StoryDbModel story = storyAt(_stories, configuredIndex)!;
          StoryDbModel? previousStory = storyAt(_stories, configuredIndex - 1);

          return buildTile(
            index: configuredIndex,
            context: context,
            story: story,
            previousStory: previousStory,
          );
        },
      );
    }
  }
}
