import 'package:flutter/foundation.dart';
import 'package:spooky/core/backups/backups_file_manager.dart';
import 'package:spooky/core/db/adapters/base/base_db_adapter.dart';
import 'package:spooky/core/db/adapters/objectbox/tag_objectbox_db_adapter.dart';
import 'package:spooky/core/db/databases/base_database.dart';
import 'package:spooky/core/db/models/base/base_db_list_model.dart';
import 'package:spooky/core/db/models/tag_db_model.dart';

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
  Future<BaseDbListModel<TagDbModel>?> itemsTransformer(Map<String, dynamic> json) async {
    return BaseDbListModel(
      items: await buildItemsList(json),
      meta: await buildMeta(json),
      links: await buildLinks(json),
    );
  }

  @override
  Future<BaseDbListModel<TagDbModel>?> fetchAll({Map<String, dynamic>? params}) async {
    BaseDbListModel<TagDbModel>? result = await super.fetchAll(params: params);
    List<TagDbModel> items = [...result?.items ?? []]..sort((a, b) => a.index.compareTo(b.index));

    for (int i = 0; i < items.length; i++) {
      if (items[i].starred == null) {
        items[i] = items[i].copyWith(starred: true);
        set(body: items[i]);
      }
    }

    result = result?.copyWith(items: items);
    return result;
  }

  @override
  Future<TagDbModel?> objectTransformer(Map<String, dynamic> json) {
    return compute(_constructTagIsolate, json);
  }

  @override
  Future<void> onCRUD(TagDbModel? object) async {
    BackupsFileManager().clear();
  }
}
