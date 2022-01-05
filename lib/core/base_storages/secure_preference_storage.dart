import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SecurePreferenceStorage {
  FlutterSecureStorage storage = FlutterSecureStorage();
  Future<SharedPreferences> get instance => SharedPreferences.getInstance();
  String get key;
  Object? error;

  Future<T> sharePreference<T>(Future<T> Function(SharedPreferences) body) async {
    return SharedPreferences.getInstance().then((value) {
      return body(value);
    });
  }

  Future<String?> read() async {
    error = null;
    try {
      if (kIsWeb) {
        return sharePreference<String?>((storage) async {
          return storage.getString(key);
        });
      } else {
        final result = await storage.read(key: key);
        return result;
      }
    } catch (e) {
      error = e;
    }
  }

  Future<void> write(String value) async {
    error = null;
    try {
      if (kIsWeb) {
        return sharePreference<void>((storage) async {
          storage.setString(key, value);
        });
      } else {
        await storage.write(key: key, value: value);
      }
    } catch (e) {
      error = e;
    }
  }

  Future<void> remove() async {
    try {
      if (kIsWeb) {
        return sharePreference<void>((storage) async {
          storage.remove(key);
        });
      } else {
        await storage.delete(key: key);
      }
      error = null;
    } catch (e) {
      error = e;
    }
  }

  Future<void> writeMap(Map<dynamic, dynamic> map) async {
    await this.write(jsonEncode(map));
  }

  Future<Map<dynamic, dynamic>?> readMap() async {
    final read = await this.read();
    if (read == null) return null;
    final json = jsonDecode(read);
    if (json is Map) return json;
  }
}
