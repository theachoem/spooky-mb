import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/objects/backup_object.dart';
import 'package:spooky/core/objects/cloud_file_list_object.dart';
import 'package:spooky/core/objects/cloud_file_object.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/providers/backup_sources_provider.dart';
import 'package:spooky/views/backup_sources/show/local_widgets/backup_content_viewer.dart';
import 'package:spooky/widgets/sp_nested_navigation.dart';
import 'show_backup_source_view.dart';

class ShowBackupSourceViewModel extends BaseViewModel {
  final ShowBackupSourceRoute params;

  ShowBackupSourceViewModel({
    required this.params,
  }) {
    load();
  }

  CloudFileListObject? get cloudFiles => _cloudFiles;
  CloudFileListObject? _cloudFiles;

  bool _disabledActions = true;
  bool get disabledActions => _disabledActions;

  Future<void> load() async {
    _cloudFiles = await params.source.fetchAllCloudFiles();
    _disabledActions = false;
    notifyListeners();
  }

  Future<void> delete(CloudFileObject file, BuildContext context) async {
    OkCancelResult userAction = await showOkCancelAlertDialog(
      context: context,
      title: "Are you sure to delete this file from Cloud?",
      message: "You can't undo this action!",
      isDestructiveAction: true,
      okLabel: "Delete",
    );

    if (userAction == OkCancelResult.cancel) return;

    _disabledActions = true;
    notifyListeners();

    await params.source.deleteCloudFile(file);
    await load();

    if (context.mounted) reloadSyncedFile(file, context);
  }

  void reloadSyncedFile(CloudFileObject file, BuildContext context) {
    bool deleteFileSameAsCurrentlySycedFile = params.source.syncedFile?.id == file.id;
    if (!deleteFileSameAsCurrentlySycedFile) return;

    context.read<BackupSourcesProvider>().reloadSyncedFile(params.source);
  }

  Future<void> onPopInvokedWithResult(bool didPop, dynamic result, BuildContext context) async {
    if (didPop) return;
    if (!disabledActions) Navigator.of(context).pop(result);
  }

  Map<String, BackupObject> loadedBackups = {};

  void openBackup(
    BuildContext context,
    CloudFileObject cloudFile,
  ) async {
    BackupObject? backup = loadedBackups[cloudFile.id] ??
        await MessengerService.of(context).showLoading(
          future: () => params.source.getBackup(cloudFile),
          debugSource: '$runtimeType#openBackup',
        );

    if (backup != null && context.mounted) {
      loadedBackups[cloudFile.id] = backup;
      SpNestedNavigation.maybeOf(context)?.push(BackupContentViewer(backup: backup));
    }
  }
}
