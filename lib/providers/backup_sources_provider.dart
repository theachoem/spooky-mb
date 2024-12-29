import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/objects/backup_object.dart';
import 'package:spooky/core/services/backup_sources/base_backup_source.dart';
import 'package:spooky/core/services/backup_sources/google_drive_backup_source.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/core/services/restore_backup_service.dart';
import 'package:spooky/views/home/home_view_model.dart';

class BackupSourcesProvider extends ChangeNotifier {
  late final List<BaseBackupSource> backupSources = [
    GoogleDriveBackupSource(),
  ];

  bool _loading = true;
  bool get loading => _loading;

  DateTime? _lastDbUpdatedAt;
  DateTime? get lastDbUpdatedAt => _lastDbUpdatedAt;

  BackupSourcesProvider() {
    for (var database in BaseBackupSource.databases) {
      database.addGlobalListener(_databaseListener);
    }
    load();
  }

  Future<void> load() async {
    _lastDbUpdatedAt = await getLastUpdatedAt();

    for (final source in backupSources) {
      await source.load(lastDbUpdatedAt: lastDbUpdatedAt);
    }

    _loading = false;
    notifyListeners();
  }

  void _databaseListener() async {
    debugPrint('BackupSourcesProvider#_databaseListener');
    _lastDbUpdatedAt = await getLastUpdatedAt();
    notifyListeners();
  }

  bool canBackup(BaseBackupSource source) {
    return _lastDbUpdatedAt != null && _lastDbUpdatedAt != source.lastSyncedAt;
  }

  Future<void> backup(BaseBackupSource source) async {
    await source.backup(lastUpdatedAt: lastDbUpdatedAt!);
    notifyListeners();
  }

  Future<void> signIn(BaseBackupSource source) async {
    await source.signIn();
    notifyListeners();
  }

  Future<void> signOut(BaseBackupSource source) async {
    await source.signOut();
    notifyListeners();
  }

  Future<void> restore(BackupObject backup, BuildContext context) async {
    MessengerService.of(context).showLoading(
      debugSource: '$runtimeType#restore',
      future: () => RestoreBackupService().restore(backup: backup),
    );
    await context.read<HomeViewModel>().load();
  }

  Future<DateTime?> getLastUpdatedAt() async {
    DateTime? updatedAt;

    for (var db in BaseBackupSource.databases) {
      DateTime? newUpdatedAt = await db.getLastUpdatedAt();
      if (newUpdatedAt == null) continue;

      if (updatedAt != null) {
        if (newUpdatedAt.isBefore(updatedAt)) continue;
        updatedAt = newUpdatedAt;
      } else {
        updatedAt = newUpdatedAt;
      }
    }

    return updatedAt;
  }

  @override
  void dispose() {
    for (var database in BaseBackupSource.databases) {
      database.removeGlobalListener(_databaseListener);
    }

    super.dispose();
  }

  void reloadSyncedFile(BaseBackupSource source) async {
    await source.loadSyncedFile(lastDbUpdatedAt);
    notifyListeners();
  }
}
