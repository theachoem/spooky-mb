import 'package:flutter/material.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/backups/backups_file_manager.dart';
import 'package:spooky/core/backups/destinations/base_backup_destination.dart';
import 'package:spooky/core/backups/destinations/cloud_file_tuple.dart';
import 'package:spooky/core/backups/models/backups_metadata.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/models/cloud_file_list_model.dart';
import 'package:spooky/core/services/messenger_service.dart';

abstract class BaseCloudProvider extends BaseViewModel {
  final BackupsFileManager fileManager = BackupsFileManager();
  BaseBackupDestination get destination;

  String? get name;
  String? get username;
  String get cloudName;
  bool get isSignedIn;
  CloudFileTuple? lastMetaData;
  BackupsMetadata? lastLocalMetaData;
  DateTime? get lastBackup => lastMetaData?.metadata.createdAt ?? lastLocalMetaData?.createdAt;

  // set on fetch all
  CloudFileListModel? fileList;

  // one for syncing icon & other for button
  late final ValueNotifier<bool> loadingBackupNotifier;
  late final ValueNotifier<bool> doingBackupNotifier;

  BaseCloudProvider() {
    loadingBackupNotifier = ValueNotifier<bool>(false);
    doingBackupNotifier = ValueNotifier<bool>(false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await load(false);
    });
  }

  // base on last changes
  bool get synced => lastLocalMetaData != null;
  bool get released => true;

  // level 0: normal loading
  // level 1: syning
  void setLoading(int level, bool loading) {
    switch (level) {
      case 0:
        loadingBackupNotifier.value = loading;
        break;
      case 1:
        loadingBackupNotifier.value = loading;
        doingBackupNotifier.value = loading;
        break;
      default:
    }
  }

  @override
  void dispose() {
    doingBackupNotifier.dispose();
    loadingBackupNotifier.dispose();
    super.dispose();
  }

  @mustCallSuper
  Future<void> signIn() async {
    if (lastLocalMetaData == null) return;

    bool sameLastMetaData =
        lastLocalMetaData?.createdAt.millisecondsSinceEpoch == lastMetaData?.metadata.createdAt.millisecondsSinceEpoch;

    if (!sameLastMetaData || lastMetaData == null) {
      await fileManager.clearSync(cloudStorageId: destination.cloudId);
      lastLocalMetaData = null;
      notifyListeners();
    }
  }

  Future<void> signOut();

  @mustCallSuper
  Future<void> load([bool reload = true]) async {
    if (reload) {
      BuildContext? context = App.navigatorKey.currentContext;
      if (context != null) {
        return MessengerService.instance.showLoading<void>(
          context: App.navigatorKey.currentContext!,
          future: () async {
            return _load();
          },
        );
      }
    }

    await _load();
  }

  Future<void> _load() async {
    setLoading(0, true);

    lastLocalMetaData = await fileManager.lastSynced(destination.cloudId);
    await loadAuthentication();

    if (isSignedIn) {
      fileList = await destination.fetchAll();
      lastMetaData = destination.lastSyncFromFile(fileList);
    }

    setLoading(0, false);
    notifyListeners();
  }

  Future<void> loadAuthentication();
}
