part of sp_story_tile;

class _GridItemContent extends _BaseTileContent {
  const _GridItemContent({
    required _TileContentOptions options,
  }) : super(options: options);

  @override
  Widget build(BuildContext context) {
    StoryContentDbModel content = getStoryContent(options.story);
    return Container(
      padding: const EdgeInsets.all(ConfigConstant.margin2),
      decoration: BoxDecoration(
        color: options.starred ? M3Color.of(context).readOnly.surface2 : M3Color.of(context).readOnly.surface1,
        borderRadius: ConfigConstant.circlarRadius1,
      ),
      child: buildTitleBody(content, context, 0),
    );
  }
}
