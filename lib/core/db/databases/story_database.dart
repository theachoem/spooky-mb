import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:spooky/core/db/adapters/base/base_db_adapter.dart';
import 'package:spooky/core/db/adapters/base/base_story_db_external_actions.dart';
import 'package:spooky/core/db/adapters/objectbox/entities.dart';
import 'package:spooky/core/db/models/base/links_model.dart';
import 'package:spooky/core/db/models/base/meta_model.dart';
import 'package:spooky/core/db/models/story_content_db_model.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/core/db/adapters/base/base_objectbox_adapter.dart';
import 'package:spooky/main.dart';
import './base_story_database.dart';
import 'package:spooky/objectbox.g.dart';

part '../adapters/objectbox/story_objectbox_db_adapter.dart';
part '../adapters/objectbox/story_test_db_adapter.dart';

class StoryDatabase extends BaseStoryDatabase {
  static final StoryDatabase instance = StoryDatabase._();
  StoryDatabase._();

  @override
  BaseDbAdapter get adapter {
    if (Global.instance.unitTesting) {
      return _StoryTestDbAdapter(tableName);
    } else {
      return _StoryObjectBoxDbAdapter(tableName);
    }
  }

  Future<StoryDbModel?> moveToTrash(StoryDbModel story) async {
    if (story.type == PathType.bins) return null;
    StoryDbModel binStory = story.copyWith(type: PathType.bins, movedToBinAt: DateTime.now());
    return update(
      id: binStory.id,
      body: binStory.toJson(),
    );
  }

  Future<StoryDbModel?> archiveDocument(StoryDbModel story) async {
    if (story.type == PathType.archives) return null;
    StoryDbModel archivedStory = story.copyWith(type: PathType.archives);
    return update(
      id: archivedStory.id,
      body: archivedStory.toJson(),
    );
  }

  Future<StoryDbModel?> putBackToDocs(StoryDbModel story) async {
    if (story.type == PathType.docs) return null;
    StoryDbModel unarchivedStory = story.copyWith(type: PathType.docs);
    Map<String, dynamic> json = unarchivedStory.toJson();
    json['moved_to_bin_at'] = null;
    return update(id: unarchivedStory.id, body: json);
  }
}
