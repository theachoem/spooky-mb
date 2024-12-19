import 'package:flutter/material.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:spooky_mb/core/base/base_view_model.dart';
import 'package:spooky_mb/core/databases/models/collection_db_model.dart';
import 'package:spooky_mb/core/databases/models/story_content_db_model.dart';
import 'package:spooky_mb/core/databases/models/story_db_model.dart';
import 'package:spooky_mb/routes/utils/animated_page_route.dart';
import 'package:spooky_mb/views/page_editor/page_editor_view.dart';
import 'package:spooky_mb/views/story_details/story_details_view.dart';

part './local_widgets/home_scroll_info.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel() {
    load();
  }

  late final scrollInfo = _HomeScrollInfo(viewModel: () => this);

  int year = 2024;
  CollectionDbModel<StoryDbModel>? stories;
  List<int> get months => stories?.items.map((e) => e.month).toSet().toList() ?? [];

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
        builder: (context) => const PageEditorView(),
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

  @override
  void dispose() {
    scrollInfo.dispose();
    super.dispose();
  }
}
