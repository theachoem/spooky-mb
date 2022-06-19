import 'package:flutter/material.dart';
import 'package:spooky/core/backups/backups_file_manager.dart';
import 'package:spooky/core/backups/backups_service.dart';
import 'package:spooky/core/backups/destinations/backup_destination_config.dart';
import 'package:spooky/core/backups/destinations/base_backup_destination.dart';
import 'package:spooky/core/backups/models/backups_metadata.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/db/databases/story_database.dart';
import 'package:spooky/core/models/cloud_file_model.dart';

class CloudStoragesViewModel extends BaseViewModel {
  final BackupsFileManager fileManager = BackupsFileManager();
  late final List<BaseBackupDestination> destinations;
  late final ValueNotifier<Set<String>> doingBackupIdsNotifier;
  final Map<String, BackupsMetadata?> _metadatas = {};

  int docsCount = 0;
  bool get hasStory => docsCount > 0;

  BackupsMetadata? metadata(String cloudId) {
    return _metadatas[cloudId];
  }

  CloudStoragesViewModel() {
    destinations = BackupDestinationConfig.destinations;
    doingBackupIdsNotifier = ValueNotifier({});
    load();
  }

  void setLoading(String cloudId, bool toLoading) {
    Set<String> value = {...doingBackupIdsNotifier.value};
    if (toLoading) {
      value.add(cloudId);
    } else {
      value.remove(cloudId);
    }
    doingBackupIdsNotifier.value = value;
  }

  Future<void> load() async {
    docsCount = StoryDatabase.instance.getDocsCount(null);
    for (BaseBackupDestination des in destinations) {
      _metadatas[des.cloudId] = await fileManager.lastSynced(des.cloudId);
    }
    notifyListeners();
  }

  Future<CloudFileModel?> backup(BaseBackupDestination destination) async {
    setLoading(destination.cloudId, true);
    CloudFileModel? uploadedFile = await BackupsService.instance.backup(destination: destination);
    await load();
    setLoading(destination.cloudId, false);
    return uploadedFile;
  }

  bool synced(String cloudId) {
    return lastSynced(cloudId) != null;
  }

  BackupsMetadata? lastSynced(String cloudId) {
    return _metadatas[cloudId];
  }
}
