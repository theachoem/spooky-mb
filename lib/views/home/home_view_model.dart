import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/databases/models/collection_db_model.dart';
import 'package:spooky/core/databases/models/story_db_model.dart';
import 'package:spooky/routes/utils/animated_page_route.dart';
import 'package:spooky/views/page_editor/page_editor_view.dart';

part './local_widgets/home_scroll_info.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel() {
    load();
  }

  late final scrollInfo = _HomeScrollInfo(viewModel: () => this);

  int year = DateTime.now().year;
  CollectionDbModel<StoryDbModel>? stories;

  List<int> get months {
    List<int> months = stories?.items.map((e) => e.month).toSet().toList() ?? [];
    if (months.isEmpty) months.add(DateTime.now().month);
    return months;
  }

  Future<void> load() async {
    stories = await StoryDbModel.db.where(filters: {'year': year});
    notifyListeners();
  }

  Future<void> goToViewPage(BuildContext context, StoryDbModel story) async {
    await context.push('/stories/${story.id}');
    await load();
  }

  void changeYear(int newYear) async {
    year = newYear;
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

  @override
  void dispose() {
    scrollInfo.dispose();
    super.dispose();
  }
}
