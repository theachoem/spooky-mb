import 'dart:convert';

import 'package:spooky/core/models/base_model.dart';

mixin ComparableMixin<T extends BaseModel> on BaseModel {
  bool hasChanges(T other) {
    return keepComparableKeys(toJson()).hashCode != keepComparableKeys(other.toJson()).hashCode;
  }

  String keepComparableKeys(Map<String, dynamic> json) {
    json.removeWhere((key, value) {
      if (includeCompareKeys != null) {
        return excludeCompareKeys.contains(key) && !includeCompareKeys!.contains(key);
      } else {
        return excludeCompareKeys.contains(key);
      }
    });
    return jsonEncode(json);
  }

  List<String> get excludeCompareKeys;
  List<String>? get includeCompareKeys => null;
}
