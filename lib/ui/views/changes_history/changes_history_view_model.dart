import 'package:flutter/material.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:stacked/stacked.dart';

class ChangesHistoryViewModel extends BaseViewModel {
  final StoryModel story;
  final void Function(StoryContentModel content) onRestorePressed;
  final void Function(List<String> contentIds) onDeletePressed;

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

  @override
  void notifyListeners() {
    super.notifyListeners();
    if (_editing == false) {
      Set<String> value = {...selectedNotifier.value}..clear();
      selectedNotifier.value = value;
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      selectedNotifier.dispose();
    });
  }
}
