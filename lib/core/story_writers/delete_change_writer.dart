import 'package:spooky/core/story_writers/default_story_writer.dart';
import 'package:spooky/core/story_writers/objects/delete_change_object.dart';
import 'package:spooky/core/models/story_model.dart';

class DeleteChangeWriter extends DefaultStoryWriter<DeleteChangeObject> {
  @override
  String? validate(DeleteChangeObject object) {
    List<String> toRemove = object.contentIds;
    List<String> changes = object.info.currentStory.changes.map((e) => e.id).toList();
    changes.removeWhere((id) => toRemove.contains(id));
    if (changes.isNotEmpty) {
      return null;
    } else {
      return "At least one page change";
    }
  }

  @override
  StoryModel buildStory(DeleteChangeObject object) {
    StoryModel story = object.info.currentStory;
    story.removeChangeByIds(object.contentIds);
    return story;
  }
}
