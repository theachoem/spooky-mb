import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/db/databases/story_database.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/models/story_query_options_model.dart';
import 'package:spooky/core/storages/local_storages/last_update_story_list_hash_storage.dart';
import 'package:spooky/utils/mixins/schedule_mixin.dart';
import 'package:spooky/widgets/sp_story_list/sp_story_list.dart';

class StoryQueryList extends StatefulWidget {
  const StoryQueryList({
    Key? key,
    required this.queryOptions,
    this.overridedLayout,
    this.hasDifferentYear = true,
  }) : super(key: key);

  final StoryQueryOptionsModel? queryOptions;
  final SpListLayoutType? overridedLayout;
  final bool hasDifferentYear;

  @override
  State<StoryQueryList> createState() => _StoryListState();
}

class _StoryListState extends State<StoryQueryList> with AutomaticKeepAliveClientMixin, RouteAware, ScheduleMixin {
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
    load("initState");
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
    if (widget.queryOptions != null) {
      final list = await database.fetchAll(params: widget.queryOptions?.toJson());
      List<StoryDbModel> result = list?.items ?? [];
      await loadHash();
      return result;
    } else {
      await loadHash();
      return [];
    }
  }

  Future<void> load(String source, [bool showLoading = false]) async {
    if (showLoading) setState(() => stories = null);
    final result = await _fetchStory();
    setState(() => stories = result);
  }

  @override
  void didUpdateWidget(covariant StoryQueryList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _checkUpdatation(oldWidget, "didUpdateWidget");
  }

  void _checkUpdatation(StoryQueryList? oldWidget, String source) async {
    bool didUpdateQueries = oldWidget != null && oldWidget.queryOptions?.join() != widget.queryOptions?.join();
    bool hasChanged = await hashStorage.shouldReloadList(hash);
    if (hasChanged) {
      load(source, false);
    } else if (didUpdateQueries) {
      load(source, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (kDebugMode) {
      print("BUILD: StoryQueryList");
    }

    return SpStoryList(
      onRefresh: () => load("build"),
      overridedLayout: widget.overridedLayout,
      stories: stories,
      hasDifferentYear: widget.hasDifferentYear,
      uiQueryOptions: widget.queryOptions,
    );
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _checkUpdatation(null, "didPopNext");
  }

  @override
  void didPushNext() {
    super.didPushNext();
    _checkUpdatation(null, "didPushNext");
  }

  // @override
  // void didPop() {
  //   super.didPop();
  //   _checkUpdatation(null, "didPop");
  // }

  // @override
  // void didPush() {
  //   super.didPush();
  //   _checkUpdatation(null, "didPush");
  // }

  @override
  bool get wantKeepAlive => true;
}
