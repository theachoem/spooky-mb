import 'package:flutter/material.dart';
import 'package:spooky/core/databases/models/story_db_model.dart';
import 'package:spooky/core/services/story_writers/objects/base_writer_object.dart';
import 'package:spooky/core/types/response_code_type.dart';

abstract class BaseStoryWriter<T extends BaseWriterObject> {
  final BuildContext context;
  BaseStoryWriter(this.context);

  final database = StoryDbModel.db;

  bool get reloadOnSave => false;

  Future<StoryDbModel> buildStory(T object);
  String buildMessage(ResponseCodeType responseCode);

  /// `story` is story that is re-fetch after saved.
  void onSaved({
    required StoryDbModel? story,
    required ResponseCodeType responseCode,
    required String message,
  });

  String? validate(T object) {
    bool validated = object.info.hasChange;
    if (!validated) return buildMessage(ResponseCodeType.noChange);
    return null;
  }

  Future<StoryDbModel?> save(T object) async {
    String? validation = validate(object);
    StoryDbModel? result;

    if (validation == null) {
      StoryDbModel story = await buildStory(object);
      story = story.copyWith(updatedAt: DateTime.now());

      result = await database.set(story.copyWith(year: 2015));
      result ??= story;

      if (reloadOnSave) result = await database.find(result.id);
      return _nextSuccess(result!);
    } else {
      return _nextError(result, object, validation);
    }
  }

  Future<StoryDbModel?> _nextError(StoryDbModel? result, T object, [String? validation]) async {
    ResponseCodeType code = !object.info.hasChange ? ResponseCodeType.noChange : ResponseCodeType.fail;
    onSaved(story: null, responseCode: code, message: validation ?? buildMessage(code));
    return null;
  }

  Future<StoryDbModel?> _nextSuccess(StoryDbModel result) async {
    ResponseCodeType code = ResponseCodeType.success;
    String message = buildMessage(code);
    onSaved(story: result, responseCode: code, message: message);
    return result;
  }
}
