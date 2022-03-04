import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/file_manager/managers/story_manager.dart';
import 'package:spooky/core/story_writers/objects/base_writer_object.dart';
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

  String? validate(T object) {
    bool validated = object.info.hasChange;
    if (!validated) return buildMessage(ResponseCodeType.noChange);
    return null;
  }

  Future<StoryModel?> save(T object) async {
    FileSystemEntity? result;
    String? validation = validate(object);
    if (validation == null) {
      StoryModel story = buildStory(object);
      result = await storyManager.write(story.writableFile, story);
      log(result);
      return result is File ? _nextSuccess(result) : _nextError(result);
    } else {
      return _nextError(result, validation);
    }
  }

  Future<StoryModel?> _nextError(FileSystemEntity? result, [String? validation]) async {
    ResponseCodeType code = ResponseCodeType.fail;
    onSaved(story: null, file: result, responseCode: code, message: validation ?? buildMessage(code));
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
