part of backup;

// construct backup file
mixin BackupConstructor {
  final StoryDatabase database = StoryDatabase();

  // 2020_1646123928000.json
  Future<List<BackupModel>> generateBackups() async {
    Set<int>? years = await database.fetchYears();

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
    BaseDbListModel<StoryDbModel>? result = await database.fetchAll(
      params: StoryQueryOptionsModel(
        type: PathType.docs,
        year: year,
      ).toJson(),
    );
    if (result != null) {
      return BackupModel(
        year: year,
        createdAt: DateTime.now(),
        stories: result.items,
      );
    }
    return null;
  }
}
