import 'package:shared_preferences/shared_preferences.dart';

abstract class SharePreferenceStorage {
  String get key => runtimeType.toString();

  Future<dynamic> read() async {
    final storage = await SharedPreferences.getInstance();
    return storage.get(key);
  }

  Future<void> write(dynamic value) async {
    assert(value is int || value is String);
    final storage = await SharedPreferences.getInstance();

    if (value is int) {
      await storage.setInt(key, value);
    } else {
      await storage.setString(key, value);
    }
  }

  Future<void> remove() async {
    final storage = await SharedPreferences.getInstance();
    await storage.remove(key);
  }
}
