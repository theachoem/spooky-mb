import 'package:spooky/core/databases/models/base_db_model.dart';

class CollectionDbModel<T extends BaseDbModel> {
  final List<T> items;

  CollectionDbModel({
    required this.items,
  });
}
