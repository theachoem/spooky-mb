import 'package:spooky/core/backups/destinations/backup_destination_config.dart';
import 'package:spooky/core/backups/destinations/base_backup_destination.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/db/databases/story_database.dart';

class CloudStoragesViewModel extends BaseViewModel {
  late final List<BaseBackupDestination> destinations;
  CloudStoragesViewModel() {
    destinations = BackupDestinationConfig.destinations;
    load();
  }

  int docsCount = 0;
  bool get hasStory => docsCount > 0;

  load() async {
    docsCount = StoryDatabase.instance.getDocsCount(null);
  }

  bool get backupable => docsCount > 0;
}
