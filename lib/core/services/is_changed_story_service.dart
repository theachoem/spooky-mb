import 'package:flutter/foundation.dart';
import 'package:spooky/core/db/models/story_db_model.dart';

@Deprecated("Use CacheStoryModelsProvider")
// Write at BaseStoryWriter
// Read at SpStoryTile
class IsChangedStoryService {
  IsChangedStoryService._();
  static final IsChangedStoryService instance = IsChangedStoryService._();
  final Map<int, int> _hashes = {};

  int constructorHash(StoryDbModel story) {
    return story.updatedAt.millisecondsSinceEpoch;
  }

  bool hasChanged(StoryDbModel currentStory) {
    int? memoryHash = _hashes[currentStory.id];
    if (memoryHash == null) return false;

    int storyHash = constructorHash(currentStory);
    bool changed = memoryHash != storyHash;

    if (kDebugMode) print("storyHash: $storyHash - memoryHash: $memoryHash - changed: $changed");
    return changed;
  }

  void setChanged(StoryDbModel story) {
    _hashes[story.id] = constructorHash(story);
    if (kDebugMode) print("SET: ${story.id}: ${_hashes[story.id]}");
  }
}
