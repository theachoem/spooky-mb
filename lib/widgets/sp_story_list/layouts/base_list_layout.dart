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

  String buildIdentity(
    StoryDbModel? story,
  ) {
    if (story == null) return "";
    return [
      story.year,
      story.month,
      story.day,
      story.id,
    ].join("-");
  }

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

  Widget buildAnimatedTileWrapper({
    required Widget child,
    required StoryDbModel story,
  }) {
    return TweenAnimationBuilder<int>(
      key: ValueKey(buildIdentity(story)),
      duration: ConfigConstant.duration,
      tween: IntTween(begin: 0, end: 1),
      child: child,
      builder: (BuildContext context, int value, Widget? child) {
        return AnimatedOpacity(
          duration: ConfigConstant.duration,
          opacity: value == 1 ? 1.0 : 0.0,
          curve: Curves.ease,
          child: child,
        );
      },
    );
  }

  Widget buildTile({
    required BuildContext context,
    required int index,
    required StoryDbModel story,
    required StoryDbModel? previousStory,
    EdgeInsets itemPadding = const EdgeInsets.all(16.0),
  }) {
    return IgnorePointer(
      ignoring: options.viewOnly,
      child: buildAnimatedTileWrapper(
        story: story,
        child: SpStoryTile(
          itemPadding: itemPadding,
          gridLayout: gridLayout,
          story: story,
          onRefresh: () => options.onRefresh(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (gridLayout) {
      return MasonryGridView.count(
        padding: const EdgeInsets.all(16.0),
        crossAxisCount: 2,
        controller: options.controller,
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
        separatorBuilder: (context, index) {
          return buildAnimatedTileWrapper(
            story: _stories[index],
            child: buildSeperatorBuilder(context, index),
          );
        },
        padding: padding,
        itemCount: itemCount,
        controller: options.controller,
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
