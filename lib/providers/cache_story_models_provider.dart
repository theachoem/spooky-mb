import 'package:flutter/foundation.dart';
import 'package:spooky/core/db/databases/story_database.dart';
import 'package:spooky/core/db/models/story_db_model.dart';

// save to reload story tile.
// should call 2 time, before & after updated.
class CacheStoryModelsProvider extends ChangeNotifier {
  Map<int, StoryDbModel?> stories = {};

  CacheStoryModelsProvider._();
  static final CacheStoryModelsProvider instance = CacheStoryModelsProvider._();

  void update(
    StoryDbModel story, {
    required String debugSource,
  }) {
    if (kDebugMode) print("SET story: ${story.id} from: $debugSource");
    stories[story.id] = story;
  }

  void updateAll(
    List<StoryDbModel> stories, {
    required String debugSource,
  }) {
    if (kDebugMode) print("SET stories: ${stories.length} from: $debugSource");
    for (StoryDbModel story in stories) {
      this.stories[story.id] = story;
    }
  }

  Future<StoryDbModel?> get(int id) async {
    stories[id] ??= await StoryDatabase.instance.fetchOne(id: id);
    return stories[id];
  }
}
