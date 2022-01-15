import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:stacked/stacked.dart';

class ChangesHistoryViewModel extends BaseViewModel {
  final StoryModel story;
  final void Function(StoryContentModel content) onRestorePressed;

  ChangesHistoryViewModel(
    this.story,
    this.onRestorePressed,
  );
}
