part of sp_story_list;

class _TimelineListLayout extends _BaseSpListLayout {
  _TimelineListLayout({
    required _ListLayoutOptions options,
  }) : super(options: options);

  @override
  bool get gridLayout => false;

  @override
  bool get separatorOnTop => true;

  String monthName(int index) {
    return DateFormatHelper.toNameOfMonth().format(options.stories[index].displayPathDate);
  }

  @override
  Widget buildSeperatorBuilder(
    BuildContext context,
    int index,
    StoryDbModel story,
    StoryDbModel? previousStory,
  ) {
    if (differentMonth(story, previousStory)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          if (options.hasDifferentYear && differentYear(story, previousStory)) buildYearHeader(context, index),
          buildMonthHeader(index, context),
        ],
      );
    } else {
      return const Divider(height: 1, indent: 16.0 + 20);
    }
  }

  Widget buildMonthHeader(int index, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          if (index != 0) const Positioned.fill(child: Divider(height: 1, indent: 16.0 + 20)),
          buildHeader(
            context,
            monthName(index),
          ),
        ],
      ),
    );
  }

  Widget buildYearHeader(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: buildHeader(
        context,
        options.stories[index].year.toString(),
        Colors.transparent,
      ),
    );
  }

  Widget buildHeader(
    BuildContext context,
    String label, [
    Color? backgroundColor,
  ]) {
    return Container(
      width: 20 * 2 + 16.0 * 2,
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 6.0,
        ),
        decoration: BoxDecoration(
          color: backgroundColor ?? M3Color.of(context).readOnly.surface2,
          borderRadius: ConfigConstant.circlarRadius2,
        ),
        child: Text(
          label,
          style: M3TextTheme.of(context).labelSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
