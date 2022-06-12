import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:googleapis/cloudsearch/v1.dart';
import 'package:path/path.dart';
import 'package:spooky/core/db/adapters/base/base_db_adapter.dart';
import 'package:spooky/core/db/adapters/base/base_file_db_adpater.dart';
import 'package:spooky/core/db/models/base/base_db_list_model.dart';
import 'package:spooky/core/db/databases/base_database.dart';
import 'package:spooky/core/db/models/base/meta_model.dart';
import 'package:spooky/core/file_manager/managers/backup_file_manager.dart';
import 'package:spooky/core/storages/local_storages/last_update_story_list_hash_storage.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:spooky/utils/constants/app_constant.dart';
import 'package:spooky/utils/helpers/app_helper.dart';
import 'package:spooky/utils/helpers/file_helper.dart';
import 'package:spooky/core/db/models/story_db_model.dart';

part '../adapters/file/story_file_db_adapter.dart';

StoryDbModel _constructStoryIsolate(Map<String, dynamic> json) {
  return StoryDbModel.fromJson(json);
}

class StoryDatabase extends BaseDatabase<StoryDbModel> {
  @override
  BaseDbAdapter get adapter => _StoryFileDbAdapter("story");

  @override
  Future<BaseDbListModel<StoryDbModel>?> itemsTransformer(Map<String, dynamic> json) async {
    return BaseDbListModel(
      items: await buildItemsList(json),
      meta: await buildMeta(json),
      links: await buildLinks(json),
    );
  }

  @override
  Future<BaseDbListModel<StoryDbModel>?> fetchAll({Map<String, dynamic>? params}) async {
    BaseDbListModel<StoryDbModel>? result = await super.fetchAll(params: params);
    Iterable<StoryDbModel>? items = result?.items.where((story) {
      DateTime? movedToBinAt = story.movedToBinAt;
      bool shouldDelete = AppHelper.shouldDelete(movedToBinAt: movedToBinAt);
      // TODO: test to delete this
      // if (shouldDelete) deleteDocument(story);
      return !shouldDelete;
    });
    return result?.copyWith(items: items?.toList());
  }

  @override
  Future<StoryDbModel?> objectTransformer(Map<String, dynamic> json) async {
    return compute(_constructStoryIsolate, json);
  }

  Future<Set<int>?> fetchYears() {
    _StoryFileDbAdapter storyAdapter = adapter as _StoryFileDbAdapter;
    return storyAdapter.fetchYears();
  }

  int getDocsCount(int? year) {
    _StoryFileDbAdapter storyAdapter = adapter as _StoryFileDbAdapter;
    return storyAdapter.getDocsCount(year);
  }

  bool canArchive(StoryDbModel story) {
    return story.type == PathType.docs;
  }

  bool canUnarchive(StoryDbModel story) {
    return story.type == PathType.archives;
  }

  Future<StoryDbModel?> moveToTrash(StoryDbModel story) async {
    if (story.type == PathType.bins) return null;
    StoryDbModel binStory = story.copyWith(type: PathType.bins, movedToBinAt: DateTime.now());
    StoryDbModel? result = await create(body: binStory.toJson());
    if (result != null) {
      return deleteDocument(story);
    } else {
      return null;
    }
  }

  Future<StoryDbModel?> archiveDocument(StoryDbModel story) async {
    if (story.type == PathType.archives) return null;
    StoryDbModel archivedStory = story.copyWith(type: PathType.archives);
    StoryDbModel? result = await create(body: archivedStory.toJson());
    if (result != null) {
      return deleteDocument(story);
    } else {
      return null;
    }
  }

  Future<StoryDbModel?> putBackToDocs(StoryDbModel story) async {
    if (story.type == PathType.docs) return null;
    StoryDbModel unarchivedStory = story.copyWith(type: PathType.docs);

    Map<String, dynamic> json = unarchivedStory.toJson();
    json['moved_to_bin_at'] = null;

    // create on docs path & remove from bin path
    StoryDbModel? result = await create(body: json);
    if (result != null) {
      return deleteDocument(story);
    } else {
      return null;
    }
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

  Future<StoryDbModel?> updatePathDate(StoryDbModel story, DateTime pathDate) async {
    StoryDbModel updatedStory = story.copyWith(year: pathDate.year, month: pathDate.month, day: pathDate.day);
    StoryDbModel? result = await update(id: story.id, body: updatedStory.toJson());
    return result;
  }

  @override
  Future<void> onCRUD(StoryDbModel? object) async {
    if (object?.year == null) return;
    BackupFileManager().unsynced(object!.year);
    LastUpdateStoryListHashStorage().setHash(DateTime.now());
  }
}
