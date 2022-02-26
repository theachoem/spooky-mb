import 'dart:io';
import 'package:spooky/core/file_manager/story_writers/default_story_writer.dart';
import 'package:spooky/core/file_manager/story_writers/objects/auto_save_story_object.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/types/response_code_type.dart';

class AutoSaveStoryWriter extends DefaultStoryWriter<AutoSaveStoryObject> {
  @override
  String buildMessage(ResponseCodeType responseCode) {
    // TODO: implement buildMessage
    throw UnimplementedError();
  }

  @override
  void onSaved({
    required StoryModel? story,
    required FileSystemEntity? file,
    required ResponseCodeType responseCode,
    required String message,
  }) {
    // TODO: implement onSaved
  }

  @override
  StoryModel buildStory(AutoSaveStoryObject object) {
    // TODO: implement buildStory
    throw UnimplementedError();
  }
}
