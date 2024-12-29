import 'package:googleapis/drive/v3.dart' as drive;
import 'package:spooky/core/objects/backup_file_object.dart';

class CloudFileObject {
  final String? fileName;
  final String id;
  final String? description;

  CloudFileObject({
    required this.fileName,
    required this.id,
    required this.description,
  });

  factory CloudFileObject.fromGooglDrive(drive.File file) {
    return CloudFileObject(
      fileName: file.name,
      id: file.id!,
      description: file.description,
    );
  }

  BackupFileObject? getFileInfo() {
    if (fileName == null) return null;
    return BackupFileObject.fromFileName(fileName!);
  }
}
