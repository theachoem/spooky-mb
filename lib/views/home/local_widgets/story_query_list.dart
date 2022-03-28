import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/file_manager/managers/archive_file_manager.dart';
import 'package:spooky/core/file_manager/managers/story_manager.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/models/story_query_options_model.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/core/storages/local_storages/sort_type_storage.dart';
import 'package:spooky/core/types/sort_type.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:spooky/views/home/local_widgets/story_list.dart';

class StoryQueryList extends StatefulWidget {
  const StoryQueryList({
    Key? key,
    required this.queryOptions,
    required this.onListReloaderReady,
  }) : super(key: key);

  final StoryQueryOptionsModel queryOptions;
  final void Function(void Function() callback) onListReloaderReady;

  @override
  State<StoryQueryList> createState() => _StoryListState();
}

class _StoryListState extends State<StoryQueryList> with AutomaticKeepAliveClientMixin {
  final StoryManager storyManager = StoryManager();
  final ArchiveFileManager fileManager = ArchiveFileManager();
  List<StoryModel>? stories;

  @override
  void initState() {
    super.initState();

    load();
    setDayColors();

    widget.onListReloaderReady(load);
  }

  void setDayColors() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {});
  }

  DateTime dateForCompare(StoryModel story) {
    return story.path.toDateTime();
  }

  Future<void> load() async {
    SortType? sortType = await SortTypeStorage().readEnum();
    List<StoryModel> result = await storyManager.fetchAll(options: widget.queryOptions) ?? [];

    switch (sortType) {
      case SortType.oldToNew:
      case null:
        result.sort((a, b) => (dateForCompare(a)).compareTo(dateForCompare(b)));
        break;
      case SortType.newToOld:
        result.sort((a, b) => (dateForCompare(a)).compareTo(dateForCompare(b)));
        result = result.reversed.toList();
        break;
      case SortType.starred:
        result.sort(((a, b) => b.starred == true ? 1 : -1));
    }

    if (result != stories) {
      setState(() {
        stories = result;
      });
    }
  }

  @override
  void didUpdateWidget(covariant StoryQueryList oldWidget) {
    super.didUpdateWidget(oldWidget);
    setDayColors();
    if (oldWidget.queryOptions.toPath() != widget.queryOptions.toPath()) load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setDayColors();
  }

  Future<bool> onDelete(StoryModel story) async {
    OkCancelResult result = await showOkCancelAlertDialog(
      context: context,
      title: "Are you sure to delete?",
      message: "You can't undo this action",
      okLabel: "Delete",
      isDestructiveAction: true,
    );
    switch (result) {
      case OkCancelResult.ok:
        FileSystemEntity? file = await fileManager.deleteDocument(story);
        bool success = file != null;
        String message = success ? "Delete successfully!" : "Delete unsuccessfully!";
        MessengerService.instance.showSnackBar(message);
        return success;
      case OkCancelResult.cancel:
        return false;
    }
  }

  Future<bool> onToggleArchive(
    StoryModel story, {
    required bool archived,
  }) async {
    String? date = DateFormatHelper.yM().format(story.path.toDateTime());
    String title, message, label;

    if (archived) {
      title = "Are you sure to unarchive?";
      message = "Document will be move to:\n" + date;
      label = "Unarchive";
    } else {
      title = "Are you sure to archive?";
      message = "You can unarchive later.";
      label = "Archive";
    }

    OkCancelResult result = await showOkCancelAlertDialog(
      context: context,
      title: title,
      message: message,
      okLabel: label,
    );

    switch (result) {
      case OkCancelResult.ok:
        File? file = archived ? await fileManager.unarchiveDocument(story) : await fileManager.archiveDocument(story);
        bool success = file != null;
        String message = success ? "Successfully!" : "Unsuccessfully!";
        MessengerService.instance.showSnackBar(message, success: success);
        return success;
      case OkCancelResult.cancel:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoryList(
      onRefresh: () => load(),
      stories: stories,
      emptyMessage: "Empty",
      onDelete: (story) async {
        bool success = await onDelete(story);
        if (success) await load();
        return success;
      },
      onArchive: (story) async {
        bool success = await onToggleArchive(story, archived: false);
        if (success) await load();
        return success;
      },
      onUnarchive: (story) async {
        bool success = await onToggleArchive(story, archived: true);
        if (success) await load();
        return success;
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
