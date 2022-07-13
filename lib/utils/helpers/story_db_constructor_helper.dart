import 'dart:convert';

import 'package:html_character_entities/html_character_entities.dart';
import 'package:spooky/core/db/models/story_content_db_model.dart';

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
}
