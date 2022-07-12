part of sp_story_tile;

class _ListStoryTileContent extends _BaseTileContent {
  const _ListStoryTileContent({
    required _TileContentOptions options,
  }) : super(options: options);

  @override
  Widget build(BuildContext context) {
    Map<int, Color> dayColors = M3Color.dayColorsOf(context);
    return Row(
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

  Widget buildContent(BuildContext context, StoryDbModel story) {
    Set<String> images = {};
    StoryContentDbModel content = getStoryContent(story);

    content.pages?.forEach((page) {
      images.addAll(QuillHelper.imagesFromJson(page));
    });

    bool hasTitle = content.title?.trim().isNotEmpty == true;
    return Expanded(
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTitleBody(hasTitle, content, context),
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

  double get contentRightMargin {
    return kToolbarHeight + 16;
  }

  Column buildTitleBody(bool hasTitle, StoryContentDbModel content, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasTitle)
          Container(
            margin: EdgeInsets.only(bottom: ConfigConstant.margin0, right: contentRightMargin),
            child: Text(
              content.title ?? "content.title",
              style: M3TextTheme.of(context).titleMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (content.plainText != null && content.plainText!.trim().length > 1)
          Container(
            margin: EdgeInsets.only(bottom: ConfigConstant.margin0, right: hasTitle ? 0 : contentRightMargin),
            child: Consumer<TileMaxLineProvider>(builder: (context, provider, child) {
              return MarkdownBody(
                data: body(content),
                onTapLink: (url, _, __) => AppHelper.openLinkDialog(url),
                styleSheet: MarkdownStyleSheet(
                  blockquoteDecoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      left: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                  ),
                  blockquotePadding: const EdgeInsets.symmetric(vertical: 0, horizontal: ConfigConstant.margin1),
                  codeblockDecoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  listBulletPadding: const EdgeInsets.all(2),
                  listIndent: ConfigConstant.iconSize1,
                  blockSpacing: 0.0,
                ),
                checkboxBuilder: (checked) {
                  return Transform.translate(
                    offset: const Offset(-3.5, 2.5),
                    child: Icon(
                      checked ? Icons.check_box : Icons.check_box_outline_blank,
                      size: ConfigConstant.iconSize1,
                    ),
                  );
                },
                softLineBreak: true,
              );
            }),
          ),
      ],
    );
  }

  Widget buildTime(BuildContext context, StoryContentDbModel content) {
    return SpTapEffect(
      effects: const [SpTapEffectType.touchableOpacity],
      onTap: () => options.toggleStarred(),
      child: Row(
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
          if (content.draft == true)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: ConfigConstant.margin0),
              child: Icon(
                Icons.edit_note,
                size: ConfigConstant.iconSize1,
              ),
            ),
          Text(
            DateFormatHelper.timeFormat().format(options.story.displayPathDate),
            style: M3TextTheme.of(context).bodySmall,
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
    // bool sameDay = previousStory?.path != null ? story.path.sameDayAs(previousStory!.path) : false;
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
