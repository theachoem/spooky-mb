import 'package:flutter/foundation.dart';
import 'package:spooky/core/backups/backups_file_manager.dart';
import 'package:spooky/core/db/adapters/base/base_story_db_external_actions.dart';
import 'package:spooky/core/db/databases/base_cache_story_database.dart';
import 'package:spooky/core/db/models/base/base_db_list_model.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/storages/local_storages/last_update_story_list_hash_storage.dart';
import 'package:spooky/utils/helpers/app_helper.dart';
import 'package:spooky/views/home/home_view.dart';

StoryDbModel _constructStoryIsolate(Map<String, dynamic> json) {
  return StoryDbModel.fromJson(json);
}

abstract class BaseStoryDatabase extends BaseCacheStoryDatabase {
  @override
  String get tableName => "stories";

  BaseStoryDatabase() {
    assert(adapter is BaseStoryDbExternalActions);
  }

  @override
  Future<StoryDbModel?> objectTransformer(Map<String, dynamic> json) async {
    return compute(_constructStoryIsolate, json);
  }

  @override
  Future<void> onCRUD(StoryDbModel? object) async {
    if (object?.year == null) return;
    BackupsFileManager().clear();
    LastUpdateStoryListHashStorage().setHash(DateTime.now());
    HomeView.reloadDocsCount();
  }

  Future<Set<int>?> fetchYears() {
    BaseStoryDbExternalActions storyAdapter = adapter as BaseStoryDbExternalActions;
    return storyAdapter.fetchYears();
  }

  int getDocsCount(int? year) {
    BaseStoryDbExternalActions storyAdapter = adapter as BaseStoryDbExternalActions;
    return storyAdapter.getDocsCount(year);
  }

  @override
  Future<BaseDbListModel<StoryDbModel>?> fetchAll({Map<String, dynamic>? params}) async {
    BaseDbListModel<StoryDbModel>? result = await super.fetchAll(params: params);

    Iterable<StoryDbModel>? items = result?.items.where((story) {
      DateTime? movedToBinAt = story.movedToBinAt;
      bool shouldDelete = AppHelper.shouldDelete(movedToBinAt: movedToBinAt);
      if (shouldDelete) deleteDocument(story);
      return !shouldDelete;
    });

    return result?.copyWith(items: items?.toList());
  }

  Future<StoryDbModel?> deleteDocument(StoryDbModel story) async {
    return delete(
      id: story.id,
      params: {
        "type": story.type.name,
        "month": story.month,
        "year": story.year,
        "day": story.day,
      },
    );
  }
}
