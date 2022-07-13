import 'package:flutter/foundation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:spooky/core/db/adapters/base/base_objectbox_adapter.dart';
import 'package:spooky/core/db/adapters/objectbox/entities.dart';
import 'package:spooky/core/db/models/tag_db_model.dart';

class TagObjectboxDbAdapter extends BaseObjectBoxAdapter<TagObjectBox, TagDbModel> {
  TagObjectboxDbAdapter(String tableName) : super(tableName);

  @override
  QueryBuilder<TagObjectBox>? buildQuery({Map<String, dynamic>? params}) => null;

  @override
  Future<TagObjectBox> objectConstructor(Map<String, dynamic> json) {
    return compute(_objectConstructor, json);
  }

  @override
  Future<TagDbModel> objectTransformer(TagObjectBox object) {
    return compute(_objectTransformer, object);
  }

  @override
  Future<List<TagDbModel>> itemsTransformer(List<TagObjectBox> objects) {
    return compute(_itemsTransformer, objects);
  }
}

List<TagDbModel> _itemsTransformer(List<TagObjectBox> object) {
  return object.map((e) {
    return _objectTransformer(e);
  }).toList();
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

TagDbModel _objectTransformer(TagObjectBox object) {
  return TagDbModel(
    id: object.id,
    version: object.version,
    title: object.title,
    starred: object.starred,
    emoji: object.emoji,
    createdAt: object.createdAt,
    updatedAt: object.updatedAt,
  );
}
