import 'package:spooky/core/databases/models/story_db_model.dart';
import 'package:spooky/core/databases/models/tag_db_model.dart';

class DatabaseInitializer {
  static Future<void> call() async {
    await StoryDbModel.db.initilize();
    await TagDbModel.db.initilize();
  }
}
