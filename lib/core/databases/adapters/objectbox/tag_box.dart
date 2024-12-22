import 'package:flutter/foundation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:spooky/core/databases/adapters/objectbox/base_box.dart';
import 'package:spooky/core/databases/adapters/objectbox/entities.dart';
import 'package:spooky/core/databases/models/collection_db_model.dart';
import 'package:spooky/core/databases/models/tag_db_model.dart';

class TagBox extends BaseObjectBox<TagObjectBox, TagDbModel> {
  @override
  String get tableName => "tags";

  @override
  Future<CollectionDbModel<TagDbModel>?> where({Map<String, dynamic>? filters}) async {
    CollectionDbModel<TagDbModel>? result = await super.where(filters: filters);
    List<TagDbModel> items = [...result?.items ?? []]..sort((a, b) => a.index.compareTo(b.index));

    for (int i = 0; i < items.length; i++) {
      if (items[i].starred == null) {
        items[i] = items[i].copyWith(starred: true);
        update(items[i]);
      }
    }

    return CollectionDbModel(
      items: items,
    );
  }

  @override
  QueryBuilder<TagObjectBox>? buildQuery({
    Map<String, dynamic>? filters,
  }) {
    return null;
  }

  @override
  Future<List<TagDbModel>> itemsTransformer(List<TagObjectBox> objects, [Map<String, dynamic>? options]) {
    return compute(_itemsTransformer, {'objects': objects, 'options': options});
  }

  @override
  Future<TagObjectBox> objectConstructor(TagDbModel object, [Map<String, dynamic>? options]) {
    return compute(_objectConstructor, {'object': object, 'options': options});
  }

  @override
  Future<TagDbModel> objectTransformer(TagObjectBox object, [Map<String, dynamic>? options]) {
    return compute(_objectTransformer, {'object': object, 'options': options});
  }
}

List<TagDbModel> _itemsTransformer(Map<String, dynamic> options) {
  List<TagObjectBox> objects = options['objects'];
  return objects.map((object) => _objectTransformer({'object': object})).toList();
}

TagObjectBox _objectConstructor(Map<String, dynamic> options) {
  TagDbModel object = options['object'];

  return TagObjectBox(
    id: object.id,
    title: object.title,
    index: object.index,
    version: object.version,
    starred: object.starred,
    emoji: object.emoji,
    createdAt: object.createdAt,
    updatedAt: object.updatedAt,
  );
}

TagDbModel _objectTransformer(Map<String, dynamic> options) {
  TagObjectBox object = options['object'];

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
