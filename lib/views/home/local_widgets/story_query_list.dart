import 'dart:async';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/db/databases/story_database.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/models/story_query_options_model.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/core/storages/local_storages/last_update_story_list_hash_storage.dart';
import 'package:spooky/core/types/list_layout_type.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:spooky/utils/constants/app_constant.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:spooky/views/home/local_widgets/story_list.dart';

class StoryQueryList extends StatefulWidget {
  const StoryQueryList({
    Key? key,
    required this.queryOptions,
    this.overridedLayout,
  }) : super(key: key);

  final StoryQueryOptionsModel queryOptions;
  final ListLayoutType? overridedLayout;

  @override
  State<StoryQueryList> createState() => _StoryListState();
}

class _StoryListState extends State<StoryQueryList> with AutomaticKeepAliveClientMixin, RouteAware {
  final StoryDatabase database = StoryDatabase.instance;
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
    try {
      hash = await hashStorage.read();
    } catch (e) {
      hashStorage.remove();
      if (kDebugMode) {
        print("ERROR: loadHash $e");
      }
    }
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
      MessengerService.instance
          .showLoading(
            future: () => completer.future,
            context: context,
            debugSource: "StoryQueryList#load",
          )
          .then((value) => loadingFlag = false);
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
  void didUpdateWidget(covariant StoryQueryList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _checkUpdatation(oldWidget);
  }

  void _checkUpdatation(StoryQueryList? oldWidget) {
    bool didUpdateQueries = oldWidget != null && oldWidget.queryOptions.join() != widget.queryOptions.join();
    hashStorage.read().then((hash) {
      if (this.hash != hash || didUpdateQueries) {
        load(true);
      }
    });
  }

  Future<bool> onDelete(StoryDbModel story) async {
    OkCancelResult result;

    switch (story.type) {
      case PathType.docs:
      case PathType.archives:
        result = await showOkCancelAlertDialog(
          context: context,
          title: "Move to Bin",
          message: "You story will be deleted in ${AppConstant.deleteInDuration.inDays} days.",
          okLabel: "Move to Bin",
          isDestructiveAction: true,
        );

        switch (result) {
          case OkCancelResult.ok:
            await database.moveToTrash(story);
            bool success = database.error == null;
            String message = success ? "Moved to bin" : "Move unsuccessfully!";
            MessengerService.instance.showSnackBar(message, success: success);
            return success;
          case OkCancelResult.cancel:
            return false;
        }
      case PathType.bins:
        result = await showOkCancelAlertDialog(
          context: context,
          title: "Are you sure to delete?",
          message: "You can't undo this action",
          okLabel: "Delete Forever",
          isDestructiveAction: true,
        );
        switch (result) {
          case OkCancelResult.ok:
            await database.deleteDocument(story);
            bool success = database.error == null;
            String message = success ? "Delete successfully!" : "Delete unsuccessfully!";
            MessengerService.instance.showSnackBar(message, success: success, action: (foreground) {
              return SnackBarAction(
                // ignore: use_build_context_synchronously
                label: "Undo",
                textColor: foreground,
                onPressed: () async {
                  await database.create(body: story.toJson());
                  load();
                },
              );
            });
            return success;
          case OkCancelResult.cancel:
            return false;
        }
    }
  }

  Future<bool> onPutBack(StoryDbModel story) async {
    String? date = DateFormatHelper.yM().format(story.displayPathDate);
    String title, message, label;

    title = "Are you sure put back?";
    message = "Document will be move to:\n$date";
    label = "Put back";

    OkCancelResult result = await showOkCancelAlertDialog(
      context: context,
      title: title,
      message: message,
      okLabel: label,
    );

    switch (result) {
      case OkCancelResult.ok:
        await database.putBackToDocs(story);
        bool success = database.error == null;
        String message = success ? "Successfully!" : "Unsuccessfully!";
        MessengerService.instance.showSnackBar(message, success: success);
        return success;
      case OkCancelResult.cancel:
        return false;
    }
  }

  Future<bool> onArchive(StoryDbModel story) async {
    String title, message, label;

    title = "Are you sure to archive?";
    message = "You can unarchive later.";
    label = "Archive";

    OkCancelResult result = await showOkCancelAlertDialog(
      context: context,
      title: title,
      message: message,
      okLabel: label,
    );

    switch (result) {
      case OkCancelResult.ok:
        await database.archiveDocument(story);
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
    if (kDebugMode) {
      print("BUILD: StoryQueryList");
    }
    return StoryList(
      onRefresh: () => load(true),
      stories: stories,
      emptyMessage: "Empty",
      pathType: widget.queryOptions.type,
      overridedLayout: widget.overridedLayout,
      onDelete: (story) async {
        bool success = await onDelete(story);
        if (success) await load();
        return success;
      },
      onArchive: (story) async {
        bool success = await onArchive(story);
        if (success) await load();
        return success;
      },
      onUnarchive: (story) async {
        bool success = await onPutBack(story);
        if (success) await load();
        return success;
      },
      onPutBack: (story) async {
        bool success = await onPutBack(story);
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
