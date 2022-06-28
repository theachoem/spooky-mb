import 'package:flutter/material.dart';
import 'package:spooky/core/backups/destinations/base_backup_destination.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/models/cloud_file_list_model.dart';
import 'package:spooky/core/models/cloud_file_model.dart';

class BackupHistoriesManagerViewModel extends BaseViewModel {
  final BaseBackupDestination destination;
  late final ValueNotifier<bool> loadingNotifier;
  late final ValueNotifier<Set<String>> selectedNotifier;
  CloudFileListModel? list;

  @override
  void dispose() {
    selectedNotifier.dispose();
    loadingNotifier.dispose();
    super.dispose();
  }

  bool _editing = false;
  bool get editing => _editing;

  void toggleEditing() {
    _editing = !_editing;
    notifyListeners();
  }

  BackupHistoriesManagerViewModel(this.destination) {
    loadingNotifier = ValueNotifier<bool>(true);
    selectedNotifier = ValueNotifier({});
    load(false);
  }

  Future<void> load([bool reload = true]) async {
    if (!reload) loadingNotifier.value = true;
    list = await destination.fetchAll();
    if (!reload) loadingNotifier.value = false;
    notifyListeners();
  }

  Future<void> deleteSelected() async {
    var files = list?.files ?? [];
    for (String selected in selectedNotifier.value) {
      var result = files.where((e) => e.id == selected);
      if (result.isNotEmpty) {
        CloudFileModel file = result.first;
        await delete(file);
      }
    }
  }

  Future<void> delete(CloudFileModel file) async {
    await destination.delete(file);
    await load();
  }
}
