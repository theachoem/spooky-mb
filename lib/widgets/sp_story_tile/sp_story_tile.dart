library sp_story_tile;

import 'dart:async';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/db/databases/story_database.dart';
import 'package:spooky/core/db/models/story_content_db_model.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';
import 'package:spooky/providers/tile_max_line_provider.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/app_helper.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:spooky/utils/helpers/quill_helper.dart';
import 'package:spooky/utils/mixins/schedule_mixin.dart';
import 'package:spooky/widgets/sp_story_tile/widgets/story_tile_chips.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';
import 'package:spooky/widgets/sp_story_tile/sp_story_tile_util.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';

part 'contents/base_tile_content.dart';
part 'contents/grid_item_content.dart';
part 'contents/list_item_content.dart';
part 'contents/tile_content_options.dart';

class SpStoryTile extends StatefulWidget {
  const SpStoryTile({
    Key? key,
    this.previousStory,
    required this.story,
    required this.gridLayout,
    required this.onRefresh,
    this.itemPadding = const EdgeInsets.all(ConfigConstant.margin2),
  }) : super(key: key);

  final EdgeInsets itemPadding;
  final bool gridLayout;
  final StoryDbModel story;
  final StoryDbModel? previousStory;
  final Future<void> Function() onRefresh;

  @override
  State<SpStoryTile> createState() => _SpStoryTileState();
}

class _SpStoryTileState extends State<SpStoryTile> with ScheduleMixin {
  late final StoryDatabase database;
  late final SpStoryTileUtils utils;
  late StoryDbModel story;

  Completer<int>? _completer;

  StoryDbModel? get previousStory => widget.previousStory;
  bool get starred => story.starred == true;
  Color? get starredColor => starred ? M3Color.of(context).error : null;

  @override
  void initState() {
    database = StoryDatabase.instance;
    story = widget.story;
    utils = SpStoryTileUtils(
      context: context,
      story: story,
      reloadList: () => widget.onRefresh(),
      reloadStory: () => reloadStory(),
    );
    super.initState();
  }

  Completer<int> setComputer() {
    _completer = Completer<int>();
    scheduleAction(() {
      completeLoading();
    }, duration: const Duration(seconds: 5));
    return _completer!;
  }

  void completeLoading() {
    if (_completer != null && !_completer!.isCompleted) {
      _completer?.complete(1);
    }
  }

  // reload current story only
  Future<void> reloadStory() async {
    setComputer();
    StoryDbModel? storyResult = await database.fetchOne(id: story.id);
    if (storyResult != null) {
      setState(() => story = storyResult);
      completeLoading();
    } else {
      await widget.onRefresh();
      completeLoading();
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

  Future<void> view(StoryDbModel story, BuildContext context) async {
    if (_completer != null && !_completer!.isCompleted) {
      await MessengerService.instance.showLoading(
        future: () => _completer!.future,
        context: context,
        debugSource: "_SpStoryTileState#view",
      );
    }

    if (story.viewOnly) {
      // ignore: use_build_context_synchronously
      await Navigator.of(context).pushNamed(
        SpRouter.contentReader.path,
        arguments: ContentReaderArgs(content: story.changes.last),
      );
    } else {
      Stopwatch stopwatch = Stopwatch()..start();

      // ignore: use_build_context_synchronously
      await Navigator.of(context).pushNamed(
        SpRouter.detail.path,
        arguments: DetailArgs(
          initialStory: story,
          intialFlow: DetailViewFlowType.update,
        ),
      );

      // Play around to avoid always reload
      stopwatch.stop();
      if (stopwatch.elapsedMilliseconds > 1000) {
        reloadStory();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SpPopupMenuButton(
      dxGetter: (double dx) => MediaQuery.of(context).size.width,
      dyGetter: (double dy) => dy + ConfigConstant.margin2,
      items: (BuildContext context) {
        return [
          if (story.viewOnly) _buildViewItem(context),
          if (story.editable) _buildChangeDateItem(context),
          if (story.editable) _buildChangeTimeItem(context),
          if (story.archivable) _buildArchiveItem(),
          if (story.editable) _buildStarredItem(),
          if (story.putBackAble) _buildPutBackItem(),
          _buildDeleteItem(context),
        ];
      },
      builder: (callback) {
        return SpTapEffect(
          onLongPressed: () => callback(),
          onTap: () => view(widget.story, context),
          child: Padding(
            padding: widget.itemPadding,
            child: buildTileContent(),
          ),
        );
      },
    );
  }

  Widget buildTileContent() {
    _TileContentOptions options = _TileContentOptions(
      context: context,
      story: story,
      previousStory: previousStory,
      replaceContent: replaceContent,
      toggleStarred: toggleStarred,
    );
    if (widget.gridLayout) {
      return _GridItemContent(options: options);
    } else {
      return _ListStoryTileContent(options: options);
    }
  }

  SpPopMenuItem _buildViewItem(BuildContext context) {
    return SpPopMenuItem(
      title: "View",
      leadingIconData: Icons.chrome_reader_mode,
      onPressed: () => view(story, context),
    );
  }

  SpPopMenuItem _buildDeleteItem(BuildContext context) {
    return SpPopMenuItem(
      title: "Delete",
      leadingIconData: Icons.delete,
      titleStyle: TextStyle(color: M3Color.of(context).error),
      onPressed: () => utils.refreshSuccess(utils.deleteStory),
    );
  }

  SpPopMenuItem _buildPutBackItem() {
    return SpPopMenuItem(
      title: "Put back",
      leadingIconData: Icons.restore_from_trash,
      onPressed: () => utils.refreshSuccess(utils.putBackStory),
    );
  }

  SpPopMenuItem _buildArchiveItem() {
    return SpPopMenuItem(
      title: "Archive",
      leadingIconData: Icons.archive,
      onPressed: () => utils.refreshSuccess(utils.archiveStory),
    );
  }

  SpPopMenuItem _buildStarredItem() {
    return SpPopMenuItem(
      title: starred ? "Unstarred" : "Starred",
      leadingIconData: starred ? Icons.favorite : Icons.favorite_border,
      onPressed: () => toggleStarred(),
    );
  }

  SpPopMenuItem _buildChangeTimeItem(BuildContext context) {
    return SpPopMenuItem(
      title: "Change Time",
      leadingIconData: CommunityMaterialIcons.clock,
      onPressed: () => utils.refreshSuccess(utils.changeStoryTime),
    );
  }

  SpPopMenuItem _buildChangeDateItem(BuildContext context) {
    return SpPopMenuItem(
      title: "Change Date",
      leadingIconData: CommunityMaterialIcons.calendar,
      onPressed: () => utils.refreshSuccess(utils.changeStoryDate),
    );
  }
}
