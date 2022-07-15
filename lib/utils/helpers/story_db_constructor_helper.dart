import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:spooky/core/db/models/story_content_db_model.dart';
import 'package:spooky/core/db/models/story_db_model.dart';

List<StoryContentDbModel> _changesConstructor(List<String> rawChanges) {
  return StoryDbConstructorHelper.strsToChanges(rawChanges);
}

class StoryDbConstructorHelper {
  static List<StoryContentDbModel> strsToChanges(List<String> changes) {
    List<StoryContentDbModel> items = [];
    for (String str in changes) {
      String decoded = HtmlCharacterEntities.decode(str);
      dynamic json = jsonDecode(decoded);
      items.add(StoryContentDbModel.fromJson(json));
    }
    return items;
  }

  static List<String> changesToStrs(List<StoryContentDbModel> changes) {
    return changes.map((e) {
      Map<String, dynamic> json = e.toJson();
      String encoded = jsonEncode(json);
      return HtmlCharacterEntities.encode(encoded);
    }).toList();
  }

  static Future<StoryDbModel> loadChanges(StoryDbModel story) async {
    if (story.rawChanges != null) {
      List<StoryContentDbModel> changes = await compute(_changesConstructor, story.rawChanges!);
      story = story.copyWith(changes: changes);
    }
    return story;
  }
}
