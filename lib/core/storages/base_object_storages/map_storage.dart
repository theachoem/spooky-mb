import 'dart:convert';
import 'package:spooky/core/storages/preference_storages/default_storage.dart';

abstract class MapStorage extends DefaultStorage<String> {
  Future<Map<String, dynamic>?> readMap() async {
    String? result = await super.read();
    if (result != null) return jsonDecode(result);
    return null;
  }

  Future<void> writeMap(Map<String, dynamic> map) async {
    return super.write(jsonEncode(map));
  }
}
