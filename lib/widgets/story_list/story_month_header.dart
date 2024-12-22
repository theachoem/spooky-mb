part of 'story_tile_list_item.dart';

class _StoryMonthHeader extends StatelessWidget {
  const _StoryMonthHeader({
    required this.index,
    required this.context,
    required this.story,
  });

  final int index;
  final BuildContext context;
  final StoryDbModel story;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: StoryTile.monogramSize + 16,
      margin: EdgeInsets.only(
        left: 8.0,
        bottom: 4.0,
        top: index == 0 ? 8.0 : 16,
      ),
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        alignment: Alignment.center,
        child: Text(
          DateFormatService.MMM(DateTime(2000, story.month)),
          style: TextTheme.of(context).labelLarge,
        ),
      ),
    );
  }
}
