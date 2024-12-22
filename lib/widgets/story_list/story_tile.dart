import 'package:flutter/material.dart';
import 'package:spooky/core/databases/models/story_content_db_model.dart';
import 'package:spooky/core/databases/models/story_db_model.dart';
import 'package:spooky/core/services/color_from_day_service.dart';
import 'package:spooky/widgets/sp_markdown_body.dart';

class StoryTile extends StatelessWidget {
  static const double monogramSize = 36;

  const StoryTile({
    super.key,
    required this.story,
    required this.onTap,
    required this.onToggleStarred,
  });

  final StoryDbModel story;
  final void Function() onTap;
  final void Function() onToggleStarred;

  @override
  Widget build(BuildContext context) {
    StoryContentDbModel? content = story.latestChange;

    bool hasTitle = content?.title?.trim().isNotEmpty == true;
    bool hasBody = content?.displayShortBody != null && content?.displayShortBody?.trim().isNotEmpty == true;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16.0,
              children: [
                buildMonogram(context),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    if (hasTitle)
                      Container(
                        margin: const EdgeInsets.only(right: 16.0),
                        child: Text(
                          content!.title!,
                          style: TextTheme.of(context).titleMedium,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    if (hasBody)
                      Container(
                        margin: hasTitle ? null : const EdgeInsets.only(right: 24.0),
                        child: SpMarkdownBody(body: content!.displayShortBody!),
                      )
                  ]),
                )
              ],
            ),
            buildStarredButton(context)
          ],
        ),
      ),
    );
  }

  Widget buildStarredButton(BuildContext context) {
    return Positioned(
      right: 0,
      child: Container(
        transform: Matrix4.identity()..translate(-16.0 * 2 + 48.0, 16.0 * 2 - 48.0),
        child: IconButton(
          isSelected: story.starred,
          iconSize: 20.0,
          onPressed: onToggleStarred,
          selectedIcon: Icon(
            Icons.favorite,
            color: ColorScheme.of(context).error,
          ),
          icon: Icon(
            Icons.favorite_outline,
            color: ColorScheme.of(context).onSurface,
          ),
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
        style: TextTheme.of(context).bodyLarge?.copyWith(color: ColorScheme.of(context).onPrimary),
      ),
    );
  }
}
