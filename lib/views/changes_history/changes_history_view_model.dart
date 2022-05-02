import 'package:flutter/material.dart';
import 'package:spooky/core/db/models/story_content_db_model.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/base/base_view_model.dart';

class ChangesHistoryViewModel extends BaseViewModel {
  StoryDbModel story;
  final void Function(StoryContentDbModel content) onRestorePressed;
  final Future<StoryDbModel> Function(List<int> contentIds) onDeletePressed;

  bool _editing = false;
  bool get editing => _editing;

  toggleEditing() {
    _editing = !_editing;
    notifyListeners();
  }

  late final ValueNotifier<Set<int>> selectedNotifier;

  ChangesHistoryViewModel(
    this.story,
    this.onRestorePressed,
    this.onDeletePressed,
  ) {
    selectedNotifier = ValueNotifier({});
  }

  void delele() async {
    StoryDbModel value = await onDeletePressed(selectedNotifier.value.toList());
    story = value;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
    if (_editing == false) {
      Set<int> value = {...selectedNotifier.value}..clear();
      selectedNotifier.value = value;
    }

    // make sure select id is in story
    final list = story.changes.map((e) => e.id);
    Set<int> value = selectedNotifier.value;
    value.removeWhere((e) => !list.contains(e));
    selectedNotifier.value = value;
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      selectedNotifier.dispose();
    });
  }
}
