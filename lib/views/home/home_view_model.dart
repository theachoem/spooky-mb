import 'package:flutter/material.dart';
import 'package:spooky_mb/core/base/base_view_model.dart';
import 'package:spooky_mb/core/databases/models/collection_db_model.dart';
import 'package:spooky_mb/core/databases/models/story_content_db_model.dart';
import 'package:spooky_mb/core/databases/models/story_db_model.dart';
import 'package:spooky_mb/routes/utils/animated_page_route.dart';
import 'package:spooky_mb/views/story_details/story_details_view.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel() {
    load();
  }

  int year = 2024;
  CollectionDbModel<StoryDbModel>? stories;
  List<int> get months => stories?.items.map((e) => e.month).toSet().toList() ?? [];

  String fromIndexToMonth(int index) {
    final int monthIndex = index + 1;
    return DateFormat.MMM().format(DateTime(1999, monthIndex));
  }

  Future<void> load() async {
    stories = await StoryDbModel.db.where();
    notifyListeners();
  }

  Future<void> goToViewPage(BuildContext context, StoryDbModel story) async {
    await Navigator.of(context).push(
      AnimatedPageRoute.sharedAxis(
        builder: (context) => StoryDetailsView(id: story.id),
        type: SharedAxisTransitionType.vertical,
      ),
    );

    await load();
  }

  Future<void> goToNewPage(BuildContext context) async {
    await Navigator.of(context).push(
      AnimatedPageRoute.sharedAxis(
        builder: (context) => const StoryDetailsView(id: null),
        type: SharedAxisTransitionType.vertical,
      ),
    );

    await load();
  }

  String? getDisplayBodyFor(StoryContentDbModel content) {
    if (content.plainText == null) return null;

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

    String body = content.plainText!.trim();
    String extract = body.length > 200 ? body.substring(0, 200) : body;
    return body.length > 200 ? "${trimBody(extract)}..." : extract;
  }
}
