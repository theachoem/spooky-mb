import 'package:spooky/core/file_manager/story_writers/default_story_writer.dart';
import 'package:spooky/core/file_manager/story_writers/objects/delete_change_object.dart';
import 'package:spooky/core/models/story_model.dart';

class DeleteChangeWriter extends DefaultStoryWriter<DeleteChangeObject> {
  @override
  StoryModel buildStory(DeleteChangeObject object) {
    StoryModel story = object.viewModel.currentStory;
    story.removeChangeByIds(object.contentIds);
    return story;
  }
}
