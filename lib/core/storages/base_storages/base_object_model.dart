import 'dart:convert';
import 'package:spooky/core/storages/base_storages/share_preference_storage.dart';

abstract class BaseObjectModel<T> extends SharePreferenceStorage<String> {
  Future<Map<String, dynamic>?> readMap() async {
    String? result = await super.read();
    if (result != null) return jsonDecode(result);
    return null;
  }

  Future<void> writeMap(Map<String, dynamic> map) async {
    return super.write(jsonEncode(map));
  }

  Map<String, dynamic> serialize(T object);
  T deserialize(Map<String, dynamic> json);

  Future<T?> readObject() async {
    Map<String, dynamic>? json = await readMap();
    if (json != null) return deserialize(json);
    return null;
  }

  Future<void> writeObject(T object) async {
    return writeMap(serialize(object));
  }
}
