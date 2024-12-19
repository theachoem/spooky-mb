import 'package:spooky_mb/core/databases/models/story_content_db_model.dart';
import 'package:spooky_mb/core/databases/models/story_db_model.dart';
import 'package:spooky_mb/core/services/messenger_service.dart';
import 'package:spooky_mb/core/services/story_writer_helper_service.dart';
import 'package:spooky_mb/core/services/story_writers/base_story_writer.dart';
import 'package:spooky_mb/core/services/story_writers/objects/default_story_object.dart';
import 'package:spooky_mb/core/types/editing_flow_type.dart';
import 'package:spooky_mb/core/types/response_code_type.dart';

class DefaultStoryWriter<T extends DefaultStoryObject> extends BaseStoryWriter<T> {
  DefaultStoryWriter(super.context);

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
    MessengerService.of(context).showSnackBar(
      message,
      showAction: false,
      success: responseCode != ResponseCodeType.fail,
    );
  }

  @override
  Future<StoryDbModel> buildStory(T object) async {
    StoryContentDbModel content = await StoryWriteHelper.buildContent(
      object.info.currentContent,
      object.info.quillControllers,
      object.info.title,
      draft: false,
      currentPageIndex: object.info.currentPageIndex,
    );

    switch (object.info.flowType) {
      case EditingFlowType.update:
        return object.info.currentStory.copyWithNewChange(content);
      case EditingFlowType.create:
        return object.info.currentStory.copyWith(changes: [content]);
    }
  }
}
