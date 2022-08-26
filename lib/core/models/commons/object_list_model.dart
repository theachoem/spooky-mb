import 'package:spooky/core/models/base_model.dart';
import 'package:spooky/core/models/commons/links_model.dart';
import 'package:spooky/core/models/commons/meta_model.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'object_list_model.g.dart';

@CopyWith()
class ObjectListModel<T extends BaseModel> {
  final List<T> items;
  final MetaModel? meta;
  final LinksModel? links;

  ObjectListModel({
    required this.items,
    this.meta,
    this.links,
  });

  ObjectListModel<T> add(ObjectListModel<T> newList) {
    return newList.copyWith(items: [
      ...items,
      ...newList.items,
    ]);
  }

  bool hasLoadMore() {
    if (meta == null) return false;
    return items.length < meta!.totalCount!;
  }
}
