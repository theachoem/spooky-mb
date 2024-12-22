import 'package:flutter/material.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/databases/models/collection_db_model.dart';
import 'package:spooky/core/databases/models/story_db_model.dart';
import 'package:spooky/core/objects/user_object.dart';
import 'package:spooky/core/storages/user_storage.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:spooky/views/home/local_widgets/nickname_bottom_sheet.dart';
import 'package:spooky/views/stories/edit/edit_story_view.dart';
import 'package:spooky/views/stories/show/show_story_view.dart';

part './local_widgets/home_scroll_info.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel(BuildContext context) {
    loadUser(context);
    load();
  }

  // make sure to load initial data on initializer
  Future<void> loadUser(BuildContext context) async {
    user = UserStorage.instance.initialData;
    if (user?.nickname == null) {
      await Future.delayed(Durations.long3);
      if (context.mounted) changeName(context);
    }
  }

  Future<void> load() async {
    stories = await StoryDbModel.db.where(filters: {
      'year': year,
      'type': PathType.docs.name,
    });

    notifyListeners();
  }

  late final scrollInfo = _HomeScrollInfo(viewModel: () => this);

  int year = DateTime.now().year;
  CollectionDbModel<StoryDbModel>? stories;
  UserObject? user;

  List<int> get months {
    List<int> months = stories?.items.map((e) => e.month).toSet().toList() ?? [];
    if (months.isEmpty) months.add(DateTime.now().month);
    return months;
  }

  Future<void> changeYear(int newYear) async {
    year = newYear;
    await load();
  }

  Future<void> toggleStarred(StoryDbModel story) async {
    bool starred = story.starred == true;

    StoryDbModel updatedStory = story.copyWith(starred: !starred);
    StoryDbModel.db.set(updatedStory);

    stories = stories?.copyWithNewElement(updatedStory);
    notifyListeners();
  }

  Future<void> goToViewPage(BuildContext context, StoryDbModel story) async {
    await ShowStoryRoute(id: story.id, story: story).push(context);
    await load();
  }

  Future<void> goToNewPage(BuildContext context) async {
    await EditStoryRoute(id: null, initialYear: year).push(context);
    await load();
  }

  @override
  void dispose() {
    scrollInfo.dispose();
    super.dispose();
  }

  PersistentBottomSheetController? bottomSheet;

  void changeName(BuildContext context) async {
    dynamic result = await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      sheetAnimationStyle: AnimationStyle(curve: Curves.fastEaseInToSlowEaseOut, duration: Durations.long4),
      isScrollControlled: true,
      builder: (context) {
        return NicknameBottomSheet(user: user);
      },
    );

    if (result is String) {
      await UserStorage.instance.writeObject(user!.copyWith(nickname: result));
      user = await UserStorage.instance.readObject();
      notifyListeners();
    }
  }
}
