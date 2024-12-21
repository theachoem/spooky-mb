import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:spooky/core/databases/models/story_content_db_model.dart';
import 'package:spooky/core/databases/models/story_db_model.dart';
import 'package:spooky/core/services/color_from_day_service.dart';

class StoryTile extends StatelessWidget {
  static const double monogramSize = 32;

  const StoryTile({
    super.key,
    required this.story,
    required this.onTap,
  });

  final StoryDbModel story;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    StoryContentDbModel? content = story.changes.lastOrNull;
    String? displayBody = content != null ? getDisplayBodyFor(content) : null;

    bool hasTitle = content?.title?.trim().isNotEmpty == true;
    bool hasBody = displayBody != null && displayBody.trim().length > 1;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            buildMonogram(context),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (hasTitle)
                  Text(
                    content!.title!,
                    style: TextTheme.of(context).titleMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (hasBody) buildMarkdownBody(displayBody, context)
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget buildMonogram(BuildContext context) {
    return Container(
      width: monogramSize,
      height: monogramSize,
      decoration: BoxDecoration(
        color: ColorFromDayService(context: context).get(story.displayPathDate.weekday),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        story.displayPathDate.day.toString(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }

  Widget buildMarkdownBody(String displayBody, BuildContext context) {
    return MarkdownBody(
      data: displayBody,
      onTapLink: (url, _, __) {},
      styleSheet: MarkdownStyleSheet(
        blockquoteDecoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
            left: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        blockquotePadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
        codeblockDecoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerColor)),
        listBulletPadding: const EdgeInsets.all(2),
        listIndent: 16,
        blockSpacing: 0.0,
      ),
      checkboxBuilder: (checked) {
        return Transform.translate(
          offset: const Offset(-3.5, 2.5),
          child: Icon(
            checked ? Icons.check_box : Icons.check_box_outline_blank,
            size: 16.0,
          ),
        );
      },
      softLineBreak: true,
    );
  }

  String? getDisplayBodyFor(StoryContentDbModel content) {
    if (content.plainText == null) return null;

    String body = content.plainText!.trim();
    String extract = body.length > 200 ? body.substring(0, 200) : body;
    return body.length > 200 ? "${trimBody(extract)}..." : extract;
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
}
