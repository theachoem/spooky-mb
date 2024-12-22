import 'package:flutter/material.dart';
import 'package:spooky/core/databases/models/story_content_db_model.dart';
import 'package:spooky/core/databases/models/story_db_model.dart';
import 'package:spooky/core/services/color_from_day_service.dart';
import 'package:spooky/core/services/date_format_service.dart';
import 'package:spooky/widgets/sp_markdown_body.dart';

class StoryTile extends StatelessWidget {
  static const double monogramSize = 32;

  const StoryTile({
    super.key,
    required this.story,
    required this.onTap,
    required this.onToggleStarred,
    required this.showMonogram,
  });

  final StoryDbModel story;
  final void Function() onTap;
  final void Function() onToggleStarred;
  final bool showMonogram;

  @override
  Widget build(BuildContext context) {
    StoryContentDbModel? content = story.latestChange;

    bool hasTitle = content?.title?.trim().isNotEmpty == true;
    bool hasBody = content?.displayShortBody != null && content?.displayShortBody?.trim().isNotEmpty == true;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
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
                ),
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
    if (!showMonogram) {
      return Container(
        width: monogramSize,
        margin: const EdgeInsets.only(top: 9.0, left: 0.5),
        alignment: Alignment.center,
        child: Container(
          width: 3,
          height: 3,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: ColorScheme.of(context).onSurface,
          ),
        ),
      );
    }

    return Column(
      spacing: 4.0,
      children: [
        Container(
          width: monogramSize,
          color: ColorScheme.of(context).surface.withValues(),
          child: Text(
            DateFormatService.E(story.displayPathDate),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextTheme.of(context).labelMedium,
          ),
        ),
        Container(
          width: monogramSize,
          height: monogramSize,
          decoration: BoxDecoration(
            color: ColorFromDayService(context: context).get(story.displayPathDate.weekday),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            story.displayPathDate.day.toString(),
            style: TextTheme.of(context).bodyMedium?.copyWith(color: ColorScheme.of(context).onPrimary),
          ),
        ),
      ],
    );
  }
}
