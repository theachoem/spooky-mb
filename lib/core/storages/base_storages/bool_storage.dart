import 'package:spooky/core/storages/base_storages/share_preference_storage.dart';

abstract class BoolStorage extends SharePreferenceStorage<bool> {
  Future<void> toggle() async {
    final bool current = await read() == true;
    (await adapter).write(key: key, value: !current);
  }
}
