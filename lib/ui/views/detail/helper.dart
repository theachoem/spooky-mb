import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/ui/views/detail/detail_view_model.dart';

class DetailViewModelHelper {
  static StoryModel buildStory(
    StoryModel currentStory,
    StoryContentModel currentContent,
    DetailViewFlow flowType,
  ) {
    StoryModel story;

    switch (flowType) {
      case DetailViewFlow.create:
        story = currentStory.copyWith(
          changes: [currentContent],
        );
        break;
      case DetailViewFlow.update:
        currentStory.addChange(currentContent);
        story = currentStory;
        break;
    }

    return story;
  }
}
