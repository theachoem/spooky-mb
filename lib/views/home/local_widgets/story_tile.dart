import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/db/databases/story_database.dart';
import 'package:spooky/core/db/models/story_content_db_model.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/providers/tile_max_line_provider.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';
import 'package:spooky/views/home/local_widgets/story_tile_chips.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:spooky/utils/helpers/quill_helper.dart';
import 'package:spooky/utils/util_widgets/sp_date_picker.dart';

class StoryTile extends StatefulWidget {
  const StoryTile({
    Key? key,
    required this.story,
    required this.context,
    required this.itemPadding,
    required this.onRefresh,
    this.onDelete,
    this.onArchive,
    this.onUnarchive,
    this.previousStory,
  }) : super(key: key);

  final StoryDbModel story;
  final StoryDbModel? previousStory;
  final BuildContext context;
  final EdgeInsets itemPadding;
  final Future<void> Function() onRefresh;
  final Future<bool> Function(StoryDbModel story)? onDelete;
  final Future<bool> Function(StoryDbModel story)? onArchive;
  final Future<bool> Function(StoryDbModel story)? onUnarchive;

  @override
  StoryTileState createState() => StoryTileState();
}

class StoryTileState extends State<StoryTile> {
  final StoryDatabase database = StoryDatabase();
  late final ValueNotifier<bool> loadingNotifier;

  StoryDbModel? get previousStory => widget.previousStory;

  bool get starred => story.starred == true;
  Color? get starredColor => starred ? M3Color.of(context).error : null;

  late StoryDbModel story;

  // reload current story only
  Future<void> reloadStory() async {
    StoryDbModel? storyResult = await database.fetchOne(id: story.id.toString());
    if (storyResult != null) {
      setState(() => story = storyResult);
    } else {
      widget.onRefresh();
    }
  }

  Future<void> toggleStarred() async {
    StoryDbModel copiedStory = story.copyWith(starred: !starred);
    StoryDbModel? updatedStory = await database.update(id: copiedStory.id.toString(), body: copiedStory.toJson());
    if (updatedStory != null) await reloadStory();
  }

  @override
  void initState() {
    story = widget.story;
    loadingNotifier = ValueNotifier(false);
    super.initState();
  }

  @override
  void dispose() {
    loadingNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<int, Color> dayColors = M3Color.dayColorsOf(context);
    return SpPopupMenuButton(
      dxGetter: (double dx) => MediaQuery.of(context).size.width,
      dyGetter: (double dy) => dy + ConfigConstant.margin2,
      builder: (callback) {
        return SpTapEffect(
          onTap: () => view(story, context),
          onLongPressed: () => callback(),
          child: Padding(
            padding: widget.itemPadding,
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
          if (story.archived)
            SpPopMenuItem(
              title: "View",
              leadingIconData: Icons.chrome_reader_mode,
              onPressed: () => view(story, context),
            ),
          if (!story.archived)
            SpPopMenuItem(
              title: "Change Date",
              leadingIconData: Icons.folder_open,
              onPressed: () async {
                DateTime? pathDate = await SpDatePicker.showDatePicker(
                  context,
                  story.toDateTime(),
                );

                if (pathDate != null) {
                  await database.updatePathDate(story, pathDate);
                  if (database.error == null) {
                    widget.onRefresh();
                  }
                }
              },
            ),
          if (!story.archived && widget.onArchive != null)
            SpPopMenuItem(
              title: "Archive",
              leadingIconData: Icons.archive,
              onPressed: () async {
                widget.onArchive!(story);
              },
            ),
          if (story.archived && widget.onArchive != null)
            SpPopMenuItem(
              title: "Unarchive",
              leadingIconData: Icons.archive,
              onPressed: () async {
                widget.onUnarchive!(story);
              },
            ),
          SpPopMenuItem(
            title: starred ? "Unstarred" : "Starred",
            leadingIconData: starred ? Icons.favorite : Icons.favorite_border,
            onPressed: () => toggleStarred(),
          ),
          // if (context.read<DeveloperModeProvider>().developerModeOn) buildExportOption(context, story),
          if (widget.onDelete != null)
            SpPopMenuItem(
              title: "Delete",
              leadingIconData: Icons.delete,
              titleStyle: TextStyle(color: M3Color.of(context).error),
              onPressed: () async {
                widget.onDelete!(story);
              },
            ),
        ];
      },
    );
  }

  // TODO: fix export after migration
  // SpPopMenuItem buildExportOption(BuildContext context, StoryDbModel model) {
  //   final manager = ExportFileManager();
  //   FileSystemEntity? exportedFile = manager.hasExported(model.file);
  //   bool hasExported = exportedFile != null;
  //   return SpPopMenuItem(
  //     title: hasExported ? "Exported" : "Export",
  //     leadingIconData: hasExported ? Icons.download_done : Icons.download,
  //     onPressed: () async {
  //       if (model.file != null && !hasExported) await manager.exportFile(model.file!);
  //       FileSystemEntity? exportedFile = manager.hasExported(model.file);
  //       if (exportedFile != null) {
  //         String? clickedKey = await showModalActionSheet(
  //           context: context,
  //           title: "Exported",
  //           message: manager.displayPath(exportedFile),
  //           actions: [
  //             const SheetAction(
  //               label: "Open File",
  //               key: "open",
  //             ),
  //           ],
  //         );
  //         switch (clickedKey) {
  //           case "open":
  //             await OpenFile.open(exportedFile.path);
  //             break;
  //           default:
  //         }
  //       }
  //     },
  //   );
  // }

  StoryContentDbModel _content(StoryDbModel story) {
    DateTime date = DateTime.now();
    return story.changes.isNotEmpty
        ? story.changes.last
        : StoryContentDbModel.create(
            createdAt: date,
            id: date.millisecondsSinceEpoch,
          );
  }

  Future<void> view(StoryDbModel story, BuildContext context) async {
    DetailArgs args = DetailArgs(initialStory: story, intialFlow: DetailViewFlowType.update);
    await Navigator.of(context).pushNamed(SpRouter.detail.path, arguments: args);
    reloadStory();
  }

  Widget buildMonogram(
    BuildContext context,
    StoryDbModel story,
    StoryDbModel? previousStory,
    Map<int, Color> dayColors,
  ) {
    // bool sameDay = previousStory?.path != null ? story.path.sameDayAs(previousStory!.path) : false;
    DateTime displayDate = story.toDateTime();
    return Container(
      color: M3Color.of(context).background,
      child: Column(
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
      ),
    );
  }

  double get contentRightMargin {
    return kToolbarHeight + 16;
  }

  Widget buildContent(BuildContext context, StoryDbModel story) {
    Set<String> images = {};
    StoryContentDbModel content = _content(story);

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
                    margin: EdgeInsets.only(bottom: ConfigConstant.margin0, right: contentRightMargin),
                    child: Text(
                      content.title ?? "content.title",
                      style: M3TextTheme.of(context).titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (content.plainText != null && content.plainText!.trim().length > 1)
                  Container(
                    margin: EdgeInsets.only(bottom: ConfigConstant.margin0, right: hasTitle ? 0 : contentRightMargin),
                    child: Consumer<TileMaxLineProvider>(builder: (context, provider, child) {
                      return Markdown(
                        data: body(content),
                        shrinkWrap: true,
                        styleSheet: MarkdownStyleSheet(
                          blockquoteDecoration: BoxDecoration(color: M3Color.of(context).tertiaryContainer),
                          blockquote: TextStyle(color: M3Color.of(context).onTertiaryContainer),
                          codeblockDecoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerColor)),
                        ),
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        softLineBreak: true,
                      );
                      // return ExpandableText(
                      //   body(content),
                      //   expandText: 'show more',
                      //   collapseText: "show less",
                      //   maxLines: provider.maxLine,
                      //   animation: true,
                      //   collapseOnTextTap: false,
                      //   style: M3TextTheme.of(context).bodyMedium?.copyWith(color: M3Color.of(context).onSurface),
                      //   linkColor: M3Color.of(context).onSurface,
                      //   linkStyle: const TextStyle(fontWeight: FontWeight.w300),
                      // );
                    }),
                  ),
                StoryTileChips(
                  images: images,
                  content: content,
                  story: story,
                ),
              ],
            ),
          ),
          buildTime(context, content),
        ],
      ),
    );
  }

  String body(StoryContentDbModel content) {
    String body = content.plainText?.trim() ?? "content.plainText";
    return body;
  }

  Widget buildTime(BuildContext context, StoryContentDbModel content) {
    return SpTapEffect(
      effects: const [SpTapEffectType.touchableOpacity],
      onTap: () => toggleStarred(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SpAnimatedIcons(
            showFirst: starred,
            secondChild: const SizedBox(),
            firstChild: Icon(
              Icons.favorite,
              size: ConfigConstant.iconSize1,
              color: starredColor,
            ),
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
