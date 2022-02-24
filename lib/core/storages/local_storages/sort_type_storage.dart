import 'package:spooky/core/storages/base_storages/enum_storage.dart';
import 'package:spooky/core/types/sort_type.dart';

class SortTypeStorage extends EnumStorage<SortType> {
  @override
  List<SortType> get values => SortType.values;
}
