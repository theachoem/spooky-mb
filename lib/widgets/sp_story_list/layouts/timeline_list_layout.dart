part of sp_story_list;

class _TimelineListLayout extends _BaseSpListLayout {
  _TimelineListLayout({
    required _ListLayoutOptions options,
  }) : super(options: options);

  @override
  bool get gridLayout => false;

  @override
  bool get separatorOnTop => true;

  @override
  Widget buildSeperatorBuilder(BuildContext context, int index) {
    StoryDbModel story = options.stories[index];
    StoryDbModel? previousStory = storyAt(options.stories, index - 1);

    String storyForCompare = "${story.year} ${story.month}";
    String previousStoryForCompare = "${previousStory?.year} ${previousStory?.month}";

    if (storyForCompare != previousStoryForCompare) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildMonthHeader(context, index),
          if (index != 0)
            const Expanded(
              child: Divider(height: 1),
            ),
        ],
      );
    } else {
      return const Divider(height: 1, indent: 16.0 + 20);
    }
  }

  Widget buildMonthHeader(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0),
      width: 20 * 2,
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 6.0,
        ),
        decoration: BoxDecoration(
          color: M3Color.of(context).readOnly.surface2,
          borderRadius: ConfigConstant.circlarRadius2,
        ),
        child: Text(
          DateFormatHelper.toNameOfMonth().format(options.stories[index].displayPathDate),
          style: M3TextTheme.of(context).labelSmall,
        ),
      ),
    );
  }
}
