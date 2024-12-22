part of 'story_tile_list_item.dart';

class _StoryMonthHeader extends StatelessWidget {
  const _StoryMonthHeader({
    required this.index,
    required this.context,
    required this.story,
    required this.showYear,
  });

  final int index;
  final BuildContext context;
  final StoryDbModel story;
  final bool showYear;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 4.0, top: index == 0 ? 8.0 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 16.0),
          buildMonthChip(context),
          if (showYear) ...[
            const SizedBox(width: 4.0),
            Container(
              width: 2,
              height: 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorScheme.of(context).onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(width: 4.0),
            Text(
              story.year.toString(),
              style: TextTheme.of(context)
                  .labelSmall
                  ?.copyWith(color: ColorScheme.of(context).onSurface.withValues(alpha: 0.5)),
            ),
          ]
        ],
      ),
    );
  }

  Widget buildMonthChip(BuildContext context) {
    return Container(
      width: StoryTile.monogramSize,
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            width: 1,
            color: Theme.of(context).dividerColor,
          ),
        ),
        child: FittedBox(
          child: Text(
            DateFormatService.MMM(DateTime(2000, story.month)),
            style: TextTheme.of(context).labelSmall,
          ),
        ),
      ),
    );
  }
}
