part of sp_story_tile;

abstract class _BaseTileContent extends StatelessWidget {
  const _BaseTileContent({
    Key? key,
    required this.options,
  }) : super(key: key);

  final _TileContentOptions options;
  StoryContentDbModel getStoryContent(StoryDbModel story) {
    DateTime date = DateTime.now();
    return story.changes.isNotEmpty
        ? story.changes.last
        : StoryContentDbModel.create(
            createdAt: date,
            id: date.millisecondsSinceEpoch,
          );
  }

  String trimBody(String body) {
    body = body.trim();
    int length = body.length;
    int end = body.length;

    List<String> endWiths = ["- [", "- [x", "- [ ]", "- [x]", "-"];
    for (String ew in endWiths) {
      if (body.endsWith(ew)) {
        end = length - ew.length;
      }
    }

    return length > end ? body.substring(0, end) : body;
  }

  String body(StoryContentDbModel content) {
    String body = content.plainText?.trim() ?? "content.plainText";
    String extract = body.length > 200 ? body.substring(0, 200) : body;
    return body.length > 200 ? "${trimBody(extract)}..." : extract;
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
