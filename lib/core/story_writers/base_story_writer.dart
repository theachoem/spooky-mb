import 'package:flutter/material.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/db/databases/story_database.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/story_writers/objects/base_writer_object.dart';
import 'package:spooky/core/types/response_code_type.dart';
import 'package:spooky/providers/cache_story_models_provider.dart';

abstract class BaseStoryWriter<T extends BaseWriterObject> {
  BuildContext? get context => App.navigatorKey.currentContext;
  final StoryDatabase database = StoryDatabase.instance;

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

  void saveToCacheProvider(StoryDbModel story) {
    CacheStoryModelsProvider.instance.update(
      story,
      debugSource: runtimeType.toString(),
    );
  }

  Future<StoryDbModel?> save(T object) async {
    String? validation = validate(object);
    StoryDbModel? result;
    if (validation == null) {
      StoryDbModel story = await buildStory(object);
      story = story.copyWith(updatedAt: DateTime.now());
      saveToCacheProvider(story);

      result = await database.set(body: story);
      result ??= story;

      if (reloadOnSave) result = await database.fetchOne(id: result.id);
      return database.error == null ? _nextSuccess(result!) : _nextError(result, object);
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
    // StoryDbModel? story = await database.fetchOne(id: result.id);
    onSaved(story: result, responseCode: code, message: message);
    return result;
  }
}
