import 'package:flutter/material.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/db/databases/story_database.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/services/is_changed_story_service.dart';
import 'package:spooky/core/story_writers/objects/base_writer_object.dart';
import 'package:spooky/core/types/response_code_type.dart';

abstract class BaseStoryWriter<T extends BaseWriterObject> {
  BuildContext? get context => App.navigatorKey.currentContext;
  final StoryDatabase database = StoryDatabase.instance;

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
      IsChangedStoryService.instance.setChanged(story);
      result = await database.set(body: story);
      return result != null ? _nextSuccess(result) : _nextError(result);
    } else {
      return _nextError(result, validation);
    }
  }

  Future<StoryDbModel?> _nextError(StoryDbModel? result, [String? validation]) async {
    ResponseCodeType code = ResponseCodeType.fail;
    onSaved(story: null, responseCode: code, message: validation ?? buildMessage(code));
    return null;
  }

  Future<StoryDbModel?> _nextSuccess(StoryDbModel result) async {
    ResponseCodeType code = ResponseCodeType.success;
    String message = buildMessage(code);
    StoryDbModel? story = await database.fetchOne(id: result.id);
    onSaved(story: story, responseCode: code, message: message);
    return story;
  }
}
