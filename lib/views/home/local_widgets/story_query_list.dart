import 'dart:async';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/db/databases/story_database.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/models/story_query_options_model.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/core/storages/local_storages/last_update_story_list_hash_storage.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:spooky/views/home/local_widgets/story_list.dart';

class StoryQueryList extends StatefulWidget {
  const StoryQueryList({
    Key? key,
    required this.queryOptions,
  }) : super(key: key);

  final StoryQueryOptionsModel queryOptions;

  @override
  State<StoryQueryList> createState() => _StoryListState();
}

class _StoryListState extends State<StoryQueryList> with AutomaticKeepAliveClientMixin, RouteAware {
  final StoryDatabase database = StoryDatabase();
  final LastUpdateStoryListHashStorage hashStorage = LastUpdateStoryListHashStorage();
  List<StoryDbModel>? stories;

  // this just to prevent from load multiple time
  // not for UI
  bool? loadingFlag;
  int? hash;

  @override
  void initState() {
    super.initState();
    load();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ModalRoute? modalRoute = ModalRoute.of(context);
      if (modalRoute != null) App.storyQueryListObserver.subscribe(this, modalRoute);
    });
  }

  @override
  void dispose() {
    super.dispose();
    App.storyQueryListObserver.unsubscribe(this);
  }

  Future<void> loadHash() async {
    hash = await hashStorage.read();
  }

  Future<List<StoryDbModel>> _fetchStory() async {
    final list = await database.fetchAll(params: widget.queryOptions.toJson());
    List<StoryDbModel> result = list?.items ?? [];
    loadHash();
    return result;
  }

  Future<void> load([bool callFromRefresh = false]) async {
    if (loadingFlag == true) return;

    final completer = Completer();
    if (stories != null && !callFromRefresh) {
      loadingFlag = true;
      MessengerService.instance.showLoading(future: () => completer.future, context: context).then((value) {
        loadingFlag = false;
      });
    }

    final result = await _fetchStory();
    if (result != stories) {
      setState(() {
        stories = result;
      });
    }

    completer.complete(1);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkUpdatation(widget);
  }

  @override
  void didUpdateWidget(covariant StoryQueryList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _checkUpdatation(oldWidget);
  }

  void _checkUpdatation(StoryQueryList? oldWidget) {
    bool didUpdateQueries = oldWidget != null && oldWidget.queryOptions.join() != widget.queryOptions.join();
    hashStorage.read().then((hash) {
      if (this.hash != hash || didUpdateQueries) {
        load();
      }
    });
  }

  Future<bool> onDelete(StoryDbModel story) async {
    OkCancelResult result = await showOkCancelAlertDialog(
      context: context,
      title: "Are you sure to delete?",
      message: "You can't undo this action",
      okLabel: "Delete",
      isDestructiveAction: true,
    );
    switch (result) {
      case OkCancelResult.ok:
        await database.deleteDocument(story);
        bool success = database.error == null;
        String message = success ? "Delete successfully!" : "Delete unsuccessfully!";
        MessengerService.instance.showSnackBar(message);
        return success;
      case OkCancelResult.cancel:
        return false;
    }
  }

  Future<bool> onToggleArchive(
    StoryDbModel story, {
    required bool archived,
  }) async {
    String? date = DateFormatHelper.yM().format(story.toDateTime());
    String title, message, label;

    if (archived) {
      title = "Are you sure to unarchive?";
      message = "Document will be move to:\n$date";
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
        archived ? await database.unarchiveDocument(story) : await database.archiveDocument(story);
        bool success = database.error == null;
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
      onRefresh: () => load(true),
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
  void didPopNext() {
    super.didPopNext();
    _checkUpdatation(null);
  }

  @override
  void didPushNext() {
    super.didPushNext();
    _checkUpdatation(null);
  }

  @override
  bool get wantKeepAlive => true;
}
