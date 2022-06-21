import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/core/story_writers/base_story_writer.dart';
import 'package:spooky/core/story_writers/objects/default_story_object.dart';
import 'package:spooky/utils/helpers/story_writer_helper.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';
import 'package:spooky/core/types/response_code_type.dart';
import 'package:spooky/core/db/models/story_content_db_model.dart';

class DefaultStoryWriter<T extends DefaultStoryObject> extends BaseStoryWriter<T> {
  @override
  String buildMessage(ResponseCodeType responseCode) {
    switch (responseCode) {
      case ResponseCodeType.success:
        return "Saved";
      case ResponseCodeType.fail:
        return "Save unsuccessfully!";
      case ResponseCodeType.noChange:
        return "No changes!";
    }
  }

  @override
  void onSaved({
    required StoryDbModel? story,
    required ResponseCodeType responseCode,
    required String message,
  }) {
    if (context != null) {
      MessengerService.instance.showSnackBar(message);
    }
  }

  @override
  Future<StoryDbModel> buildStory(T object) async {
    StoryContentDbModel content = await StoryWriteHelper.buildContent(
      object.info.currentContent,
      object.info.quillControllers,
      object.info.title,
      object.info.openOn,
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
