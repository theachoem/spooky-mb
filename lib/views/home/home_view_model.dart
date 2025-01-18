import 'dart:math';
import 'package:flutter/material.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/databases/models/collection_db_model.dart';
import 'package:spooky/core/databases/models/preference_db_model.dart';
import 'package:spooky/core/databases/models/story_db_model.dart';
import 'package:spooky/core/services/restore_backup_service.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:spooky/views/home/local_widgets/nickname_bottom_sheet.dart';
import 'package:spooky/views/stories/edit/edit_story_view.dart';
import 'package:spooky/views/stories/show/show_story_view.dart';

part './local_widgets/home_scroll_info.dart';

class HomeViewModel extends BaseViewModel {
  late final scrollInfo = _HomeScrollInfo(viewModel: () => this);

  HomeViewModel(BuildContext context) {
    loadUser(context);
    load(debugSource: '$runtimeType#_constructor');

    RestoreBackupService.instance.addListener(() {
      load(debugSource: '$runtimeType#_listenToRestoreService');
    });
  }

  String? nickname;
  int year = DateTime.now().year;
  CollectionDbModel<StoryDbModel>? stories;

  List<int> get months {
    List<int> months = stories?.items.map((e) => e.month).toSet().toList() ?? [];
    if (months.isEmpty) months.add(DateTime.now().month);
    return months;
  }

  Future<void> loadUser(BuildContext context) async {
    nickname = PreferenceDbModel.db.nickname.get();
    if (nickname == null) {
      await Future.delayed(Durations.long3);
      if (context.mounted) changeName(context);
    }
  }

  Future<void> load({
    required String debugSource,
  }) async {
    debugPrint('🚧 Reload home from $debugSource 🏠');
    stories = await StoryDbModel.db.where(filters: {
      'year': year,
      'types': [PathType.docs.name],
    });

    scrollInfo.setupStoryKeys(stories?.items ?? []);
    notifyListeners();
  }

  Future<void> changeYear(int newYear) async {
    year = newYear;
    await load(debugSource: '$runtimeType#changeYear $newYear');
  }

  Future<void> goToViewPage(BuildContext context, StoryDbModel story) async {
    await ShowStoryRoute(id: story.id, story: story).push(context);
  }

  Future<void> goToNewPage(BuildContext context) async {
    await EditStoryRoute(id: null, initialYear: year).push(context);
    await load(debugSource: '$runtimeType#goToNewPage');
  }

  void changeName(BuildContext context) async {
    dynamic result = await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      sheetAnimationStyle: AnimationStyle(curve: Curves.fastEaseInToSlowEaseOut, duration: Durations.long4),
      isScrollControlled: true,
      builder: (context) {
        return NicknameBottomSheet(nickname: nickname);
      },
    );

    if (result is String) {
      PreferenceDbModel.db.nickname.set(result);
      nickname = PreferenceDbModel.db.nickname.get();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    scrollInfo.dispose();
    super.dispose();
  }
}
