import 'package:spooky/core/storages/user_storage.dart';

class UserInitializer {
  static Future<void> call() async {
    await UserStorage.instance.load();
  }
}
