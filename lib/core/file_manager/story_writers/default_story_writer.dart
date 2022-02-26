import 'dart:io';
import 'package:spooky/app.dart';
import 'package:spooky/core/file_manager/story_writers/base_story_writer.dart';
import 'package:spooky/core/file_manager/story_writers/objects/default_story_object.dart';
import 'package:spooky/utils/helpers/story_writer_helper.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';
import 'package:spooky/core/types/response_code_type.dart';

class DefaultStoryWriter<T extends DefaultStoryObject> extends BaseStoryWriter<T> {
  @override
  String buildMessage(ResponseCodeType responseCode) {
    switch (responseCode) {
      case ResponseCodeType.success:
        return "Saved";
      case ResponseCodeType.noChange:
        return "Document has no changes";
      case ResponseCodeType.fail:
        return "Save unsuccessfully!";
    }
  }

  @override
  void onSaved({
    required StoryModel? story,
    required FileSystemEntity? file,
    required ResponseCodeType responseCode,
    required String message,
  }) {
    if (context != null) {
      App.of(context!)?.showSpSnackBar(message);
    }
  }

  @override
  StoryModel buildStory(T object) {
    StoryModel story;
    StoryContentModel content = StoryWriteHelper.buildContent(
      object.info.currentContent,
      object.info.quillControllers,
      object.info.title,
      object.info.openOn,
    );
    switch (object.info.flowType) {
      case DetailViewFlowType.create:
        story = object.info.currentStory.copyWith(changes: [content]);
        break;
      case DetailViewFlowType.update:
        story = object.info.currentStory..addChange(content);
        break;
    }
    return story;
  }
}
