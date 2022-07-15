part of sp_story_tile;

class _GridItemContent extends _BaseTileContent {
  const _GridItemContent({
    required _TileContentOptions options,
  }) : super(options: options);

  @override
  Widget build(BuildContext context) {
    StoryContentDbModel content = getStoryContent(options.story);
    Set<String> images = {};
    content.pages?.forEach((page) {
      images.addAll(QuillHelper.imagesFromJson(page));
    });

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(ConfigConstant.margin2),
          decoration: BoxDecoration(
            color: options.starred ? M3Color.of(context).readOnly.surface2 : M3Color.of(context).readOnly.surface1,
            borderRadius: ConfigConstant.circlarRadius1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTitleBody(content, context, ConfigConstant.margin2),
              const SizedBox(height: ConfigConstant.margin0),
              ValueListenableBuilder(
                valueListenable: options.expandedNotifier,
                builder: (context, value, child) {
                  return StoryTileChips(
                    images: images,
                    content: content,
                    minimize: !options.expandedNotifier.value,
                    story: options.story,
                    onImageUploaded: (content) => options.replaceContent(content),
                  );
                },
              ),
            ],
          ),
        ),
        buildToggleButton(),
      ],
    );
  }

  Widget buildToggleButton() {
    return Positioned(
      right: 4,
      top: 4,
      child: SpIconButton(
        onPressed: () => options.toggleExpand(),
        icon: ValueListenableBuilder(
          valueListenable: options.expandedNotifier,
          builder: (context, value, child) {
            return SpAnimatedIcons(
              showFirst: !options.expandedNotifier.value,
              secondChild: Icon(
                Icons.arrow_drop_down,
                size: ConfigConstant.iconSize1,
                color: M3Color.of(context).primary,
              ),
              firstChild: Icon(
                Icons.arrow_right,
                size: ConfigConstant.iconSize1,
                color: M3TextTheme.of(context).caption?.color,
              ),
            );
          },
        ),
      ),
    );
  }
}
