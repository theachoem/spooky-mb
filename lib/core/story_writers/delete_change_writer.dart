import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/story_writers/default_story_writer.dart';
import 'package:spooky/core/story_writers/objects/delete_change_object.dart';

class DeleteChangeWriter extends DefaultStoryWriter<DeleteChangeObject> {
  @override
  String? validate(DeleteChangeObject object) {
    List<int> toRemove = object.contentIds;
    List<int> changes = object.info.currentStory.changes.map((e) => e.id).toList();
    changes.removeWhere((id) => toRemove.contains(id));
    if (changes.isNotEmpty) {
      return null;
    } else {
      return "At least one page change";
    }
  }

  @override
  Future<StoryDbModel> buildStory(DeleteChangeObject object) async {
    StoryDbModel story = object.info.currentStory;
    story.removeChangeByIds(object.contentIds);
    return story;
  }
}
