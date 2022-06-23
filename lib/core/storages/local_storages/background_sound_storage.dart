import 'package:spooky/core/notification/notification_service.dart';
import 'package:spooky/core/storages/base_object_storages/bool_storage.dart';

class BackgroundSoundStorage extends BoolStorage {
  @override
  Future<bool?> read() async {
    bool allowed = await NotificationService.isNotificationAllowed;
    bool background = await super.read() ?? true;
    return background && allowed;
  }
}
