import 'package:flutter/material.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/concerns/schedule_concern.dart';

class SearchViewModel extends BaseViewModel with ScheduleConcern {
  ValueNotifier<String> queryNotifier = ValueNotifier('');

  void search(String query) {
    scheduleAction(() {
      queryNotifier.value = query;
    });
  }

  @override
  void dispose() {
    queryNotifier.dispose();
    super.dispose();
  }
}
