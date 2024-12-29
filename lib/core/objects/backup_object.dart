import 'package:spooky/core/objects/backup_file_object.dart';

class BackupObject {
  final Map<String, dynamic> tables;
  final BackupFileObject fileInfo;

  BackupObject({
    required this.tables,
    required this.fileInfo,
  });

  Map<String, Map<String, dynamic>> toContents() {
    return {
      'tables': tables,
      'meta_data': {
        'device_model': fileInfo.device.model,
        'device_id': fileInfo.device.id,
        'created_at': fileInfo.createdAt.toIso8601String(),
      }
    };
  }

  get() {}
}
