import 'package:flutter/material.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/backups/backups_file_manager.dart';
import 'package:spooky/core/backups/destinations/base_backup_destination.dart';
import 'package:spooky/core/backups/models/backups_metadata.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/models/cloud_file_list_model.dart';
import 'package:spooky/core/models/cloud_file_model.dart';
import 'package:spooky/core/services/messenger_service.dart';

abstract class BaseCloudProvider extends BaseViewModel {
  final BackupsFileManager fileManager = BackupsFileManager();
  BaseBackupDestination get destination;

  String? get name;
  String? get username;
  String get cloudName;
  bool get isSignedIn;
  BackupsMetadata? lastMetaData;
  BackupsMetadata? lastLocalMetaData;
  DateTime? get lastBackup => lastMetaData?.createdAt ?? lastLocalMetaData?.createdAt;

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
        lastLocalMetaData?.createdAt.millisecondsSinceEpoch == lastMetaData?.createdAt.millisecondsSinceEpoch;

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
      CloudFileListModel? fileList = await destination.fetchAll();
      List<CloudFileModel> files = fileList?.files ?? [];

      BackupsMetadata? lastMetaData;

      for (CloudFileModel file in files) {
        String? fileName = file.fileName;
        BackupsMetadata? metaData = BackupsMetadata.fromFileName(fileName ?? "");
        lastMetaData ??= metaData;

        if (metaData != null) {
          bool lastest = lastMetaData?.createdAt.isBefore(metaData.createdAt) == true;
          if (lastest) lastMetaData = metaData;
        }
      }

      this.lastMetaData = lastMetaData;
    }

    setLoading(0, false);
    notifyListeners();
  }

  Future<void> loadAuthentication();
}
