import 'package:spooky/core/db/adapters/base_db_adapter.dart';
import 'package:spooky/core/db/adapters/file_db_adapter.dart';
import 'package:spooky/core/db/models/base/base_db_list_model.dart';
import 'package:spooky/core/db/databases/base_database.dart';

import 'package:spooky/core/db/models/story_db_model.dart';

class StoryDatabase extends BaseDatabase<StoryDbModel> {
  @override
  BaseDbAdapter get adapter => FileDbAdapter();

  @override
  Future<BaseDbListModel<StoryDbModel>?> itemsTransformer(Map<String, dynamic> json) async {
    return null;
  }

  @override
  Future<StoryDbModel?> objectTransformer(Map<String, dynamic> json) async {
    return StoryDbModel.fromJson(json);
  }
}
