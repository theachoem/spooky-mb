import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:spooky/core/file_manager/managers/export_file_manager.dart';
import 'package:spooky/core/file_manager/managers/story_manager.dart';
import 'package:spooky/core/file_manager/managers/archive_file_manager.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/routes/sp_router.dart';
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
    this.previousStory,
  }) : super(key: key);

  final StoryModel story;
  final StoryModel? previousStory;
  final BuildContext context;
  final EdgeInsets itemPadding;
  final Future<void> Function() onRefresh;

  @override
  _StoryTileState createState() => _StoryTileState();
}

class _StoryTileState extends State<StoryTile> {
  final ArchiveFileManager manager = ArchiveFileManager();
  final StoryManager storyManager = StoryManager();
  late final ValueNotifier<bool> loadingNotifier;

  StoryModel? get previousStory => widget.previousStory;

  bool get starred => _content(story).starred == true;
  Color? get starredColor => starred ? M3Color.of(context).error : null;

  late StoryModel story;

  // reload current story only
  Future<void> reloadStory() async {
    StoryModel? _story = await storyManager.fetchOne(story.writableFile);
    if (_story != null) {
      setState(() => story = _story);
    } else {
      widget.onRefresh();
    }
  }

  Future<void> toggleStarred() async {
    StoryModel _story = story.copyWithStarred(!starred);
    FileSystemEntity? file = await storyManager.write(_story.writableFile, _story);
    if (file != null) await reloadStory();
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
          if (!manager.canArchive(story))
            SpPopMenuItem(
              title: "View",
              leadingIconData: Icons.chrome_reader_mode,
              onPressed: () => view(story, context),
            ),
          if (manager.canArchive(story))
            SpPopMenuItem(
              title: "Change Date",
              leadingIconData: Icons.folder_open,
              onPressed: () async {
                DateTime? pathDate = await SpDatePicker.showDatePicker(
                  context,
                  story.path.toDateTime(),
                );

                if (pathDate != null) {
                  FileSystemEntity? file = await storyManager.updatePathDate(story, pathDate);
                  if (file != null) {
                    widget.onRefresh();
                  }
                }
              },
            ),
          if (manager.canArchive(story))
            SpPopMenuItem(
              title: "Archive",
              leadingIconData: Icons.archive,
              onPressed: () async {
                File? file = await manager.archiveDocument(story);
                if (file != null) {
                  widget.onRefresh();
                }
              },
            ),
          SpPopMenuItem(
            title: starred ? "Unstarred" : "Starred",
            leadingIconData: starred ? Icons.favorite : Icons.favorite_border,
            titleStyle: TextStyle(color: starredColor),
            onPressed: () => toggleStarred(),
          ),
          buildExportOption(context, story),
        ];
      },
    );
  }

  SpPopMenuItem buildExportOption(BuildContext context, StoryModel model) {
    final manager = ExportFileManager();
    FileSystemEntity? exportedFile = manager.hasExported(model.file);
    bool hasExported = exportedFile != null;
    return SpPopMenuItem(
      title: hasExported ? "Exported" : "Export",
      leadingIconData: hasExported ? Icons.download_done : Icons.download,
      onPressed: () async {
        if (model.file != null && !hasExported) await manager.exportFile(model.file!);
        FileSystemEntity? exportedFile = manager.hasExported(model.file);
        if (exportedFile != null) {
          String? clickedKey = await showModalActionSheet(
            context: context,
            title: "Exported",
            message: manager.displayPath(exportedFile),
            actions: [
              const SheetAction(
                label: "Open File",
                key: "open",
              ),
            ],
          );
          switch (clickedKey) {
            case "open":
              await OpenFile.open(exportedFile.path);
              break;
            default:
          }
        }
      },
    );
  }

  StoryContentModel _content(StoryModel story) {
    DateTime date = DateTime.now();
    return story.changes.isNotEmpty
        ? story.changes.last
        : StoryContentModel.create(
            createdAt: date,
            id: date.millisecondsSinceEpoch.toString(),
          );
  }

  Future<void> view(StoryModel story, BuildContext context) async {
    DetailArgs args = DetailArgs(initialStory: story, intialFlow: DetailViewFlowType.update);
    await Navigator.of(context).pushNamed(SpRouter.detail.path, arguments: args);
    reloadStory();
  }

  Widget buildMonogram(
    BuildContext context,
    StoryModel story,
    StoryModel? previousStory,
    Map<int, Color> dayColors,
  ) {
    // bool sameDay = previousStory?.path != null ? story.path.sameDayAs(previousStory!.path) : false;
    DateTime displayDate = story.path.toDateTime();
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

  Widget buildContent(BuildContext context, StoryModel story) {
    Set<String> images = {};
    StoryContentModel content = _content(story);

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
                    child: ExpandableText(
                      body(content),
                      expandText: 'show more',
                      collapseText: "show less",
                      maxLines: 5,
                      animation: true,
                      collapseOnTextTap: false,
                      style: M3TextTheme.of(context).bodyMedium?.copyWith(color: M3Color.of(context).onSurface),
                      linkColor: M3Color.of(context).onSurface,
                      linkStyle: const TextStyle(fontWeight: FontWeight.w300),
                    ),
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

  String body(StoryContentModel content) {
    String _body = content.plainText?.trim() ?? "content.plainText";
    return _body;
  }

  Widget buildTime(BuildContext context, StoryContentModel content) {
    return Row(
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
    );
  }
}
