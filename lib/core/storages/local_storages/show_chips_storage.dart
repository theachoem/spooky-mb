import 'package:spooky/core/storages/base_object_storages/bool_storage.dart';

// always return true as default
class ShowChipsStorage extends BoolStorage {
  @override
  Future<bool?> read() async {
    return true;
  }
}
