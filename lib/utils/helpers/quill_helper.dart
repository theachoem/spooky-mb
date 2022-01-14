import 'package:flutter/foundation.dart';

class QuillHelper {
  static List<String> imagesFromJson(List document) {
    List<String> images = [];
    try {
      for (dynamic e in document) {
        final insert = e['insert'];
        if (insert is Map) {
          for (MapEntry<dynamic, dynamic> e in insert.entries) {
            if (e.value != null && e.value.isNotEmpty) {
              images.add(e.value);
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        rethrow;
      }
    }
    return images;
  }
}
