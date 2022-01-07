import 'dart:io';
import 'package:spooky/core/file_manager/docs_manager.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends IndexTrackingViewModel {
  late int year;
  final DocsManager docsManager = DocsManager();

  final void Function(int index) onTabChange;
  final void Function(int year) onYearChange;
  final void Function(void Function()) onListReloaderReady;
  HomeViewModel(this.onTabChange, this.onYearChange, this.onListReloaderReady) {
    year = DateTime.now().year;
  }

  void setYear(int? selectedYear) {
    if (year == selectedYear || selectedYear == null) return;
    year = selectedYear;
    notifyListeners();
    onYearChange(year);
  }

  Future<List<int>> fetchYears() async {
    Directory root = Directory(docsManager.rootPath);
    if (await root.exists()) {
      List<FileSystemEntity> result = root.listSync();
      List<String> years = result.map((e) => e.absolute.path.replaceFirst(DocsManager().rootPath + "/", "")).toList();
      Set<int> yearsInt = {};
      for (String e in years) {
        int? y = int.tryParse(e);
        if (y != null) {
          yearsInt.add(y);
        }
      }
      yearsInt.add(year);
      return yearsInt.toList();
    }
    return [year];
  }
}
