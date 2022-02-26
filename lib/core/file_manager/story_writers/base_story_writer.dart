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

  bool get force => false;

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
    bool hasChange = object.info.hasChange;
    if (hasChange || force) {
      StoryModel story = buildStory(object);
      result = await storyManager.write(story.writableFile, story);
      log(result);
      return result is File ? _nextSuccess(result) : _nextError(result);
    } else {
      return _nextNoChange();
    }
  }

  Future<StoryModel?> _nextNoChange() async {
    ResponseCodeType code = ResponseCodeType.noChange;
    String message = buildMessage(code);
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
    String message = buildMessage(code);
    StoryModel? story = await storyManager.fetchOne(result);
    onSaved(story: story, file: result, responseCode: code, message: message);
    return story;
  }

  void log(FileSystemEntity? result) {
    if (kDebugMode) {
      print("+++ Write +++");
      print("Message: ${storyManager.error}");
      print("Path: ${result?.absolute.path}");
    }
  }
}
