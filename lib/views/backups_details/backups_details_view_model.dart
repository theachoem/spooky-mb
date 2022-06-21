import 'package:flutter/material.dart';
import 'package:spooky/core/backups/destinations/base_backup_destination.dart';
import 'package:spooky/core/backups/destinations/cloud_file_tuple.dart';
import 'package:spooky/core/backups/models/backups_model.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/models/cloud_file_model.dart';

class BackupsDetailsViewModel extends BaseViewModel {
  late final ValueNotifier<bool> loadingNotifier;

  final BaseBackupDestination destination;
  final List<CloudFileTuple> cloudFiles;
  final CloudFileModel initialCloudFile;

  late String selectCloudFileId;
  BackupsModel? backup;

  Future<void> setCurrentCloudVersion(String cloudId) {
    selectCloudFileId = cloudId;
    return load();
  }

  BackupsDetailsViewModel(
    this.destination,
    this.cloudFiles,
    this.initialCloudFile,
  ) {
    loadingNotifier = ValueNotifier<bool>(false);
    selectCloudFileId = initialCloudFile.id;
    load(false);
  }

  Future<void> load([bool reload = true]) async {
    return _load();
  }

  CloudFileTuple? getCloudFile() {
    Iterable<CloudFileTuple> selected = cloudFiles.where((e) => e.cloudFile.id == selectCloudFileId);
    if (selected.isNotEmpty) return selected.first;
    return null;
  }

  Future<void> _load() async {
    loadingNotifier.value = true;
    CloudFileTuple? cloudFile = getCloudFile();
    backup = cloudFile != null ? await destination.download(cloudFile.cloudFile) : null;

    // avoid set on disposed
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadingNotifier.value = false;
    });

    notifyListeners();
  }

  @override
  void dispose() {
    loadingNotifier.dispose();
    super.dispose();
  }
}
