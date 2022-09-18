import 'package:flutter/foundation.dart';
import 'package:spooky/core/db/databases/base_database.dart';
import 'package:spooky/core/db/databases/story_database.dart';
import 'package:spooky/core/db/models/base/base_db_list_model.dart';
import 'package:spooky/core/db/models/story_db_model.dart';

abstract class BaseCacheStoryDatabase extends BaseDatabase<StoryDbModel> {
  // CACHE
  static Map<int, StoryDbModel?> stories = {};
  void deleteCache(
    int id, {
    required String debugSource,
  }) {
    if (kDebugMode) print("DELETE story: $id from: $debugSource");
    stories.remove(id);
  }

  void setCache(
    StoryDbModel story, {
    required String debugSource,
  }) {
    if (kDebugMode) print("SET story: ${story.id} from: $debugSource");
    stories[story.id] = story;
  }

  void setCacheMany(
    List<StoryDbModel> newStories, {
    required String debugSource,
  }) {
    if (kDebugMode) print("SET stories: ${newStories.length} from: $debugSource");
    for (StoryDbModel story in newStories) {
      stories[story.id] = story;
    }
  }

  Future<StoryDbModel?> fetchOneCache(int id) async {
    stories[id] ??= await StoryDatabase.instance.fetchOne(id: id);
    return stories[id];
  }

  ////////////////////////
  // OVERRIDE functions //
  ////////////////////////

  @override
  Future<StoryDbModel?> fetchOne({
    required int id,
    Map<String, dynamic>? params,
  }) async {
    StoryDbModel? result = await super.fetchOne(id: id, params: params);
    if (result != null) setCache(result, debugSource: "$runtimeType#fetchOne");
    return result;
  }

  @override
  Future<BaseDbListModel<StoryDbModel>?> fetchAll({
    Map<String, dynamic>? params,
  }) async {
    BaseDbListModel<StoryDbModel>? result = await super.fetchAll(params: params);
    List<StoryDbModel>? items = result?.items;
    if (items != null) setCacheMany(items.toList(), debugSource: "$runtimeType#fetchAll");
    return result;
  }

  @override
  Future<StoryDbModel?> set({
    required StoryDbModel body,
    Map<String, dynamic> params = const {},
  }) async {
    deleteCache(body.id, debugSource: "$runtimeType#set");
    StoryDbModel? story = await super.set(body: body, params: params);
    if (story != null) setCache(story, debugSource: "$runtimeType#set");
    return story;
  }

  @override
  Future<StoryDbModel?> create({
    required StoryDbModel body,
    Map<String, dynamic> params = const {},
  }) async {
    deleteCache(body.id, debugSource: "$runtimeType#create");
    StoryDbModel? story = await super.create(body: body, params: params);
    if (story != null) setCache(story, debugSource: "$runtimeType#create");
    return story;
  }

  @override
  Future<StoryDbModel?> delete({
    required int id,
    Map<String, dynamic> params = const {},
  }) {
    deleteCache(id, debugSource: "$runtimeType#delete");
    return super.delete(id: id, params: params);
  }

  @override
  Future<StoryDbModel?> update({
    required int id,
    required StoryDbModel body,
    Map<String, dynamic> params = const {},
  }) async {
    deleteCache(body.id, debugSource: "$runtimeType#update");
    StoryDbModel? story = await super.update(id: id, body: body, params: params);
    if (story != null) setCache(story, debugSource: "$runtimeType#update");
    return story;
  }
}
