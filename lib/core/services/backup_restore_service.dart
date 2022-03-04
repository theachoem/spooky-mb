import 'package:spooky/core/file_manager/managers/story_manager.dart';
import 'package:spooky/core/models/backup_model.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/models/story_query_options_model.dart';
import 'package:spooky/core/types/file_path_type.dart';

class BackupRestoreService {
  final StoryManager manager = StoryManager();

  // 2020_1646123928000.json
  Future<List<BackupModel>> generateBackups() async {
    Set<int>? years = await manager.fetchYears();

    List<BackupModel> backupEachYears = [];
    if (years != null) {
      for (int year in years) {
        BackupModel? backup = await generateBackupsForAYears(year);
        if (backup != null) {
          backupEachYears.add(backup);
        }
      }
    }

    return backupEachYears;
  }

  Future<BackupModel?> generateBackupsForAYears(int year) async {
    List<StoryModel>? result =
        await manager.fetchAll(options: StoryQueryOptionsModel(filePath: FilePathType.docs, year: year));
    if (result != null) {
      return BackupModel(
        year: year,
        createdAt: DateTime.now(),
        stories: result,
      );
    }
    return null;
  }
}
