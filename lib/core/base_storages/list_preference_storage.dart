import 'dart:convert';
import 'package:spooky/core/base_storages/share_preference_storage.dart';

abstract class ListPreferenceStorage<T> extends SharePreferenceStorage {
  Future<void> writeList(List<T> value) async {
    await super.write(jsonEncode(value));
  }

  Future<List<T>?> readList() async {
    String? value = await super.read();
    if (value == null) return null;
    try {
      List<T> result = jsonDecode("$value");
      return result;
    } catch (e) {
      return null;
    }
  }
}
