import 'package:spooky/core/db/models/story_content_db_model.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/story_writers/default_story_writer.dart';
import 'package:spooky/core/story_writers/objects/draft_story_object.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';
import 'package:spooky/core/types/response_code_type.dart';
import 'package:spooky/utils/helpers/story_writer_helper.dart';

class DraftStoryWriter extends DefaultStoryWriter<DraftStoryObject> {
  @override
  String buildMessage(ResponseCodeType responseCode) {
    switch (responseCode) {
      case ResponseCodeType.success:
        return "Draft saved";
      case ResponseCodeType.fail:
        return "Draft save fail!";
      case ResponseCodeType.noChange:
        return "No changes!";
    }
  }

  @override
  Future<StoryDbModel> buildStory(DraftStoryObject object) async {
    StoryContentDbModel content = await StoryWriteHelper.buildContent(
      object.info.currentContent,
      object.info.quillControllers,
      object.info.title,
      object.info.openOn,
      draft: true,
    );

    switch (object.info.flowType) {
      case DetailViewFlowType.update:
        return object.info.currentStory..addChange(content);
      case DetailViewFlowType.create:
      default:
        return object.info.currentStory.copyWith(changes: [content]);
    }
  }
}
