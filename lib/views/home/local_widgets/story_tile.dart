import 'package:community_material_icon/community_material_icon.dart';
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
import 'package:spooky/theme/theme_config.dart';
import 'package:spooky/utils/helpers/app_helper.dart';
import 'package:spooky/views/home/local_widgets/story_tile_chips.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:spooky/utils/helpers/quill_helper.dart';
import 'package:spooky/utils/util_widgets/sp_date_picker.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart' as dn;

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
    this.onPutBack,
  }) : super(key: key);

  final StoryDbModel story;
  final StoryDbModel? previousStory;
  final BuildContext context;
  final EdgeInsets itemPadding;
  final Future<void> Function() onRefresh;
  final Future<bool> Function(StoryDbModel story)? onDelete;
  final Future<bool> Function(StoryDbModel story)? onArchive;
  final Future<bool> Function(StoryDbModel story)? onUnarchive;
  final Future<bool> Function(StoryDbModel story)? onPutBack;

  @override
  StoryTileState createState() => StoryTileState();
}

class StoryTileState extends State<StoryTile> {
  final StoryDatabase database = StoryDatabase.instance;
  late final ValueNotifier<bool> loadingNotifier;

  StoryDbModel? get previousStory => widget.previousStory;

  bool get starred => story.starred == true;
  Color? get starredColor => starred ? M3Color.of(context).error : null;

  late StoryDbModel story;

  // reload current story only
  Future<void> reloadStory() async {
    StoryDbModel? storyResult = await database.fetchOne(id: story.id);
    if (storyResult != null) {
      setState(() => story = storyResult);
    } else {
      widget.onRefresh();
    }
  }

  Future<void> toggleStarred() async {
    StoryDbModel copiedStory = story.copyWith(starred: !starred);
    setState(() => story = copiedStory);
    await database.update(id: copiedStory.id, body: copiedStory.toJson());
  }

  Future<void> replaceContent(StoryContentDbModel content) async {
    StoryDbModel copiedStory = story.copyWith();
    copiedStory.addChange(content);
    StoryDbModel? updatedStory = await database.update(id: copiedStory.id, body: copiedStory.toJson());
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
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<int, Color> dayColors = M3Color.dayColorsOf(context);
    return SpPopupMenuButton(
      dxGetter: (double dx) => MediaQuery.of(context).size.width,
      dyGetter: (double dy) => dy + ConfigConstant.margin2,
      builder: (callback) {
        return SpTapEffect(
          onLongPressed: () => callback(),
          onTap: () => view(story, context),
          child: Container(
            padding: widget.itemPadding,
            color: Colors.transparent,
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
          if (story.viewOnly)
            SpPopMenuItem(
              title: "View",
              leadingIconData: Icons.chrome_reader_mode,
              onPressed: () => view(story, context),
            ),
          if (story.editable)
            SpPopMenuItem(
              title: "Change Date",
              leadingIconData: CommunityMaterialIcons.calendar,
              onPressed: () async {
                DateTime? pathDate = await SpDatePicker.showDatePicker(
                  context,
                  story.displayPathDate,
                );

                if (pathDate != null) {
                  await database.updatePathDate(story, pathDate);
                  if (database.error == null) {
                    widget.onRefresh();
                  }
                }
              },
            ),
          if (story.editable)
            SpPopMenuItem(
              title: "Change Time",
              leadingIconData: CommunityMaterialIcons.clock,
              onPressed: () async {
                TimeOfDay? time;

                await Navigator.of(context).push(
                  dn.showPicker(
                    context: context,
                    value: TimeOfDay.fromDateTime(story.displayPathDate),
                    okStyle: TextStyle(fontFamily: M3TextTheme.of(context).labelLarge?.fontFamily),
                    cancelStyle: TextStyle(fontFamily: M3TextTheme.of(context).labelLarge?.fontFamily),
                    buttonStyle: ThemeConfig.isApple(Theme.of(context).platform)
                        ? ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent))
                        : null,
                    onCancel: () {
                      Navigator.of(context).pop();
                    },
                    onChangeDateTime: (date) => time = TimeOfDay.fromDateTime(date),
                    onChange: (t) => time = t,
                  ),
                );

                if (time != null) {
                  StoryDbModel? result = await database.updatePathTime(story, time!);
                  if (result != null) reloadStory();
                }
              },
            ),
          if (story.archivable && widget.onArchive != null)
            SpPopMenuItem(
              title: "Archive",
              leadingIconData: Icons.archive,
              onPressed: () async {
                widget.onArchive!(story);
              },
            ),
          if (story.editable)
            SpPopMenuItem(
              title: starred ? "Unstarred" : "Starred",
              leadingIconData: starred ? Icons.favorite : Icons.favorite_border,
              onPressed: () => toggleStarred(),
            ),
          if (story.putBackAble && widget.onPutBack != null)
            SpPopMenuItem(
              title: "Put back",
              leadingIconData: Icons.restore_from_trash,
              onPressed: () async {
                widget.onPutBack!(story);
              },
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
    if (story.viewOnly) {
      await Navigator.of(context).pushNamed(
        SpRouter.contentReader.path,
        arguments: ContentReaderArgs(content: story.changes.last),
      );
    } else {
      DetailArgs args = DetailArgs(initialStory: story, intialFlow: DetailViewFlowType.update);
      await Navigator.of(context).pushNamed(SpRouter.detail.path, arguments: args);
      reloadStory();
    }
  }

  Widget buildMonogram(
    BuildContext context,
    StoryDbModel story,
    StoryDbModel? previousStory,
    Map<int, Color> dayColors,
  ) {
    // bool sameDay = previousStory?.path != null ? story.path.sameDayAs(previousStory!.path) : false;
    DateTime displayDate = story.displayPathDate;
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
                buildTitleBody(hasTitle, content, context),
                StoryTileChips(
                  images: images,
                  content: content,
                  story: story,
                  onImageUploaded: (content) => replaceContent(content),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            child: buildTime(context, content),
          ),
        ],
      ),
    );
  }

  Column buildTitleBody(bool hasTitle, StoryContentDbModel content, BuildContext context) {
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
          if (content.draft == true)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: ConfigConstant.margin0),
              child: Icon(
                Icons.edit_note,
                size: ConfigConstant.iconSize1,
              ),
            ),
          Text(
            DateFormatHelper.timeFormat().format(story.displayPathDate),
            style: M3TextTheme.of(context).bodySmall,
          ),
        ],
      ),
    );
  }
}
