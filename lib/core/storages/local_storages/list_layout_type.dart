import 'package:spooky/core/storages/base_object_storages/enum_storage.dart';
import 'package:spooky/core/types/list_layout_type.dart';

class ListLayoutStorage extends EnumStorage<ListLayoutType> {
  @override
  List<ListLayoutType> get values => ListLayoutType.values;
}
