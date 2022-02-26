import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/file_manager/managers/story_manager.dart';
import 'package:spooky/core/file_manager/story_writers/objects/base_writer_object.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/types/response_code_type.dart';

abstract class BaseStoryWriter<T extends BaseWriterObject> {
  BuildContext? get context => App.navigatorKey.currentContext;
  final StoryManager storyManager = StoryManager();

  StoryModel buildStory(T object);
  String buildMessage(ResponseCodeType responseCode);

  /// `story` is story that is re-fetch after saved.
  void onSaved({
    required StoryModel? story,
    required FileSystemEntity? file,
    required ResponseCodeType responseCode,
    required String message,
  });

  Future<StoryModel?> save(T object) async {
    FileSystemEntity? result;
    bool hasChange = object.viewModel.hasChange;
    if (hasChange) {
      StoryModel story = buildStory(object);
      result = await storyManager.write(story.writableFile, story);
      if (kDebugMode) {
        print("+++ Write +++");
        print("Message: ${storyManager.error}");
        print("Path: ${result?.absolute.path}");
      }
    }
    if (result != null && result is File) {
      return _nextSuccess(result);
    } else if (!hasChange) {
      return _nextNoChange();
    } else {
      return _nextError(result);
    }
  }

  Future<StoryModel?> _nextNoChange() async {
    ResponseCodeType code = ResponseCodeType.noChange;
    String message = buildMessage(ResponseCodeType.noChange);
    onSaved(story: null, file: null, responseCode: code, message: message);
    return null;
  }

  Future<StoryModel?> _nextError(FileSystemEntity? result) async {
    ResponseCodeType code = ResponseCodeType.fail;
    onSaved(story: null, file: result, responseCode: code, message: buildMessage(code));
    return null;
  }

  Future<StoryModel?> _nextSuccess(File result) async {
    ResponseCodeType code = ResponseCodeType.success;
    String message = buildMessage(ResponseCodeType.noChange);
    StoryModel? story = await storyManager.fetchOne(result);
    onSaved(story: story, file: result, responseCode: code, message: message);
    return story;
  }
}
