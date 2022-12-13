import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/backups/backups_file_manager.dart';
import 'package:spooky/core/db/adapters/base/base_db_adapter.dart';
import 'package:spooky/core/db/adapters/objectbox/tag_objectbox_db_adapter.dart';
import 'package:spooky/core/db/databases/base_database.dart';
import 'package:spooky/core/db/models/base/base_db_list_model.dart';
import 'package:spooky/core/db/models/tag_db_model.dart';
import 'package:spooky/main.dart';
import 'package:spooky/providers/has_tags_changes_provider.dart';

TagDbModel _constructTagIsolate(Map<String, dynamic> json) {
  return TagDbModel.fromJson(json);
}

class TagDatabase extends BaseDatabase<TagDbModel> {
  static final TagDatabase instance = TagDatabase._();
  TagDatabase._();

  @override
  BaseDbAdapter<TagDbModel> get adapter => TagObjectboxDbAdapter(tableName);

  @override
  String get tableName => "tags";

  @override
  Future<BaseDbListModel<TagDbModel>?> fetchAll({Map<String, dynamic>? params}) async {
    BaseDbListModel<TagDbModel>? result = await super.fetchAll(params: params);
    List<TagDbModel> items = [...result?.items ?? []]..sort((a, b) => a.index.compareTo(b.index));
    result = result?.copyWith(items: items);
    Global.instance.setTags(result?.items ?? []);
    return result;
  }

  BaseDbListModel<TagDbModel>? cache;
  Future<BaseDbListModel<TagDbModel>?> fetchAllCache({Map<String, dynamic>? params}) async {
    return cache ??= await fetchAll(params: params);
  }

  @override
  Future<TagDbModel?> objectTransformer(Map<String, dynamic> json) {
    return compute(_constructTagIsolate, json);
  }

  @override
  Future<void> onCRUD(TagDbModel? object) async {
    BackupsFileManager().clear();
    cache = null;
    App.navigatorKey.currentContext?.read<HasTagsChangesProvider>().changed();
  }
}
