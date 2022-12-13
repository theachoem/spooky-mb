import 'package:flutter/foundation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:spooky/core/db/adapters/base/base_objectbox_adapter.dart';
import 'package:spooky/core/db/adapters/objectbox/entities.dart';
import 'package:spooky/core/db/models/category_db_model.dart';

class CategoryObjectboxDbAdapter extends BaseObjectBoxAdapter<CategoryObjectBox, CategoryDbModel> {
  CategoryObjectboxDbAdapter(String tableName) : super(tableName);

  @override
  QueryBuilder<CategoryObjectBox>? buildQuery({Map<String, dynamic>? params}) => null;

  @override
  Future<CategoryObjectBox> objectConstructor(CategoryDbModel json, [Map<String, dynamic>? params]) {
    return compute(_objectConstructor, json);
  }

  @override
  Future<CategoryDbModel> objectTransformer(CategoryObjectBox object, [Map<String, dynamic>? params]) {
    return compute(_objectTransformer, object);
  }

  @override
  Future<List<CategoryDbModel>> itemsTransformer(List<CategoryObjectBox> objects, [Map<String, dynamic>? params]) {
    return compute(_itemsTransformer, objects);
  }
}

List<CategoryDbModel> _itemsTransformer(List<CategoryObjectBox> object) {
  return object.map((e) {
    return _objectTransformer(e);
  }).toList();
}

CategoryObjectBox _objectConstructor(CategoryDbModel tag) {
  return CategoryObjectBox(
    id: tag.id,
    position: tag.position,
    type: tag.type,
    name: tag.name,
    budget: tag.budget,
    icon: tag.icon,
    createdAt: tag.createdAt,
    updatedAt: tag.updatedAt,
  );
}

CategoryDbModel _objectTransformer(CategoryObjectBox object) {
  return CategoryDbModel(
    id: object.id,
    position: object.position,
    type: object.type,
    name: object.name,
    budget: object.budget,
    icon: object.icon,
    createdAt: object.createdAt,
    updatedAt: object.updatedAt,
  );
}
