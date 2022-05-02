import 'dart:convert';
import 'dart:io';

import 'package:spooky/core/db/adapters/base/base_db_adapter.dart';
import 'package:spooky/core/db/adapters/base/base_file_db_adpater.dart';
import 'package:spooky/core/db/models/base/base_db_list_model.dart';
import 'package:spooky/core/db/databases/base_database.dart';
import 'package:spooky/core/db/models/base/meta_model.dart';
import 'package:spooky/utils/helpers/app_helper.dart';
import 'package:spooky/utils/helpers/file_helper.dart';
import 'package:spooky/core/db/models/story_db_model.dart';

part '../adapters/file/story_file_db_adapter.dart';

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
  Future<StoryDbModel?> objectTransformer(Map<String, dynamic> json) async {
    return StoryDbModel.fromJson(json);
  }
}
