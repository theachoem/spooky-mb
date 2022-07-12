part of sp_story_tile;

class _TileContentOptions {
  final StoryDbModel? previousStory;
  final StoryDbModel story;
  final BuildContext context;
  final Future<void> Function(StoryContentDbModel) replaceContent;
  final Future<void> Function() toggleStarred;

  bool get starred => story.starred == true;
  Color? get starredColor => starred ? M3Color.of(context).error : null;

  _TileContentOptions({
    required this.previousStory,
    required this.story,
    required this.context,
    required this.replaceContent,
    required this.toggleStarred,
  });
}
