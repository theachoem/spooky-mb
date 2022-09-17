library sp_story_tile;

import 'dart:async';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/db/databases/story_database.dart';
import 'package:spooky/core/db/models/story_content_db_model.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';
import 'package:spooky/providers/cache_story_models_provider.dart';
import 'package:spooky/providers/tile_max_line_provider.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/app_helper.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:spooky/utils/mixins/schedule_mixin.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
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
  late final ValueNotifier<ChipsExpandLevelType> expandedLevelNotifier;
  late final StoryDatabase database;
  late final SpStoryTileUtils utils;

  late StoryDbModel _story;
  StoryDbModel get story => _story;

  Completer<bool>? completer;
  StoryDbModel? get previousStory => widget.previousStory;
  bool get starred => story.starred == true;
  Color? get starredColor => starred ? M3Color.of(context).error : null;

  @override
  void didUpdateWidget(covariant SpStoryTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    setStory(
      widget.story,
      reloadState: false,
      saveToCache: false,
      debugSource: "initState",
    );
  }

  @override
  void initState() {
    expandedLevelNotifier = ValueNotifier<ChipsExpandLevelType>(ChipsExpandLevelType.level1);
    database = StoryDatabase.instance;

    setStory(
      widget.story,
      reloadState: false,
      saveToCache: true,
      debugSource: "initState",
    );

    utils = SpStoryTileUtils(
      context: context,
      story: () => story,
      reloadList: widget.onRefresh,
      reloadStory: reloadStory,
      beforeAction: () => confirmStory(context),
      setStory: (StoryDbModel story, bool reloadState, bool saveToCache) {
        setStory(
          story,
          reloadState: reloadState,
          saveToCache: saveToCache,
          debugSource: "SpStoryTileUtils",
        );
      },
    );

    super.initState();
  }

  // confirm before update story
  Future<bool?> confirmStory(BuildContext context) async {
    bool hasIncompleteFuture = completer != null && !completer!.isCompleted;

    if (hasIncompleteFuture) {
      return MessengerService.instance.showLoading<bool>(
        context: context,
        debugSource: "_SpStoryTileState#view",
        future: () => completer!.future,
      );
    }

    return true;
  }

  void complete() {
    if (completer != null && !completer!.isCompleted) {
      completer?.complete(true);
    }
  }

  // complete with 5 seconds timeout
  void setCompleter() {
    completer = Completer();
    scheduleAction(
      () => complete(),
      duration: const Duration(seconds: 10),
    );
  }

  // reload current story only
  Future<void> reloadStory() async {
    setCompleter();
    StoryDbModel? storyResult = await CacheStoryModelsProvider.instance.get(story.id);

    if (storyResult != null) {
      setStory(
        storyResult,
        saveToCache: false,
        reloadState: true,
        debugSource: "reloadStory",
      );
    } else {
      await widget.onRefresh();
    }

    complete();
  }

  Future<bool> toggleStarred() async {
    return utils.refreshSuccess(
      () async {
        StoryDbModel copiedStory = story.copyWith(starred: !starred);
        setStory(
          copiedStory,
          saveToCache: true,
          reloadState: true,
          debugSource: "toggleStarred",
        );
        await database.update(id: copiedStory.id, body: copiedStory);
        return true;
      },
      refreshList: false,
      refreshStory: true,
    );
  }

  Future<bool> replaceContent(StoryContentDbModel content) async {
    return utils.refreshSuccess(
      () async {
        StoryDbModel copiedStory = story.copyWith()..addChange(content);
        setStory(
          copiedStory,
          saveToCache: true,
          reloadState: true,
          debugSource: "replaceContent",
        );
        await database.update(id: copiedStory.id, body: copiedStory);
        return true;
      },
      refreshList: false,
      refreshStory: true,
    );
  }

  Future<void> view(BuildContext context) async {
    await confirmStory(context);
    bool hasIncompleteFuture = completer != null && !completer!.isCompleted;

    if (hasIncompleteFuture) {
      await MessengerService.instance.showLoading(
        context: context,
        debugSource: "_SpStoryTileState#view",
        future: () => completer!.future,
      );
    }

    if (story.viewOnly) {
      // ignore: use_build_context_synchronously
      await Navigator.of(context).pushNamed(
        SpRouter.contentReader.path,
        arguments: ContentReaderArgs(content: story.changes.last),
      );
    } else {
      // ignore: use_build_context_synchronously
      StoryDbModel? storyResult = await CacheStoryModelsProvider.instance.get(story.id);

      // ignore: use_build_context_synchronously
      await Navigator.of(context).pushNamed(
        SpRouter.detail.path,
        arguments: DetailArgs(
          initialStory: storyResult ?? story,
          intialFlow: DetailViewFlowType.update,
        ),
      );

      reloadStory();
    }
  }

  @override
  void dispose() {
    expandedLevelNotifier.dispose();
    super.dispose();
  }

  void setStory(
    StoryDbModel story, {
    required bool reloadState,
    required bool saveToCache,
    required String debugSource,
  }) {
    if (saveToCache) {
      CacheStoryModelsProvider.instance.update(
        story,
        debugSource: "$runtimeType#$debugSource",
      );
    }

    if (reloadState) {
      setState(() {
        _story = story;
      });
    } else {
      _story = story;
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
          onTap: () => view(context),
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
      expandedLevelNotifier: expandedLevelNotifier,
      toggleExpand: () {
        switch (expandedLevelNotifier.value) {
          case ChipsExpandLevelType.level1:
            expandedLevelNotifier.value = ChipsExpandLevelType.level2;
            break;
          case ChipsExpandLevelType.level2:
            expandedLevelNotifier.value = ChipsExpandLevelType.level3;
            break;
          case ChipsExpandLevelType.level3:
            expandedLevelNotifier.value = ChipsExpandLevelType.level1;
            break;
        }
      },
    );
    if (widget.gridLayout) {
      return _GridItemContent(options: options);
    } else {
      return _ListStoryTileContent(options: options);
    }
  }

  SpPopMenuItem _buildViewItem(BuildContext context) {
    return SpPopMenuItem(
      title: tr("button.view"),
      leadingIconData: Icons.chrome_reader_mode,
      onPressed: () => view(context),
    );
  }

  SpPopMenuItem _buildStarredItem() {
    return SpPopMenuItem(
      title: starred ? tr("button.unstarred") : tr("button.starred"),
      leadingIconData: starred ? Icons.favorite : Icons.favorite_border,
      onPressed: () => toggleStarred(),
    );
  }

  SpPopMenuItem _buildDeleteItem(BuildContext context) {
    return SpPopMenuItem(
      title: tr("button.delete"),
      leadingIconData: Icons.delete,
      titleStyle: TextStyle(color: M3Color.of(context).error),
      onPressed: () => utils.refreshSuccess(utils.deleteStory, refreshList: true, refreshStory: false),
    );
  }

  SpPopMenuItem _buildPutBackItem() {
    return SpPopMenuItem(
      title: tr("button.put_back"),
      leadingIconData: Icons.restore_from_trash,
      onPressed: () => utils.refreshSuccess(utils.putBackStory, refreshList: true, refreshStory: false),
    );
  }

  SpPopMenuItem _buildArchiveItem() {
    return SpPopMenuItem(
      title: tr("button.archive"),
      leadingIconData: Icons.archive,
      onPressed: () => utils.refreshSuccess(utils.archiveStory, refreshList: true, refreshStory: false),
    );
  }

  SpPopMenuItem _buildChangeTimeItem(BuildContext context) {
    return SpPopMenuItem(
      title: tr("button.change_time"),
      leadingIconData: CommunityMaterialIcons.clock,
      onPressed: () => utils.refreshSuccess(utils.changeStoryTime, refreshList: true, refreshStory: true),
    );
  }

  SpPopMenuItem _buildChangeDateItem(BuildContext context) {
    return SpPopMenuItem(
      title: tr("button.change_date"),
      leadingIconData: CommunityMaterialIcons.calendar,
      onPressed: () => utils.refreshSuccess(utils.changeStoryDate, refreshList: true, refreshStory: true),
    );
  }
}
