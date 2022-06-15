import 'package:spooky/core/backups/models/backups_model.dart';

mixin BackupsCachable {
  final Map<String, BackupsModel> _cachedDownloads = {};

  BackupsModel? isDownloaded(String cloudFileId) {
    return _cachedDownloads[cloudFileId];
  }

  void setCache(String id, BackupsModel backup) {
    _cachedDownloads[id] = backup;
  }
}
