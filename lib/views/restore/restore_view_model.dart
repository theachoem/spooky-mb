import 'dart:convert';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/backup/backup_service.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/api/cloud_storages/gdrive_backup_storage.dart';
import 'package:spooky/core/db/databases/story_database.dart';
import 'package:spooky/core/models/backup_display_model.dart';
import 'package:spooky/core/models/backup_model.dart';
import 'package:spooky/core/models/cloud_file_list_model.dart';
import 'package:spooky/core/models/cloud_file_model.dart';
import 'package:spooky/core/services/messenger_service.dart';

class RestoreViewModel extends BaseViewModel {
  late final ValueNotifier<bool> showSkipNotifier;
  final bool showSkipButton;

  Map<String, List<CloudFileModel>>? groupByYear;
  Map<String, CloudFileModel?>? _selectedBackupByYear;
  Map<String, CloudFileModel?>? get selectedBackupByYear => _selectedBackupByYear;

  CloudFileListModel? fileList;
  RestoreViewModel(this.showSkipButton) {
    load();
    showSkipNotifier = ValueNotifier<bool>(true);
  }

  void setSelectedBackupByYear(String key, CloudFileModel value) {
    _selectedBackupByYear?[key] = value;
    downloadedByYear.clear();
  }

  void setInitialSelectedBackupByYear() {
    _selectedBackupByYear = {};
    groupByYear?.forEach((key, value) {
      final displayModels = value.map((e) => BackupDisplayModel.fromCloudModel(e)).toList();
      displayModels.sort((a, b) => (a.createAt != null ? b.createAt?.compareTo(a.createAt!) : -1) ?? -1);
      selectedBackupByYear![key] = value.isNotEmpty ? value.first : null;
    });
  }

  void setGroupByYear() {
    Map<String, List<CloudFileModel>> groups = {};
    for (CloudFileModel e in fileList?.files ?? []) {
      BackupDisplayModel display = BackupDisplayModel.fromCloudModel(e);
      List<CloudFileModel>? type = groups[display.fileName];
      type != null ? type.add(e) : type = [e];
      groups[display.fileName] = type;
    }
    groupByYear = groups;
    setInitialSelectedBackupByYear();
  }

  bool _loaded = false;
  bool get loaded => _loaded;
  void _setLoaded(bool loaded) {
    _loaded = loaded;
    notifyListeners();
  }

  Future<void> load() async {
    _setLoaded(false);

    GDriveBackupStorage storage = GDriveBackupStorage();
    fileList = await storage.execHandler(() => storage.list({"next_token": fileList?.nextToken}));
    setGroupByYear();

    _setLoaded(true);
  }

  Map<String, BackupModel> cacheDownloadRestores = {};
  BackupModel? getCache(CloudFileModel file) {
    return cacheDownloadRestores[file.id];
  }

  Map<String, BackupModel> downloadedByYear = {};
  Future<Map<String, BackupModel>> downloadAll() async {
    downloadedByYear.clear();
    for (MapEntry<String, CloudFileModel?> backup in selectedBackupByYear?.entries.toList() ?? []) {
      final file = backup.value;
      if (file != null) {
        BackupModel? result = await download(file);
        if (result != null) downloadedByYear[backup.key] = result;
      }
    }
    notifyListeners();
    return downloadedByYear;
  }

  Future<BackupModel?> download(CloudFileModel file) async {
    if (cacheDownloadRestores.containsKey(file.id)) {
      return cacheDownloadRestores[file.id]!;
    } else {
      GDriveBackupStorage storage = GDriveBackupStorage();
      String? content = await storage.get({"file": file});
      if (content != null) {
        dynamic map = jsonDecode(content);
        if (map is Map<String, dynamic> && map.containsKey('version')) {
          BackupModel backup = BackupModel.withId(map, file.id);
          cacheDownloadRestores[file.id] = backup;
          return backup;
        }
      }
    }
    return null;
  }

  Future<bool> restore(
    BuildContext context,
    Map<String, BackupModel> files,
  ) async {
    List<int>? years = [];
    int result = 0;
    files.forEach((key, value) {
      int count = StoryDatabase().getDocsCount(value.year);
      if (count > 0) {
        result += count;
        years.add(value.year);
      }
    });

    years.sort();
    if (result > 0) {
      OkCancelResult result = await showOkCancelAlertDialog(
        context: context,
        title: "Notice",
        message: years.isNotEmpty
            ? "Look like you have some data in (${years.join(",")}). So, exist stories will be overrided by cloud stories. Are you sure to restore?"
            : "Exist stories will be overrided by cloud stories. Are you sure to restore?",
        okLabel: "Restore",
        isDestructiveAction: true,
      );
      switch (result) {
        case OkCancelResult.ok:
          break;
        case OkCancelResult.cancel:
          return false;
      }
    }

    for (var element in files.entries) {
      await BackupService().restore(element.value);
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showSkipNotifier.value = false;
      MessengerService.instance.showSnackBar("Restored");
    });

    return true;
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showSkipNotifier.dispose();
    });
  }

  Future<void> delete(BuildContext context, CloudFileModel file) async {
    OkCancelResult result = await showOkCancelAlertDialog(
      context: context,
      title: "Are you sure to delete?",
      message: "You can't undo this action",
      okLabel: "Delete",
      isDestructiveAction: true,
    );
    switch (result) {
      case OkCancelResult.ok:
        GDriveBackupStorage storage = GDriveBackupStorage();
        bool? success = await MessengerService.instance.showLoading(
          future: () async {
            await storage.execHandler(() async {
              return storage.delete({'file_id': file.id});
            });
            await load();
            return fileList?.files.map((e) => e.id).contains(file.id) == true;
          },
          context: context,
        );
        String message = success == true ? "Delete successfully!" : "Delete unsuccessfully!";
        MessengerService.instance.showSnackBar(message);
        break;
      case OkCancelResult.cancel:
        break;
    }
  }
}
