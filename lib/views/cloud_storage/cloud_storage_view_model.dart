import 'package:spooky/core/backup/backup_service.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/db/databases/story_database.dart';
import 'package:spooky/core/file_manager/managers/backup_file_manager.dart';
import 'package:spooky/core/models/backup_model.dart';

class YearCloudModel {
  final int year;
  final bool synced;

  YearCloudModel({
    required this.year,
    required this.synced,
  });
}

class CloudStorageViewModel extends BaseViewModel {
  List<YearCloudModel>? years;

  CloudStorageViewModel() {
    load();
  }

  Future<void> load() async {
    await loadYears();
    notifyListeners();
  }

  // load year whether it is synced or not
  Future<void> loadYears() async {
    List<YearCloudModel> years = [];
    Set<int>? intYears = await StoryDatabase().fetchYears();
    List<BackupModel>? backups = await BackupFileManager().fetchAll();
    List<int> syncedYears = backups.map((e) => e.year).toList();

    if (intYears != null) {
      for (int y in intYears) {
        years.add(
          YearCloudModel(
            year: y,
            synced: syncedYears.contains(y),
          ),
        );
      }
      this.years = years;
    }
  }

  Future<void> backup(int year) async {
    turnOnLoading(year);
    await BackupService().backup(year);
    await loadYears();
    turnOffLoading(year);
  }

  // UI
  Set<int> loadingYears = {};
  void turnOnLoading(int year) {
    loadingYears.add(year);
    notifyListeners();
  }

  void turnOffLoading(int year) {
    loadingYears.remove(year);
    notifyListeners();
  }
}
