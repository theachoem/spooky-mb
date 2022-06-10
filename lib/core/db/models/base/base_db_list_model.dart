import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:spooky/core/db/models/base/base_db_model.dart';
import 'package:spooky/core/db/models/base/links_model.dart';
import 'package:spooky/core/db/models/base/meta_model.dart';

part 'base_db_list_model.g.dart';

@CopyWith()
class BaseDbListModel<T extends BaseDbModel> {
  final List<T> items;
  final MetaModel? meta;
  final LinksModel? links;

  BaseDbListModel({
    required this.items,
    required this.meta,
    required this.links,
  });
}
