import 'package:flutter/material.dart';
import 'package:spooky/core/databases/models/story_content_db_model.dart';
import 'package:spooky/core/databases/models/story_db_model.dart';
import 'package:spooky/core/services/color_from_day_service.dart';

class StoryTile extends StatelessWidget {
  static const double circleSize = 32;

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

    return MediaQuery.removePadding(
      removeLeft: true,
      removeRight: true,
      context: context,
      child: ListTile(
        leading: Container(
          width: circleSize,
          height: circleSize,
          decoration: BoxDecoration(
            color: ColorFromDayService(context: context).get(story.displayPathDate.weekday),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            story.displayPathDate.day.toString(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
        title: Text(content?.title ?? 'N/A'),
        subtitle: displayBody != null ? Text(displayBody) : null,
        onTap: onTap,
      ),
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
