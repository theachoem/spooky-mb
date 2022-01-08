import 'package:flutter/material.dart';
import 'package:spooky/core/file_manager/docs_manager.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/ui/views/home/local_widgets/story_list.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';

class StoryListByMonth extends StatefulWidget {
  const StoryListByMonth({
    Key? key,
    required this.year,
    required this.month,
    required this.onListReloaderReady,
  }) : super(key: key);

  final int year;
  final int month;
  final void Function(void Function() callback) onListReloaderReady;

  @override
  State<StoryListByMonth> createState() => _StoryListState();
}

class _StoryListState extends State<StoryListByMonth> with AutomaticKeepAliveClientMixin {
  final DocsManager docsManager = DocsManager();
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
    int? data = int.tryParse(story.documentId ?? "");
    DateTime? dateFromId = data != null ? DateTime.fromMillisecondsSinceEpoch(data) : null;
    return story.pathDate ?? story.createdAt ?? dateFromId ?? DateTime.now();
  }

  Future<void> load() async {
    var result = await docsManager.fetchAll(year: widget.year, month: widget.month) ?? [];
    if (result != stories) {
      setState(() {
        stories = result;
        stories?.sort((a, b) => (dateForCompare(a)).compareTo(dateForCompare(b)));
      });
    }
  }

  @override
  void didUpdateWidget(covariant StoryListByMonth oldWidget) {
    super.didUpdateWidget(oldWidget);
    setDayColors();
    if (oldWidget.year != widget.year) load();
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
      emptyMessage: "Add to " + DateFormatHelper.toFullNameOfMonth().format(DateTime(widget.year, widget.month)),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
