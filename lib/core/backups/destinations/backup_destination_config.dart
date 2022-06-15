import 'package:spooky/core/backups/destinations/base_backup_destination.dart';
import 'package:spooky/core/backups/destinations/gdrive_backup_destination.dart';

class BackupDestinationConfig {
  static List<BaseBackupDestination> destinations = [
    GDriveBackupDestination(),
  ];
}
