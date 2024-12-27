import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/app_theme.dart';
import 'package:spooky/core/databases/models/story_content_db_model.dart';
import 'package:spooky/core/databases/models/story_db_model.dart';
import 'package:spooky/core/services/color_from_day_service.dart';
import 'package:spooky/core/services/date_format_service.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/views/home/home_view_model.dart';
import 'package:spooky/widgets/sp_markdown_body.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';

class StoryTile extends StatelessWidget {
  static const double monogramSize = 32;

  const StoryTile({
    super.key,
    required this.story,
    required this.showMonogram,
    required this.onTap,
    this.viewOnly = false,
  });

  final StoryDbModel story;

  final bool showMonogram;
  final bool viewOnly;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    StoryContentDbModel? content = story.latestChange;

    bool hasTitle = content?.title?.trim().isNotEmpty == true;
    bool hasBody = content?.displayShortBody != null && content?.displayShortBody?.trim().isNotEmpty == true;

    List<SpPopMenuItem> menus = buildPopUpMenus(context);

    return SpPopupMenuButton(
      smartDx: true,
      dyGetter: (double dy) => dy + kToolbarHeight,
      items: (BuildContext context) => menus,
      builder: (openPopUpMenu) {
        return InkWell(
          onTap: onTap,
          onLongPress: menus.isNotEmpty ? openPopUpMenu : null,
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
                    buildContents(hasTitle, content, context, hasBody),
                  ],
                ),
                buildStarredButton(context)
              ],
            ),
          ),
        );
      },
    );
  }

  List<SpPopMenuItem> buildPopUpMenus(BuildContext context) {
    return [
      if (story.editable)
        SpPopMenuItem(
          title: 'Change Date',
          leadingIconData: Icons.calendar_month,
          onPressed: () async {
            DateTime? date = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              lastDate: DateTime.now().add(const Duration(days: 100 * 365)),
              currentDate: story.displayPathDate,
            );

            if (date != null) {
              await story.changePathDate(date);

              if (date.year != story.year) {
                // story has moved to another year which move out of home view as well -> need to reload.
                if (context.mounted) context.read<HomeViewModel>().load();
              }
            }
          },
        ),
      if (story.putBackAble)
        SpPopMenuItem(
          title: 'Put back',
          leadingIconData: Icons.restore_from_trash,
          onPressed: () async {
            await story.putBack();

            // put back most likely inside archives page (not home)
            // reload home as the put back data could go there.
            if (context.mounted) context.read<HomeViewModel>().load();
          },
        ),
      if (story.archivable)
        SpPopMenuItem(
          title: 'Archive',
          leadingIconData: Icons.archive,
          onPressed: () => story.archive(),
        ),
      if (story.canMoveToBin)
        SpPopMenuItem(
          title: 'Move to bin',
          leadingIconData: Icons.delete,
          titleStyle: TextStyle(color: ColorScheme.of(context).error),
          onPressed: () => story.moveToBin(),
        ),
      if (story.inBins)
        SpPopMenuItem(
          title: 'Delete',
          leadingIconData: Icons.delete,
          titleStyle: TextStyle(color: ColorScheme.of(context).error),
          onPressed: () async {
            OkCancelResult result = await showOkCancelAlertDialog(
              context: context,
              isDestructiveAction: true,
              title: "Are you sure to delete this story?",
              message: "You can't undo this action",
              okLabel: "Delete",
            );

            if (result == OkCancelResult.ok) {
              await story.delete();
              if (!context.mounted) return;
              MessengerService.of(context).showSnackBar(
                'Deleted successfully',
                showAction: true,
                action: (foreground) {
                  return SnackBarAction(
                    label: 'Undo',
                    onPressed: () => StoryDbModel.db.set(story),
                    textColor: foreground,
                  );
                },
              );
            }
          },
        ),
      SpPopMenuItem(
        title: 'Info',
        leadingIconData: Icons.info,
        onPressed: () {},
      )
    ];
  }

  Widget buildContents(bool hasTitle, StoryContentDbModel? content, BuildContext context, bool hasBody) {
    return Expanded(
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
          ),
        if (story.inArchives)
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: RichText(
              text: TextSpan(
                style: TextTheme.of(context).labelMedium,
                children: const [
                  WidgetSpan(child: Icon(Icons.archive_outlined, size: 16.0), alignment: PlaceholderAlignment.middle),
                  TextSpan(text: ' Archived'),
                ],
              ),
            ),
          ),
        if (story.inBins)
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: RichText(
              text: TextSpan(
                style: TextTheme.of(context).labelMedium?.copyWith(color: ColorScheme.of(context).error),
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(
                      Icons.info,
                      size: 12.0,
                      color: ColorScheme.of(context).error,
                    ),
                  ),
                  TextSpan(
                    text: ' Auto delete on ${DateFormatService.yMd(story.movedToBinAt!.add(const Duration(days: 30)))}',
                  ),
                ],
              ),
            ),
          )
      ]),
    );
  }

  Widget buildStarredButton(BuildContext context) {
    double x = -16.0 * 2 + 48.0;
    double y = 16.0 * 2 - 48.0;

    if (AppTheme.rtl(context)) {
      x = -16.0 * 2 + 16.0;
      y = 16.0 * 2 - 48.0;
    }

    return Positioned(
      left: AppTheme.getDirectionValue(context, 0.0, null),
      right: AppTheme.getDirectionValue(context, null, 0.0),
      child: Container(
        transform: Matrix4.identity()..translate(x, y),
        child: IconButton(
          isSelected: story.starred,
          iconSize: 18.0,
          onPressed: viewOnly ? null : () => story.toggleStarred(),
          selectedIcon: Icon(
            Icons.favorite,
            color: viewOnly ? Theme.of(context).disabledColor : ColorScheme.of(context).error,
          ),
          icon: Icon(
            Icons.favorite_outline,
            color: viewOnly ? Theme.of(context).disabledColor : Theme.of(context).dividerColor,
            applyTextScaling: true,
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
