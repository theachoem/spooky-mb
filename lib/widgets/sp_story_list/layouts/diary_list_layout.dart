part of sp_story_list;

class _DiaryListLayout extends _BaseSpListLayout {
  _DiaryListLayout({
    required _ListLayoutOptions options,
  }) : super(options: options);

  @override
  bool get gridLayout => false;

  @override
  bool get separatorOnTop => false;

  @override
  Widget buildSeperatorBuilder(
    BuildContext context,
    int index,
    StoryDbModel story,
    StoryDbModel? previousStory,
  ) {
    return const Divider(height: 1, indent: 16.0 + 20);
  }
}
