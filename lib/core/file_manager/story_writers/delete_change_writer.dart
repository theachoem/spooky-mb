import 'package:spooky/core/file_manager/story_writers/default_story_writer.dart';
import 'package:spooky/core/file_manager/story_writers/mixins/force_save_mixin.dart';
import 'package:spooky/core/file_manager/story_writers/objects/delete_change_object.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';
import 'package:spooky/utils/helpers/story_writer_helper.dart';

class DeleteChangeWriter extends DefaultStoryWriter<DeleteChangeObject> with ForceSaveMixin {
  @override
  StoryModel buildStory(DeleteChangeObject object) {
    StoryModel story;
    StoryContentModel content = StoryWriteHelper.buildContent(
      object.info.currentContent,
      object.info.quillControllers,
      object.info.title,
      DateTime.now(),
    );
    switch (object.info.flowType) {
      case DetailViewFlowType.create:
        story = object.info.currentStory.copyWith(changes: [content]);
        break;
      case DetailViewFlowType.update:
        story = object.info.currentStory..addChange(content);
        break;
    }
    story.removeChangeByIds(object.contentIds);
    return story;
  }
}
