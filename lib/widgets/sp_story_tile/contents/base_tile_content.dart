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

  bool isHasTitle(StoryContentDbModel content) {
    return content.title?.trim().isNotEmpty == true;
  }

  Column buildTitleBody(
    StoryContentDbModel content,
    BuildContext context, [
    double contentRightMargin = 0,
  ]) {
    bool hasTitle = isHasTitle(content);
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
}
