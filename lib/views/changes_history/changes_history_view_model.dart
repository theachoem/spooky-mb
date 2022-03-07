import 'package:flutter/material.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/base/base_view_model.dart';

class ChangesHistoryViewModel extends BaseViewModel {
  StoryModel story;
  final void Function(StoryContentModel content) onRestorePressed;
  final Future<StoryModel> Function(List<String> contentIds) onDeletePressed;

  bool _editing = false;
  bool get editing => _editing;

  toggleEditing() {
    _editing = !_editing;
    notifyListeners();
  }

  late final ValueNotifier<Set<String>> selectedNotifier;

  ChangesHistoryViewModel(
    this.story,
    this.onRestorePressed,
    this.onDeletePressed,
  ) {
    selectedNotifier = ValueNotifier({});
  }

  void delele() async {
    StoryModel value = await onDeletePressed(selectedNotifier.value.toList());
    story = value;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
    if (_editing == false) {
      Set<String> value = {...selectedNotifier.value}..clear();
      selectedNotifier.value = value;
    }

    // make sure select id is in story
    final list = story.changes.map((e) => e.id);
    Set<String> value = selectedNotifier.value;
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
