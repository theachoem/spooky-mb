part of '../home_view.dart';

class _Month extends StatelessWidget {
  const _Month({
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
      width: 48.0,
      margin: EdgeInsets.only(left: 8.0, top: index == 0 ? 8.0 : 0),
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        alignment: Alignment.center,
        child: Text(DateFormatService.MMM(DateTime(2000, story.month))),
      ),
    );
  }
}
