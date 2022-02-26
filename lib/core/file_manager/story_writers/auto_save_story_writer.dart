import 'dart:io';
import 'package:spooky/core/file_manager/story_writers/default_story_writer.dart';
import 'package:spooky/core/file_manager/story_writers/objects/auto_save_story_object.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/notification/channels/auto_save_channel.dart';
import 'package:spooky/core/types/response_code_type.dart';

class AutoSaveStoryWriter extends DefaultStoryWriter<AutoSaveStoryObject> {
  @override
  String buildMessage(ResponseCodeType responseCode) {
    switch (responseCode) {
      case ResponseCodeType.success:
        return "Document is saved";
      case ResponseCodeType.noChange:
        return "";
      case ResponseCodeType.fail:
        return "Document isn't saved!";
    }
  }

  @override
  void onSaved({
    required StoryModel? story,
    required FileSystemEntity? file,
    required ResponseCodeType responseCode,
    required String message,
  }) {
    switch (responseCode) {
      case ResponseCodeType.success:
        AutoSaveChannel().show(
          title: message,
          body: "Saved",
          payload: AutoSavePayload(story?.file?.path ?? story?.path.toFullPath() ?? ""),
        );
        break;
      case ResponseCodeType.noChange:
        break;
      case ResponseCodeType.fail:
        AutoSaveChannel().show(
          title: message,
          body: "Error",
          payload: AutoSavePayload(story?.file?.path ?? story?.path.toFullPath() ?? ""),
        );
        break;
    }
  }
}
