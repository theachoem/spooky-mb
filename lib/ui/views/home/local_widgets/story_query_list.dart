import 'package:flutter/material.dart';
import 'package:spooky/core/file_managers/story_file_manager.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/models/story_query_options_model.dart';
import 'package:spooky/ui/views/home/local_widgets/story_list.dart';

class StoryQueryList extends StatefulWidget {
  const StoryQueryList({
    Key? key,
    required this.queryOptions,
    required this.onListReloaderReady,
    this.onDelete,
    this.onUnarchive,
  }) : super(key: key);

  final StoryQueryOptionsModel queryOptions;
  final void Function(void Function() callback) onListReloaderReady;
  final Future<bool> Function(StoryModel story)? onDelete;
  final Future<bool> Function(StoryModel story)? onUnarchive;

  @override
  State<StoryQueryList> createState() => _StoryListState();
}

class _StoryListState extends State<StoryQueryList> with AutomaticKeepAliveClientMixin {
  final StoryFileManager storyFileManager = StoryFileManager();
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
    var result = await storyFileManager.fetchAll(widget.queryOptions) ?? [];
    if (result != stories) {
      setState(() {
        stories = result;
        stories?.sort((a, b) => (dateForCompare(a)).compareTo(dateForCompare(b)));
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoryList(
      onRefresh: () => load(),
      stories: stories,
      emptyMessage: "Empty",
      onDelete: widget.onDelete != null
          ? (story) async {
              bool success = await widget.onDelete!(story);
              if (success) await load();
              return success;
            }
          : null,
      onUnarchive: widget.onUnarchive != null
          ? (story) async {
              bool success = await widget.onUnarchive!(story);
              if (success) await load();
              return success;
            }
          : null,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
