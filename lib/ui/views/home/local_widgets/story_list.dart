import 'package:flutter/material.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/ui/views/detail/detail_view_model.dart';
import 'package:spooky/ui/widgets/sp_animated_icon.dart';
import 'package:spooky/ui/widgets/sp_chip.dart';
import 'package:spooky/ui/widgets/sp_tap_effect.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:spooky/utils/helpers/quill_helper.dart';
import 'package:spooky/core/route/router.dart' as route;

class StoryList extends StatelessWidget {
  const StoryList({
    Key? key,
    required this.onRefresh,
    required this.stories,
    this.emptyMessage = "",
    this.onDelete,
    this.onUnarchive,
    this.itemPadding = const EdgeInsets.all(ConfigConstant.margin2),
  }) : super(key: key);

  final Future<void> Function() onRefresh;
  final Future<bool> Function(StoryModel story)? onDelete;
  final Future<bool> Function(StoryModel story)? onUnarchive;
  final List<StoryModel>? stories;
  final String emptyMessage;
  final EdgeInsets itemPadding;

  @override
  Widget build(BuildContext context) {
    if (onDelete != null || onUnarchive != null) {
      assert(onDelete != null);
      assert(onUnarchive != null);
    }
    Map<int, Color> dayColors = M3Color.dayColorsOf(context);
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Stack(
        children: [
          ListView.separated(
            itemCount: stories?.length ?? 0,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            separatorBuilder: (context, index) {
              return Divider(
                indent: 16 + 20 + 16 + 4 + 16,
                color: M3Color.of(context).secondary.m3Opacity.opacity016,
                height: 0,
              );
            },
            itemBuilder: (context, index) {
              final StoryModel content = stories![index];
              if (onDelete != null && onUnarchive != null) {
                return Dismissible(
                  key: ValueKey(content.id),
                  background: buildDismissibleBackground(
                    context: context,
                    iconData: Icons.delete,
                    alignment: Alignment.centerLeft,
                    backgroundColor: M3Color.of(context).error,
                    foregroundColor: M3Color.of(context).onError,
                    label: "Delete",
                  ),
                  secondaryBackground: buildDismissibleBackground(
                    context: context,
                    iconData: Icons.unarchive,
                    alignment: Alignment.centerRight,
                    backgroundColor: M3Color.of(context).primary,
                    foregroundColor: M3Color.of(context).onPrimary,
                    label: "Unarchive",
                  ),
                  confirmDismiss: (direction) async {
                    switch (direction) {
                      case DismissDirection.startToEnd:
                        if (onDelete != null) return onDelete!(content);
                        return false;
                      case DismissDirection.vertical:
                        return false;
                      case DismissDirection.horizontal:
                        return false;
                      case DismissDirection.endToStart:
                        if (onDelete != null) return onUnarchive!(content);
                        return false;
                      case DismissDirection.up:
                        return false;
                      case DismissDirection.down:
                        return false;
                      case DismissDirection.none:
                        return false;
                    }
                  },
                  child: buildStoryTile(
                    content,
                    context,
                    dayColors,
                  ),
                );
              }
              return buildStoryTile(
                content,
                context,
                dayColors,
              );
            },
          ),
          IgnorePointer(
            child: Visibility(
              visible: stories?.isEmpty == true,
              child: Container(
                alignment: Alignment.center,
                child: Text(emptyMessage),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDismissibleBackground({
    required BuildContext context,
    required IconData iconData,
    required String label,
    Color? backgroundColor,
    Color? foregroundColor,
    Alignment alignment = Alignment.centerRight,
  }) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: ConfigConstant.margin2),
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<int>(
            duration: ConfigConstant.duration,
            tween: IntTween(begin: 0, end: 1),
            builder: (context, value, child) {
              return SpAnimatedIcons(
                firstChild: Icon(
                  iconData,
                  size: ConfigConstant.iconSize3,
                  color: foregroundColor,
                  key: ValueKey(iconData),
                ),
                secondChild: Icon(
                  Icons.swap_horiz,
                  size: ConfigConstant.iconSize3,
                  color: foregroundColor,
                  key: const ValueKey(Icons.swap_horiz),
                ),
                showFirst: value == 1,
              );
            },
          ),
          ConfigConstant.sizedBoxH0,
          Text(
            label,
            style: TextStyle(color: foregroundColor),
          ),
        ],
      ),
    );
  }

  Widget buildStoryTile(StoryModel story, BuildContext context, Map<int, Color> dayColors) {
    return SpTapEffect(
      onTap: () {
        route.Detail page = route.Detail(
          initialStory: story,
          intialFlow: DetailViewFlow.update,
        );
        context.router.push(page).then(
          (value) {
            if (value is StoryModel) {
              onRefresh();
            }
          },
        );
      },
      child: Padding(
        padding: itemPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildMonogram(context, story, dayColors),
            ConfigConstant.sizedBoxW2,
            buildContent(context, story),
          ],
        ),
      ),
    );
  }

  Widget buildMonogram(BuildContext context, StoryModel story, Map<int, Color> dayColors) {
    DateTime displayDate = story.path.toDateTime();
    return Column(
      children: [
        ConfigConstant.sizedBoxH0,
        Text(DateFormatHelper.toDay().format(displayDate).toString()),
        ConfigConstant.sizedBoxH0,
        CircleAvatar(
          radius: 20,
          backgroundColor: dayColors.keys.contains(displayDate.weekday)
              ? dayColors[displayDate.weekday]
              : M3Color.of(context).primary,
          foregroundColor: M3Color.of(context).onPrimary,
          child: Text(displayDate.day.toString()),
        ),
      ],
    );
  }

  Widget buildContent(BuildContext context, StoryModel story) {
    Set<String> images = {};
    StoryContentModel content = story.changes.last;

    content.pages?.forEach((page) {
      images.addAll(QuillHelper.imagesFromJson(page));
    });

    return Expanded(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (content.title?.trim().isNotEmpty == true)
                Container(
                  margin: const EdgeInsets.only(bottom: ConfigConstant.margin0),
                  child: Text(
                    content.title ?? "content.title",
                    style: M3TextTheme.of(context).titleMedium,
                  ),
                ),
              if (content.plainText != null && content.plainText!.trim().length > 1)
                Container(
                  margin: const EdgeInsets.only(bottom: ConfigConstant.margin0),
                  child: Text(
                    content.plainText?.trim() ?? "content.plainText",
                    style: M3TextTheme.of(context).bodyMedium,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              if (images.isNotEmpty)
                SpChip(
                  labelText: "${images.length} Images",
                  avatar: CircleAvatar(
                    backgroundImage: NetworkImage(images.first),
                  ),
                ),
              if ((content.pages?.length ?? 0) > 1) SpChip(labelText: "${content.pages?.length} Pages")
            ],
          ),
          buildTime(context, content)
        ],
      ),
    );
  }

  Widget buildTime(BuildContext context, StoryContentModel content) {
    return Positioned(
      right: 0,
      child: Row(
        children: [
          if (content.starred == true)
            Icon(
              Icons.favorite,
              size: ConfigConstant.iconSize1,
              color: M3Color.of(context).error,
            ),
          ConfigConstant.sizedBoxW0,
          Text(
            DateFormatHelper.timeFormat().format(content.createdAt),
            style: M3TextTheme.of(context).bodySmall,
          ),
        ],
      ),
    );
  }
}
