import 'package:flutter/material.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'backup_sources_view.dart';

class BackupSourcesViewModel extends BaseViewModel {
  final BackupSourcesRoute params;

  BackupSourcesViewModel({
    required this.params,
  });

  bool disabledActions = false;

  Future<T> call<T>(Future<T> Function() callback) async {
    disabledActions = true;
    notifyListeners();

    T result = await callback();

    disabledActions = false;
    notifyListeners();

    return result;
  }

  Future<void> onPopInvokedWithResult(bool didPop, dynamic result, BuildContext context) async {
    if (didPop) return;
    if (!disabledActions) Navigator.of(context).pop(result);
  }
}
