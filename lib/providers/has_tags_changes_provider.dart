import 'package:flutter/material.dart';

class HasTagsChangesProvider extends ChangeNotifier {
  bool hasChanges = false;

  void changed() {
    hasChanges = true;
    notifyListeners();
  }
}
