import 'package:spooky/core/storages/base_storages/share_preference_storage.dart';

// when user update anything to stories db
// this hash should be update to alert story query list to reload.
class LastUpdateStoryListHashStorage extends SharePreferenceStorage<int> {
  // set current date as hast
  Future<void> setHash(DateTime date) {
    return write(date.millisecondsSinceEpoch);
  }

  Future<bool> shouldReloadList(int currentHash) async {
    int? value = await read();
    return value != null && currentHash != value;
  }
}
