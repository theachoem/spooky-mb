import 'package:spooky/core/storages/base_object_storages/enum_storage.dart';
import 'package:spooky/main.dart';
import 'package:spooky/widgets/sp_story_list/sp_story_list.dart';

class SpListLayoutTypeStorage extends EnumStorage<SpListLayoutType> {
  @override
  List<SpListLayoutType> get values => SpListLayoutType.values;

  @override
  Future<void> writeEnum(SpListLayoutType value) {
    Global.instance.setLayoutType(value);
    return super.writeEnum(value);
  }
}
