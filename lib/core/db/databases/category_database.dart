import 'package:flutter/foundation.dart';
import 'package:spooky/core/db/adapters/base/base_db_adapter.dart';
import 'package:spooky/core/db/adapters/objectbox/category_objectbox_db_adapter.dart';
import 'package:spooky/core/db/databases/base_database.dart';
import 'package:spooky/core/db/models/category_db_model.dart';

CategoryDbModel _constructCategoryIsolate(Map<String, dynamic> json) {
  return CategoryDbModel.fromJson(json);
}

class CategoryDatabase extends BaseDatabase<CategoryDbModel> {
  static final CategoryDatabase instance = CategoryDatabase._();
  CategoryDatabase._();

  @override
  BaseDbAdapter<CategoryDbModel> get adapter => CategoryObjectboxDbAdapter(tableName);

  @override
  String get tableName => "categories";

  @override
  Future<void> onCRUD(CategoryDbModel? object) async {}

  @override
  Future<CategoryDbModel?> objectTransformer(Map<String, dynamic> json) {
    return compute(_constructCategoryIsolate, json);
  }
}
