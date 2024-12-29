import 'package:flutter/material.dart';
import 'package:spooky/core/services/backup_sources/base_backup_source.dart';
import 'package:spooky/core/services/backup_sources/google_drive_backup_source.dart';

class BackupSourcesProvider extends ChangeNotifier {
  late final List<BaseBackupSource> backupSources = [
    GoogleDriveBackupSource(
      onIsSignedInChanged: () => notifyListeners(),
    ),
  ];

  bool _loading = true;
  bool get loading => _loading;

  BackupSourcesProvider() {
    load();
  }

  Future<void> load() async {
    for (final source in backupSources) {
      await source.load();
    }

    _loading = false;
    notifyListeners();
  }
}
