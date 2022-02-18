import 'package:flutter/material.dart';
import 'package:spooky/core/file_managers/archive_file_manager.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/route/sp_route_config.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/ui/views/detail/detail_view_model.dart';
import 'package:spooky/ui/widgets/sp_chip.dart';
import 'package:spooky/ui/widgets/sp_developer_visibility.dart';
import 'package:spooky/ui/widgets/sp_dimissable_background.dart';
import 'package:spooky/ui/widgets/sp_pop_up_menu_button.dart';
import 'package:spooky/ui/widgets/sp_tap_effect.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:spooky/utils/helpers/file_helper.dart';
import 'package:spooky/utils/helpers/quill_helper.dart';

class StoryList extends StatelessWidget {
  const StoryList({
    Key? key,
    required this.onRefresh,
    required this.stories,
    this.emptyMessage = "Empty",
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

  StoryModel? storyAt(int index) {
    if (stories?.isNotEmpty == true) {
      if (index >= 0 && stories!.length > index) {
        return stories![index];
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (onDelete != null || onUnarchive != null) {
      assert(onDelete != null);
      assert(onUnarchive != null);
    }
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
                    story: content,
                    context: context,
                    previousStory: storyAt(index - 1),
                  ),
                );
              }
              return buildStoryTile(
                story: content,
                context: context,
                previousStory: storyAt(index - 1),
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
    return SpDimissableBackground(
      alignment: alignment,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      iconData: iconData,
      label: label,
    );
  }

  Widget buildStoryTile({
    required StoryModel story,
    required StoryModel? previousStory,
    required BuildContext context,
  }) {
    final ArchiveFileManager manager = ArchiveFileManager();
    Map<int, Color> dayColors = M3Color.dayColorsOf(context);
    return SpPopupMenuButton(
      dxGetter: (double dx) => MediaQuery.of(context).size.width,
      dyGetter: (double dy) => dy + ConfigConstant.margin2,
      builder: (callback) {
        return SpTapEffect(
          onTap: () {
            DetailArgs args = DetailArgs(initialStory: story, intialFlow: DetailViewFlow.update);
            Navigator.of(context).pushNamed(SpRouteConfig.detail, arguments: args).then((value) {
              if (value is StoryModel && value != story) onRefresh();
            });
          },
          onLongPressed: manager.canArchive(story) ? () => callback() : null,
          child: Padding(
            padding: itemPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildMonogram(context, story, previousStory, dayColors),
                ConfigConstant.sizedBoxW2,
                buildContent(context, story),
              ],
            ),
          ),
        );
      },
      items: (BuildContext context) {
        return [
          if (manager.canArchive(story))
            SpPopMenuItem(
              title: "Archive",
              leadingIconData: Icons.archive,
              onPressed: () async {
                await manager.archiveDocument(story);
                onRefresh();
              },
            ),
        ];
      },
    );
  }

  Widget buildMonogram(
    BuildContext context,
    StoryModel story,
    StoryModel? previousStory,
    Map<int, Color> dayColors,
  ) {
    // bool sameDay = previousStory?.path != null ? story.path.sameDayAs(previousStory!.path) : false;
    DateTime displayDate = story.path.toDateTime();
    return Column(
      children: [
        ConfigConstant.sizedBoxH0,
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 20 * 2),
          child: Text(
            DateFormatHelper.toDay().format(displayDate).toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
        ConfigConstant.sizedBoxH0,
        CircleAvatar(
          radius: 20,
          backgroundColor: dayColors.keys.contains(displayDate.weekday)
              ? dayColors[displayDate.weekday]
              : M3Color.of(context).primary,
          foregroundColor: M3Color.of(context).onPrimary,
          child: Text(
            displayDate.day.toString(),
            style: M3TextTheme.of(context).bodyLarge?.copyWith(color: M3Color.of(context).onPrimary),
          ),
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

    bool hasTitle = content.title?.trim().isNotEmpty == true;
    return Expanded(
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasTitle)
                  Container(
                    margin: const EdgeInsets.only(bottom: ConfigConstant.margin0, right: kToolbarHeight),
                    child: Text(
                      content.title ?? "content.title",
                      style: M3TextTheme.of(context).titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (content.plainText != null && content.plainText!.trim().length > 1)
                  Container(
                    margin: EdgeInsets.only(bottom: ConfigConstant.margin0, right: hasTitle ? 0 : kToolbarHeight),
                    child: Text(
                      body(content),
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
                if ((content.pages?.length ?? 0) > 1) SpChip(labelText: "${content.pages?.length} Pages"),
                SpDeveloperVisibility(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        FileHelper.fileName(story.file!.path),
                        textAlign: TextAlign.end,
                        style: M3TextTheme.of(context).labelSmall?.copyWith(
                              fontWeight: FontWeight.normal,
                              color: M3Color.of(context).primary,
                              backgroundColor: M3Color.of(context).primaryContainer,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          buildTime(context, story.changes.first),
        ],
      ),
    );
  }

  String body(StoryContentModel content) {
    String _body = content.plainText?.trim() ?? "content.plainText";
    return _body;
  }

  Widget buildTime(BuildContext context, StoryContentModel content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
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
    );
  }
}
