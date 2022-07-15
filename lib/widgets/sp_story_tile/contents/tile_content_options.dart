part of sp_story_tile;

class _TileContentOptions {
  final StoryDbModel? previousStory;
  final StoryDbModel story;
  final BuildContext context;
  final ValueNotifier<bool> expandedNotifier;
  final Future<void> Function(StoryContentDbModel) replaceContent;
  final Future<void> Function() toggleStarred;
  final void Function() toggleExpand;

  bool get starred => story.starred == true;
  Color? get starredColor => starred ? M3Color.of(context).error : null;

  _TileContentOptions({
    required this.previousStory,
    required this.story,
    required this.context,
    required this.expandedNotifier,
    required this.replaceContent,
    required this.toggleStarred,
    required this.toggleExpand,
  });
}
