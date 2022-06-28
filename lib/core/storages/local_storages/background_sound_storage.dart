import 'package:spooky/core/storages/base_object_storages/bool_storage.dart';

class BackgroundSoundStorage extends BoolStorage {
  @override
  int? get version => 2;

  @override
  Future<bool?> read() async {
    bool background = await super.read() ?? true;
    return background;
  }
}
