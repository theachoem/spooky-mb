import 'dart:convert';

import 'package:spooky/core/models/base_model.dart';

mixin ComparableMixin<T extends BaseModel> on BaseModel {
  bool hasChanges(T other) {
    return keepComparableKeys(toJson()) != keepComparableKeys(other.toJson());
  }

  String keepComparableKeys(Map<String, dynamic> json) {
    json.removeWhere((key, value) {
      return excludeCompareKeys.contains(key);
    });
    return jsonEncode(json);
  }

  List<String> get excludeCompareKeys;
}
