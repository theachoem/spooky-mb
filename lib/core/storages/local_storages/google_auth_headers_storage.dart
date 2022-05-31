import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:spooky/core/storages/base_storages/secure_storage.dart';

class GoogleAuthHeadersStorage extends SecureStorage {
  Future<void> writeMap(Map<String, String> map) {
    return write(jsonEncode(map));
  }

  Future<Map<String, String>?> readMap() async {
    var str = await super.read();
    if (str != null) {
      try {
        dynamic map = jsonDecode(str);
        if (map is Map) {
          return {for (MapEntry e in map.entries) e.key: e.value.toString()};
        }
      } catch (e) {
        if (kDebugMode) print("ERROR: readMap $e");
      }
    }
    return null;
  }
}
