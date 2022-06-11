import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:spooky/core/storages/preference_storages/secure_storage.dart';

class PurchasedAddOnStorage extends SecureStorage {
  Future<void> writeList(List<String> productIds) async {
    String map = jsonEncode(productIds.toSet().toList());
    return write(map);
  }

  Future<List<String>?> readList() async {
    final string = await read();

    if (string != null) {
      try {
        final decoded = jsonDecode(string);
        if (decoded is List) {
          List<String> list = [];
          for (final e in decoded) {
            if (e is String) list.add(e);
          }
          return list;
        }
      } catch (e) {
        if (kDebugMode) {
          print("$e");
        }
      }
    }

    return null;
  }
}
