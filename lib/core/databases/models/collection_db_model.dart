import 'package:spooky/core/databases/models/base_db_model.dart';

class CollectionDbModel<T extends BaseDbModel> {
  final List<T> items;

  CollectionDbModel({
    required this.items,
  });

  CollectionDbModel<T> replaceElement(T item) {
    List<T> newItems = items.toList();
    int index = newItems.indexWhere((e) => e.id == item.id);
    newItems[index] = item;

    return CollectionDbModel(
      items: newItems,
    );
  }

  CollectionDbModel<T>? removeElement(T item) {
    List<T> newItems = items.toList()..removeWhere((e) => e.id == item.id);
    return CollectionDbModel(items: newItems);
  }
}
