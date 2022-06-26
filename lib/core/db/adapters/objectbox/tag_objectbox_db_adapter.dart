import 'package:flutter/foundation.dart';
import 'package:spooky/core/db/adapters/base/base_objectbox_adapter.dart';
import 'package:spooky/core/db/adapters/objectbox/entities.dart';
import 'package:spooky/core/db/models/base/links_model.dart';
import 'package:spooky/core/db/models/base/meta_model.dart';
import 'package:spooky/core/db/models/tag_db_model.dart';

class TagObjectboxDbAdapter extends BaseObjectBoxAdapter<TagObjectBox> {
  TagObjectboxDbAdapter(String tableName) : super(tableName);

  @override
  Future<Map<String, dynamic>?> fetchAll({Map<String, dynamic>? params}) async {
    List<TagObjectBox> tags = box.getAll();
    List<Map<String, dynamic>> docs = [];

    for (TagObjectBox tag in tags) {
      Map<String, dynamic> json = await objectTransformer(tag);
      docs.add(json);
    }

    return {
      "data": docs,
      "meta": MetaModel().toJson(),
      "links": LinksModel().toJson(),
    };
  }

  @override
  Future<TagObjectBox> objectConstructor(Map<String, dynamic> json) {
    return compute(_objectConstructor, json);
  }

  @override
  Future<Map<String, dynamic>> objectTransformer(TagObjectBox object) {
    return compute(_objectTransformer, object);
  }
}

TagObjectBox _objectConstructor(Map<String, dynamic> json) {
  TagDbModel tag = TagDbModel.fromJson(json);
  return TagObjectBox(
    id: tag.id,
    title: tag.title,
    version: tag.version,
    starred: tag.starred,
    emoji: tag.emoji,
    createdAt: tag.createdAt,
    updatedAt: tag.updatedAt,
  );
}

Map<String, dynamic> _objectTransformer(TagObjectBox object) {
  return TagDbModel(
    id: object.id,
    version: object.version,
    title: object.title,
    starred: object.starred,
    emoji: object.emoji,
    createdAt: object.createdAt,
    updatedAt: object.updatedAt,
  ).toJson();
}
