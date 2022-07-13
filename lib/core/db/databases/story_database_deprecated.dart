import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:googleapis/cloudsearch/v1.dart';
import 'package:path/path.dart';
import 'package:spooky/core/db/adapters/base/base_db_adapter.dart';
import 'package:spooky/core/db/adapters/base/base_file_db_adpater.dart';
import 'package:spooky/core/db/adapters/base/base_story_db_external_actions.dart';
import 'package:spooky/core/db/models/base/base_db_list_model.dart';
import 'package:spooky/core/db/models/base/links_model.dart';
import 'package:spooky/core/db/models/base/meta_model.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:spooky/utils/constants/app_constant.dart';
import 'package:spooky/utils/helpers/app_helper.dart';
import 'package:spooky/utils/helpers/file_helper.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import './base_story_database.dart';

part '../adapters/file/story_file_db_adapter.dart';

@Deprecated('Use StoryDatabase with ObjectBox adapter instead')
class StoryDatabaseDeprecated extends BaseStoryDatabase {
  @override
  BaseDbAdapter<StoryDbModel> get adapter => _StoryFileDbAdapter(tableName);

  Future<StoryDbModel?> moveToTrash(StoryDbModel story) async {
    if (story.type == PathType.bins) return null;
    StoryDbModel binStory = story.copyWith(type: PathType.bins, movedToBinAt: DateTime.now());
    StoryDbModel? result = await create(body: binStory);
    if (result != null) {
      return deleteDocument(story);
    } else {
      return null;
    }
  }

  Future<StoryDbModel?> archiveDocument(StoryDbModel story) async {
    if (story.type == PathType.archives) return null;
    StoryDbModel archivedStory = story.copyWith(type: PathType.archives);
    StoryDbModel? result = await create(body: archivedStory);
    if (result != null) {
      return deleteDocument(story);
    } else {
      return null;
    }
  }

  Future<StoryDbModel?> putBackToDocs(StoryDbModel story) async {
    if (story.type == PathType.docs) return null;
    StoryDbModel unarchivedStory = story.copyWith(type: PathType.docs);

    // create on docs path & remove from bin path
    StoryDbModel? result = await create(
      body: unarchivedStory.copyWith(movedToBinAt: null),
    );

    if (result != null) {
      return deleteDocument(story);
    } else {
      return null;
    }
  }
}
