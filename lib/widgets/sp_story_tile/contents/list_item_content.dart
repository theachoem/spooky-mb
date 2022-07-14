part of sp_story_tile;

class _ListStoryTileContent extends _BaseTileContent {
  const _ListStoryTileContent({
    required _TileContentOptions options,
  }) : super(options: options);

  @override
  Widget build(BuildContext context) {
    Map<int, Color> dayColors = M3Color.dayColorsOf(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildMonogram(
          context,
          options.story,
          options.previousStory,
          dayColors,
        ),
        ConfigConstant.sizedBoxW2,
        buildContent(
          context,
          options.story,
        ),
      ],
    );
  }

  double get contentRightMargin {
    return kToolbarHeight + 16;
  }

  Widget buildContent(BuildContext context, StoryDbModel story) {
    Set<String> images = {};
    StoryContentDbModel content = getStoryContent(story);

    content.pages?.forEach((page) {
      images.addAll(QuillHelper.imagesFromJson(page));
    });

    return Expanded(
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTitleBody(content, context, contentRightMargin),
                StoryTileChips(
                  images: images,
                  content: content,
                  story: story,
                  onImageUploaded: (content) => options.replaceContent(content),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            child: buildTime(context, content),
          ),
        ],
      ),
    );
  }

  Widget buildTime(BuildContext context, StoryContentDbModel content) {
    return SpTapEffect(
      effects: const [SpTapEffectType.touchableOpacity],
      onTap: () => options.toggleStarred(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SpAnimatedIcons(
                showFirst: options.starred,
                secondChild: const SizedBox(),
                firstChild: Icon(
                  Icons.favorite,
                  size: ConfigConstant.iconSize1,
                  color: options.starredColor,
                ),
              ),
              ConfigConstant.sizedBoxW0,
              Text(
                DateFormatHelper.timeFormat().format(options.story.displayPathDate),
                style: M3TextTheme.of(context).bodySmall,
              ),
            ],
          ),
          if (content.draft == true)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Icon(
                Icons.edit_note,
                size: ConfigConstant.iconSize1,
              ),
            ),
        ],
      ),
    );
  }

  Widget buildMonogram(
    BuildContext context,
    StoryDbModel story,
    StoryDbModel? previousStory,
    Map<int, Color> dayColors,
  ) {
    // if (Global.instance.layoutType == SpListLayoutType.diary) {
    //   String storyForCompare = "${story.year} ${story.month} ${story.day}";
    //   String previousStoryForCompare = "${previousStory?.year} ${previousStory?.month} ${previousStory?.day}";
    //   bool sameDay = storyForCompare == previousStoryForCompare;
    //   if (sameDay) return const SizedBox(width: 20 * 2);
    // }
    DateTime displayDate = story.displayPathDate;
    return Container(
      color: M3Color.of(context).background,
      child: Column(
        children: [
          ConfigConstant.sizedBoxH0,
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 20 * 2),
            child: Text(
              DateFormatHelper.toDay().format(displayDate).toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          ConfigConstant.sizedBoxH0,
          CircleAvatar(
            radius: 20,
            backgroundColor: dayColors.keys.contains(displayDate.weekday)
                ? dayColors[displayDate.weekday]
                : M3Color.of(context).primary,
            foregroundColor: M3Color.of(context).onPrimary,
            child: Text(
              displayDate.day.toString(),
              style: M3TextTheme.of(context).bodyLarge?.copyWith(color: M3Color.of(context).onPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
