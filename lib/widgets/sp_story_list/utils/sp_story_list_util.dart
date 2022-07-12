part of sp_story_list;

class _ConfiguredStoryArgs {
  final List<StoryDbModel>? stories;
  final bool shouldShowChip;
  final bool prioritied;
  final SortType? sortType;

  _ConfiguredStoryArgs(this.stories, StoryListConfigurationProvider configuration)
      : shouldShowChip = configuration.shouldShowChip,
        prioritied = configuration.prioritied,
        sortType = configuration.sortType;
}

int _dateForCompare(StoryDbModel story) {
  return story.displayPathDate.millisecondsSinceEpoch;
}

List<StoryDbModel> _fetchConfiguredStory(_ConfiguredStoryArgs args) {
  List<StoryDbModel>? stories = args.stories;

  if (stories != null) {
    switch (args.sortType) {
      case SortType.oldToNew:
      case null:
        stories.sort((a, b) => _dateForCompare(a) >= _dateForCompare(b) ? 1 : -1);
        break;
      case SortType.newToOld:
        stories.sort((a, b) => _dateForCompare(a) >= _dateForCompare(b) ? 1 : -1);
        stories = stories.reversed.toList();
        break;
    }
    if (args.prioritied == true) stories.sort(((a, b) => b.starred == true ? 1 : -1));
  }

  if (kDebugMode) {
    print('_fetchConfiguredStory');
  }

  return stories ?? [];
}
