import 'package:spooky/core/file_manager/story_writers/default_story_writer.dart';
import 'package:spooky/core/file_manager/story_writers/objects/delete_change_object.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';
import 'package:spooky/utils/helpers/story_writer_helper.dart';

class DeleteChangeWriter extends DefaultStoryWriter<DeleteChangeObject> {
  @override
  bool get force => true;

  @override
  StoryModel buildStory(DeleteChangeObject object) {
    StoryModel story;
    StoryContentModel content = StoryWriteHelper.buildContent(
      object.viewModel.currentContent,
      object.viewModel.quillControllers,
      object.viewModel.titleController,
      DateTime.now(),
    );
    switch (object.viewModel.flowType) {
      case DetailViewFlowType.create:
        story = object.viewModel.currentStory.copyWith(changes: [content]);
        break;
      case DetailViewFlowType.update:
        story = object.viewModel.currentStory..addChange(content);
        break;
    }
    story.removeChangeByIds(object.contentIds);
    return story;
  }
}
